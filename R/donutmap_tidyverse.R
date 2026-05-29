load_all("../tmap")
load_all("../tmap.networks")
load_all("../tmap.glyphs")

library(tmapverse)

library(sf)
library(sfnetworks)
library(dplyr)
library(tidyr)
library(lwgeom)


# ── Setup ──────────────────────────────────────────────────────────────────────
od         <- read.csv2("data/od.csv")
muni_point <- read.csv2("data/muni_point.csv") |>
	st_as_sf(coords = c("POINT_X", "POINT_Y"), crs = 28992)

str(od)
str(muni_point)

(name_highlight <- c("Amsterdam", "Rotterdam", "Den Haag", "Utrecht"))
(code_highlight <- muni_point$code[match(name_highlight, muni_point$name)])


# types
class(od$from)        # should be integer
class(od$to)          # should be integer
class(muni_point$code) # should be integer

# codes match
code_highlight
any(is.na(code_highlight))           # should be FALSE
all(code_highlight %in% od$from)     # should be TRUE
all(code_highlight %in% od$to)       # should be TRUE

# a few rows
head(od)
head(muni_point)

categorise <- function(x, ref = NULL, lvls = donut_levels) {
	if (is.null(ref)) ref <- rep(NA_integer_, length(x))
	factor(
		case_when(
			x %in% code_highlight ~ name_highlight[match(x, code_highlight)],
			x == ref              ~ "home",
			TRUE                  ~ "other"
		),
		levels = lvls
	)
}

categorise(od$to[1:10], lvls = c(name_highlight, "other"))

donut_levels <- c(name_highlight, "other", "home")

# "residents" = where do people who live here go to work?
# "jobs"      = where do people who work here come from?
flow     <- "jobs"      # "residents" or "jobs"
join_col <- if (flow == "residents") "from" else "to"


# test on a small slice that contains known codes
test <- od[od$from %in% code_highlight | od$to %in% code_highlight, ] |> head(20)
test$to_cat   <- categorise(test$to,   ref = test$from)
test$from_cat <- categorise(test$from, ref = test$to)
test


# replicate what aggregate_od does for flow = "jobs" (group by "to", cat = "from_cat")
step1 <- od |>
	mutate(
		to_cat   = categorise(to,   ref = from),
		from_cat = categorise(from, ref = to)
	)

head(step1)
table(step1$from_cat)
table(step1$to_cat)


step2 <- step1 |>
	group_by(to, from_cat) |>
	reframe(jobs = round(sum(jobs)))

head(step2)
nrow(step2)

step3 <- step2 |>
	pivot_wider(id_cols     = "to",
				names_from  = "from_cat",
				values_from = "jobs")

head(step3)
names(step3)


step4 <- step3 |>
	mutate(across(everything(), \(x) replace_na(x, 0))) |>
	rename(home_part = home)

step5 <- step4 |>
	left_join(
		od |> group_by(to) |> reframe(Total = round(sum(jobs))),
		by = "to"
	)

step6 <- step5 |>
	left_join(
		od |>
			dplyr::filter(to == from) |>
			group_by(to) |>
			reframe(home = round(sum(jobs))),
		by = "to"
	) |>
	mutate(home = coalesce(home, home_part))

head(step6)
names(step6)

aggregate_od <- function(flows, group_col, cat_col) {
	flows |>
		mutate(
			to_cat   = categorise(to,   ref = from),
			from_cat = categorise(from, ref = to)
		) |>
		group_by(across(all_of(c(group_col, cat_col)))) |>
		reframe(jobs = round(sum(jobs))) |>
		pivot_wider(id_cols     = all_of(group_col),
					names_from  = all_of(cat_col),
					values_from = "jobs") |>
		mutate(across(everything(), \(x) replace_na(x, 0))) |>
		rename(home_part = home) |>
		left_join(
			flows |>
				group_by(across(all_of(group_col))) |>
				reframe(Total = round(sum(jobs))),
			by = group_col
		) |>
		left_join(
			flows |>
				dplyr::filter(to == from) |>
				group_by(across(all_of(group_col))) |>
				reframe(home = round(sum(jobs))),
			by = group_col
		) |>
		mutate(home = coalesce(home, home_part))
}

od_nodes <- if (flow == "residents") {
	aggregate_od(od, "from", "to_cat")
} else {
	aggregate_od(od, "to", "from_cat")
}

od_edges <- od |>
	mutate(
		to_cat   = categorise(to,   lvls = c(name_highlight, "other")),
		from_cat = categorise(from, lvls = c(name_highlight, "other")),
		label    = paste(muni_point$name[match(from, muni_point$code)],
						 muni_point$name[match(to,   muni_point$code)], sep = " to "),
		Jobs     = round(jobs),
		from_idx = match(from, muni_point$code),
		to_idx   = match(to,   muni_point$code)
	) |>
	select(-from, -to) |>
	rename(from = from_idx, to = to_idx)

table(od_edges$to_cat, useNA = "always")
table(od_edges$from_cat, useNA = "always")


net <- sfnetwork(nodes = muni_point, edges = od_edges, directed = TRUE, node_key = "code") |>
	activate("edges") |>
	sfnetworks::to_spatial_explicit()

net_filtered <- net[[1]] |>
	dplyr::filter(from != to, jobs >= 500)

net_nodes <- net_filtered |>
	activate("nodes") |>
	left_join(od_nodes, by = c("code" = join_col))

net_nodes

tmap_mode("view")

palette = c("#d9328a", "#7d4791", "#da5914", "#53a31d", "#0581a2", "#B3B3B3")


tm_shape(net_nodes) +
	tm_edges(
		lwd        = "Jobs",
		col        = "to_cat",
		from       = 0.5,
		lineend    = "butt",
		lwd.scale  = tm_scale_continuous(values.scale = 15),
		col.scale  = tm_scale_categorical(values = palette, value.neutral = palette[5]),
		col.legend = tm_legend_hide(),
		options    = opt_tm_edges(offset_start = 100),
		id         = "label",
		hover      = "label",
		popup.vars = "Jobs"
	) +
	tm_donuts(
		parts       = tm_vars(c(name_highlight, "other", "home_part"), multivariate = TRUE),
		size        = "Total",
		size.scale  = tm_scale_continuous(values.scale = 2, limits = c(30000, 700000),
										  outliers.trunc = TRUE, values.range = c(0.3, 1)),
		fill.scale  = tm_scale_categorical(values = palette),
		fill.legend = tm_legend(title = "Municipality"),
		size.legend = tm_legend_hide(),
		col         = "white",
		lwd         = 2,
		options     = opt_tm_donuts(fill_hole = "gray95"),
		id          = "name",
		hover       = "name",
		popup.vars  = c(name_highlight, "other", "home", "Total")
	)

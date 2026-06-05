library(shiny)
library(bslib)
library(tmapverse)
library(sf)
library(sfnetworks)
library(dplyr)
library(tidyr)
library(lwgeom)

tmap_mode("view")

# ── Data (shared across sessions) ──────────────────────────────────────────────

od         <- read.csv2("data/NL_commuter_OD_2024.csv")
muni_point <- read.csv2("data/NL_municipality_centroids_2024.csv") |>
	st_as_sf(coords = c("POINT_X", "POINT_Y"), crs = 28992)


palette          <- c("#d9328a", "#7d4791", "#da5914", "#53a31d", "#0581a2", "#B3B3B3")
all_municipalities <- sort(unique(muni_point$name))

# ── Helpers ────────────────────────────────────────────────────────────────────

categorise <- function(x, ref = NULL, lvls, code_highlight, name_highlight) {
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

aggregate_od <- function(flows, group_col, cat_col, code_highlight, name_highlight) {
	donut_levels <- c(name_highlight, "other", "home")
	flows |>
		mutate(
			to_cat   = categorise(to,   ref = from, lvls = donut_levels, code_highlight = code_highlight, name_highlight = name_highlight),
			from_cat = categorise(from, ref = to,   lvls = donut_levels, code_highlight = code_highlight, name_highlight = name_highlight)
		) |>
		group_by(across(all_of(c(group_col, cat_col)))) |>
		reframe(jobs = round(sum(jobs))) |>
		pivot_wider(id_cols = all_of(group_col), names_from = all_of(cat_col), values_from = "jobs") |>
		mutate(across(everything(), \(x) replace_na(x, 0))) |>
		rename(home_part = home) |>
		left_join(
			flows |> group_by(across(all_of(group_col))) |> reframe(Total = round(sum(jobs))),
			by = group_col
		) |>
		left_join(
			flows |> dplyr::filter(to == from) |>
				group_by(across(all_of(group_col))) |> reframe(home = round(sum(jobs))),
			by = group_col
		) |>
		mutate(home = coalesce(home, home_part))
}

build_map <- function(od, muni_point, name_highlight, flow, edge_min, lwd_range) {

	code_highlight <- muni_point$code[match(name_highlight, muni_point$name)]
	donut_levels   <- c(name_highlight, "other", "home")
	join_col       <- if (flow == "residents") "from" else "to"

	# nodes
	od_nodes <- if (flow == "residents") {
		aggregate_od(od, "from", "to_cat", code_highlight, name_highlight)
	} else {
		aggregate_od(od, "to", "from_cat", code_highlight, name_highlight)
	}

	# edges
	od_edges <- od |>
		mutate(
			to_cat   = categorise(to,   lvls = c(name_highlight, "other"), code_highlight = code_highlight, name_highlight = name_highlight),
			from_cat = categorise(from, lvls = c(name_highlight, "other"), code_highlight = code_highlight, name_highlight = name_highlight),
			label    = paste(muni_point$name[match(from, muni_point$code)],
							 muni_point$name[match(to,   muni_point$code)], sep = " to "),
			Jobs     = round(jobs),
			from_idx = match(from, muni_point$code),
			to_idx   = match(to,   muni_point$code)
		) |>
		select(-from, -to) |>
		rename(from = from_idx, to = to_idx)

	# network
	net <- sfnetwork(nodes = muni_point, edges = od_edges, directed = TRUE, node_key = "code") |>
		activate("edges") |>
		sfnetworks::to_spatial_explicit()

	net_nodes <- net[[1]] |>
		dplyr::filter(from != to, jobs >= edge_min) |>
		activate("nodes") |>
		left_join(od_nodes, by = c("code" = join_col))

	# map

	tm_shape(net_nodes) +
		tm_edges(
			lwd        = "Jobs",
			col        = "to_cat",
			from       = 0.5,
			lineend    = "butt",
			lwd.scale  = tm_scale_continuous(values.scale  = lwd_range[2],
											 values.range  = lwd_range / max(lwd_range)),
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
			size.scale  = tm_scale_continuous(values.scale   = 2,
											  limits         = c(30000, 700000),
											  outliers.trunc = TRUE,
											  values.range   = c(0.3, 1)),
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
}

# ── UI ─────────────────────────────────────────────────────────────────────────

ui <- page_sidebar(
	title = "Commuter Flow Explorer",
	theme = bs_theme(bootswatch = "flatly", primary = "#2C6E9B"),

	sidebar = sidebar(
		width = 280,

		h6("Highlighted municipalities", class = "text-muted fw-bold mt-1 mb-2"),
		selectInput("mun1", "Municipality 1", choices = all_municipalities, selected = "Amsterdam"),
		selectInput("mun2", "Municipality 2", choices = all_municipalities, selected = "Rotterdam"),
		selectInput("mun3", "Municipality 3", choices = all_municipalities, selected = "Den Haag"),
		selectInput("mun4", "Municipality 4", choices = all_municipalities, selected = "Utrecht"),

		hr(),

		h6("Flow direction", class = "text-muted fw-bold mb-2"),
		radioButtons(
			"flow", label = NULL,
			choices  = c("Where do residents go to work?" = "residents",
						 "Where do workers come from?"    = "jobs"),
			selected = "jobs"
		),

		hr(),

		h6("Edge filters", class = "text-muted fw-bold mb-2"),
		sliderInput("edge_min", "Minimum flow (jobs)",
					min = 0, max = 5000, value = 500, step = 100),
		sliderInput("lwd_range", "Edge thickness range",
					min = 0.5, max = 30, value = c(1, 15), step = 0.5),

		hr(),
		actionButton("render", "Update map", class = "btn-primary w-100")
	),

	tmapOutput("map", height = "calc(100vh - 80px)")
)

# ── Server ─────────────────────────────────────────────────────────────────────

server <- function(input, output, session) {

	# prevent duplicate municipality selections
	observeEvent(c(input$mun1, input$mun2, input$mun3, input$mun4), {
		selected <- c(input$mun1, input$mun2, input$mun3, input$mun4)
		for (id in c("mun1", "mun2", "mun3", "mun4")) {
			others <- setdiff(selected, input[[id]])
			updateSelectInput(session, id,
							  choices  = c(input[[id]], setdiff(all_municipalities, others)),
							  selected = input[[id]])
		}
	}, ignoreInit = TRUE)

	map_data <- eventReactive(input$render, {
		name_highlight <- c(input$mun1, input$mun2, input$mun3, input$mun4)

		validate(
			need(length(unique(name_highlight)) == 4, "Please select four distinct municipalities.")
		)

		build_map(
			od             = od,
			muni_point     = muni_point,
			name_highlight = name_highlight,
			flow           = input$flow,
			edge_min       = input$edge_min,
			lwd_range      = input$lwd_range
		)
	}, ignoreNULL = FALSE)

	output$map <- renderTmap(map_data())
}

shinyApp(ui, server)

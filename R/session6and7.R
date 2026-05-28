library(tmapverse)

tmap_mode("plot")

tm_shape(World) +
	tm_polygons(fill = "purple", lwd = 2, col = "white")

ttm()

tm_shape(World) +
	tm_polygons(fill = "purple", lwd = 2, col = "white")


tm_shape(World) +
	tm_polygons(fill = "life_exp",
				col = "black",
				lwd = 1)

tm_shape(World) +
	tm_polygons(fill = "life_exp", col = "white", lwd = 1.25) +
tm_borders(col = "black", lwd = 0.5)


tm_shape(World) +
	tm_polygons(fill = "life_exp",
				col = "gray70",
				lwd = 0.5)

tm_shape(World) +
	tm_polygons(fill = "life_exp",
				col = "gray70",
				lwd = 0.75,
				fill.scale = tm_scale_intervals(values = "brewer.prgn", midpoint = 73)
				) +
	tm_basemap(NULL) +
	tm_crs("+proj=robin")

library(cols4all)
c4a_gui()


tm_shape(World) +
	tm_fill(fill = "grey90") +
	tm_shape(World_rivers) +
	tm_lines(col = "steelblue", lwd = 2) +
	tm_shape(metro) +
	tm_bubbles(fill = "gold", size = 0.5)

tm_shape(World) +
	tm_fill(fill = "grey90") +
	tm_shape(World_rivers) +
	tm_lines(col = "steelblue",
			 lwd = "strokelwd",
			 lwd.scale = tm_scale_asis()) +
	tm_shape(metro) +
	tm_bubbles(fill = "gold", size = 0.5)

tm_shape(World) +
	tm_fill(fill = "grey90") +
	tm_shape(World_rivers) +
	tm_lines(col = "steelblue", lwd = "strokelwd", lwd.scale = tm_scale_asis()) +
	tm_shape(metro) +
	tm_symbols(fill = "gold",
			   size = "pop2020",
			   size.scale = tm_scale_continuous(values.scale = 1.75))


tmap_style("cobalt")
tmap_options_reset()

tm_shape(World_rivers) +
	tm_lines(hover = "name")

tm_shape(NLD_dist) +
	tm_text(text =  "name", options = opt_tm_text(clustering = TRUE)) +
	tm_view(use_WebGL = FALSE)

tm_shape(NLD_prov) +
	tm_polygons(fill = "steelblue")

tm_shape(NLD_muni) +
	tm_polygons(fill = "steelblue")

tm_shape(NLD_dist) +
	tm_polygons(fill = "steelblue")

tm_shape(NLD_dist) +
	tm_polygons(fill = "dwelling_value")

tm_shape(NLD_dist) +
	tm_polygons(fill = "dwelling_value",
				col = NULL,
				fill.scale = tm_scale_intervals(values = "-brewer.prgn", style = "kmeans", n = 7)) +
	tm_shape(NLD_muni) +
	tm_borders(lwd = 1, col = "black") +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 2, col = "black")

tm_shape(NLD_dist) +
	tm_polygons(
		fill = "dwelling_value",
		col = NULL,
		fill.scale = tm_scale_continuous_pseudo_log(values = "-brewer.prgn")) +
	tm_shape(NLD_muni) + tm_borders(lwd = 1) +
	tm_shape(NLD_prov) + tm_borders(lwd = 2)

tm_shape(NLD_dist) +
	tm_polygons(
		fill = "dwelling_value",
		col = NULL,
		fill.scale = tm_scale_intervals(style = "kmeans", n = 5,
										values = "plasma")) +
	tm_shape(NLD_muni) + tm_borders(lwd = 1) +
	tm_shape(NLD_prov) + tm_borders(lwd = 2)

tm_basemap("CartoDB.Positron") +
	tm_shape(NLD_dist) +
	tm_polygons(
		fill = "dwelling_value",
		col = NULL,
		fill.scale = tm_scale_intervals(style = "kmeans", n = 5,
										values = "plasma"),
		fill.legend = tm_legend(title = "WOZ value (×€1 000)",
								position = c("right", "top")),
		group = "Choropleth") +
	tm_shape(NLD_muni) + tm_borders(lwd = 1, group = "Choropleth") +
	tm_shape(NLD_prov) + tm_borders(lwd = 2, group = "Choropleth") +
	tm_scalebar()



tmap_mode("view")

# hover is on by default when id is set — shows country name on hover
tm_shape(World) +
	tm_polygons(fill = "HPI", id = "iso_a3", hover = "name")

tmap_mode("view")

tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		id = "iso_a3",
		popup.vars = c("Name" =  "name", "Happy Planet Index" =  "HPI", "Life Expectancy" = "life_exp", "GDP estimate" = "gdp_cap_est")
	)

World$label = paste("This country has a HPI of <strong>", round(World$HPI), "</strong>")

tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		hover = "label",
		popup.vars = c("Name" =  "name", "Happy Planet Index" =  "HPI", "Life Expectancy" = "life_exp", "GDP estimate" = "gdp_cap_est", " " = "label"),
		popup.format = tm_label_format(html.escape = FALSE)

	)

library(mapview)

mapview(World) + mapview(World_rivers)

tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		hover = "label",
		popup.vars = c("Name" =  "name", "Happy Planet Index" =  "HPI", "Life Expectancy" = "life_exp", "GDP estimate" = "gdp_cap_est", " " = "label"),
		popup.format = tm_label_format(fun = function(x) {
			paste(floor(x), "DOT", round(x - floor(x), 3) * 1000)
		})

	)

tm_shape(World) +
	tm_polygons(fill = "HPI",
				fill.scale = tm_scale_intervals(label.format = tm_label_format(interval.disjoint = FALSE, text.separator = "to (not included)")))


tm_shape(World) +
  tm_polygons(
    fill = "HPI",
	fill.scale =
      tm_scale_intervals(
      	breaks = c(0, 20, 40, Inf),
      	label.format =
          tm_label_format(
          	interval.disjoint = FALSE,
          	text.separator = "to (not included)",
          	text.or.more = "At least")))

tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		fill.scale =
			tm_scale_intervals(
				breaks = c(0, 20, 40, Inf),
				label.format =
					tm_label_format(
						interval.disjoint = FALSE,
						text.separator = "to (not included)",
						text.or.more = "or more",
						text.or.more_as.prefix = FALSE)))


tm_shape(World) +
	tm_polygons(
		fill = "gdp_cap_est",
		fill.scale = tm_scale_intervals(
			style = "kmeans", n = 5,
			label.format = tm_label_format(
				prefix         = "$",
				text.separator = "to",
				digits         = 0
			)
		)
	)

tm_shape(World) +
	tm_polygons() +
	tm_shape(metro) +
	tm_bubbles(
		size = "pop2020",
		size.scale = tm_scale_continuous(
			label.format = tm_label_format(big.num.abbr = c(million = 6))
		),
		popup.format = list(
			pop2020 = tm_label_format(digits = 2))
	)

tmap_mode("view")

tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		popup.vars = c("name", "HPI", "gdp_cap_est", "pop_est"),
		popup.format = list(
			HPI         = tm_label_format(digits = 1),
			gdp_cap_est = tm_label_format(prefix = "$", big.num.abbr = c(k = 3)),
			pop_est     = tm_label_format(
				fun = function(x) paste("About", round(x/1e6), "million"))
		)
	)

World$HPI_fmt <- paste0("<i>", round(World$HPI, 1), "</i>")

tmap_mode("view")

tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		id = "name",
		popup.vars = c("Country" = "name", "HPI" = "HPI_fmt"),
		popup.format = list(
			HPI_fmt = tm_label_format(html.escape = FALSE)
		)
	)


tm_shape(metro) +
	tm_bubbles(fill = "pop2020", size = 2,
			   fill.legend = tm_legend(orientation = "portrait", reverse = TRUE))

tm_shape(metro) +
	tm_bubbles(fill = "pop2020", size = "pop2020",
			   size.scale = tm_scale_continuous(values.scale = 1.5, ticks = c(5, 10, 20, 30) * 1e6),
			   fill.legend = tm_legend(orientation = "portrait", reverse = TRUE),
			   size.legend = tm_legend(orientation = "landscape", reverse = FALSE))

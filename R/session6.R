tm_shape(World) +
	tm_polygons(fill = "HPI", id = "iso_a3", hover = "name")

tm_shape(World) +
	tm_polygons(fill = "HPI", hover = "name")

tm_shape(World) +
	tm_polygons(fill = "HPI", hover = "name", popup = FALSE)

tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		hover = "name",
		popup = tm_popup(
			vars = c("Happy Planet Index" = "HPI", "Economy class" = "economy", "Well being" = "well_being", "Life expectancy" = "life_exp"),
			title = "name",
			label.color = "darkblue",
			title.color = "purple", width = "20em"))

tmap_mode("plot")
tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		hover = "name",
		fill.scale = tm_scale_intervals(label.style = "continuous"),
		popup = tm_popup(
			vars = c("Happy Planet Index" = "HPI", "Economy class" = "economy", "Well being" = "well_being", "Life expectancy" = "life_exp"),
			title = "name",
			label.color = "darkblue",
			title.color = "purple", width = "20em"))


tmap_mode("view")
tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		hover = "name",
		fill.scale = tm_scale_intervals(label.format = tm_label_format(interval.disjoint = FALSE, text.separator = " to "),
										label.na = "No data"),
		fill.legend = tm_legend("Happy Planet Index"),
		popup = tm_popup(
			vars = c("Happy Planet Index" = "HPI", "Economy class" = "economy", "Well being" = "well_being", "Life expectancy" = "life_exp"),
			title = "name",
			label.color = "darkblue",
			title.color = "purple", width = "20em"))

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
			label.format = tm_label_format(big.num.abbr = c("ten millions" = 7))
		)
	)


tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		popup = tm_popup(
			vars = c("name", "HPI", "gdp_cap_est", "pop_est"),
			format = list(
				HPI         = tm_label_format(digits = 1),
				gdp_cap_est = tm_label_format(prefix = "$", big.num.abbr = c(k = 3)),
				pop_est     = tm_label_format(
					fun = function(x) {
						ifelse(x > 1e9,
							   paste("About", round(x/1e9, 1), "billion"),
							   paste("About", round(x/1e6), "million"))
					})
		))
	)

World$HPI_fmt <- paste0("<strong>", round(World$HPI, 1), "</strong>")

tmap_mode("view")

tm_shape(World) +
	tm_polygons(
		fill = "HPI",
		id = "name",
		popup = tm_popup(
			vars = c("Country" = "name", "HPI" = "HPI_fmt"),
			format = list(
				HPI_fmt = tm_label_format(html.escape = FALSE)
			))
	)

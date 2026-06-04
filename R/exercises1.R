library(tmapverse)

?World

tm_shape(World) +
	tm_polygons(col = "white",
				fill = "purple",
				lwd = 2)

tmap_mode("view")

tm_shape(World) +
	tm_polygons(col = "white",
				fill = "purple",
				lwd = 2)

tm1 = tm_shape(World) +
	tm_polygons(fill = "life_exp",
				col = "gray70")

tm2 = tm_shape(World) +
	tm_polygons(fill = "life_exp",
				col = "gray70") +
	tm_basemap(NULL) +
	tm_crs("auto")

tmap_arrange(tm1, tm2)

tm_shape(World) +
	tm_cartogram(fill = "life_exp",
				 size = "pop_est",
				 col = "gray70") +
	tm_basemap(NULL) +
	tm_crs("auto")


tm_shape(World) +
	tm_cartogram_ncont(fill = "life_exp",
				 size = "pop_est",
				 col = "gray70") +
	tm_basemap(NULL) +
	tm_crs("auto")


tm_shape(World) +
	tm_cartogram_dorling(fill = "life_exp",
					   size = "pop_est",
					   col = "gray70") +
	tm_basemap(NULL) +
	tm_crs("auto")

####

tm_shape(World) +
    tm_polygons(fill  = "grey", col = "grey") +
tm_shape(World_rivers) +
	tm_lines(col = "blue", lwd = 1.5) +
tm_shape(metro) +
	tm_bubbles(fill = "gold", size = 0.5)


tm_shape(World) +
	tm_polygons(fill  = "grey95", col = "grey", group = "Land") +
tm_shape(World_rivers) +
	tm_lines(col = "lightblue",
			 lwd = "strokelwd",
			 lwd.scale = tm_scale_asis(), group = "Rivers") +
	tm_shape(metro) +
	tm_bubbles(fill = "gold",
			   size = "pop2020",
			   size.scale = tm_scale(values.scale = 1.5),
			   group = "Cities")

tmap_mode("maplibre")
tmap_mode("view")

data("NLD_prov"); data("NLD_muni"); data("NLD_dist")

tm1 = tm_shape(NLD_prov) + tm_polygons(fill = "steelblue")
tm2 = tm_shape(NLD_muni) + tm_polygons(fill = "steelblue")
tm3 = tm_shape(NLD_dist) + tm_polygons(fill = "steelblue") +tm_view(use_WebGL = FALSE)

tmap_arrange(tm1, tm2, tm3, nrow = 1, sync = TRUE)


tm_shape(NLD_dist) + tm_fill(fill = "dwelling_value",
							 fill.scale = tm_scale_intervals(style = "kmeans", n = 9)) +
tm_shape(NLD_muni) + tm_borders(col = "grey30", lwd = 1) +
tm_shape(NLD_prov) + tm_borders(col = "black", lwd = 2)


tm_shape(NLD_dist) + tm_fill(fill = "dwelling_value",
							 fill.scale = tm_scale_continuous_pseudo_log()) +
	tm_shape(NLD_muni) + tm_borders(col = "grey30", lwd = 1) +
	tm_shape(NLD_prov) + tm_borders(col = "black", lwd = 2)



c4a_gui()


tm_shape(NLD_dist) + tm_fill(fill = "dwelling_value",
							 fill.scale = tm_scale_intervals(style = "kmeans", n = 9, values = "-ag_sunset")) +
	tm_shape(NLD_muni) + tm_borders(col = "grey30", lwd = 1) +
	tm_shape(NLD_prov) + tm_borders(col = "black", lwd = 2)

tm_basemap("CartoDB.Positron") +
	tm_shape(NLD_dist) +
	tm_polygons(
		fill = "dwelling_value",
		col = NULL,
		fill.scale = tm_scale_intervals(style = "kmeans", n = 5,
										values = "plasma"),
		fill.legend = tm_legend(title = "WOZ value (×€1 000)",
								position = c("right", "top"),
								reverse = TRUE)) +
	tm_shape(NLD_muni) + tm_borders(lwd = 1) +
	tm_shape(NLD_prov) + tm_borders(lwd = 2) +
	tm_scalebar()

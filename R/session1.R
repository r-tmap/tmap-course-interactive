library(tmapverse)

#library(tmap)
#library(tmap.mapgl)

tmap_mode("plot") # default (static) plot mode
tmap_mode("view") # view (leaflet) mode
tmap_mode("maplibre")


tm_shape(World) +
	tm_polygons("gold")

tm_shape(World) +
	tm_polygons("HPI")


library(sf)

q = function(x) {
	r = rank(x)
	r[is.na(x)] = NA
	r = r / max(r, na.rm = TRUE)
	r
}

World$norm_well_being = q((World$well_being / 8))
World$norm_footprint = q(((50 - World$footprint) / 50))
World$norm_inequality = q(((65 - World$inequality) / 65))
World$norm_press = q(1 - ((100 - World$press) / 100))
World$norm_gender = q(1 - World$gender)


tm_shape(World) +
	tm_polygons(fill = "white", popup.vars = FALSE) +
	tm_shape(World) +
	tm_flowers(parts = tm_vars(c("norm_gender", "norm_press", "norm_footprint", "norm_well_being", "norm_inequality"), multivariate = TRUE),
			   fill.scale = tm_scale(values = "friendly5"),
			   size = 1, popup.vars = c("norm_gender", "norm_press", "norm_footprint", "norm_well_being","norm_inequality"), id = "name") +
	tm_basemap(NULL) +
	tm_layout(bg.color = "grey90")



tm_shape(World) +
	tm_polygons("#ff0055")


names(World)

tm_shape(World) +
	tm_polygons(
		fill = "inequality")


tm_shape(World) +
	tm_polygons(
		fill = "#ffdd93",
		col = "grey60",
		lwd = 1) +
tm_shape(World_rivers) +
	tm_lines(col = "blue",
			 lwd = 2)


tm_shape(World) +
	tm_polygons(
		fill = "inequality",
		col = "continent",
		lwd = "pop_est",
		lwd.scale = tm_scale_continuous(values.scale = 10))

tm_shape(World) +
	tm_polygons(
		fill = "inequality",
		fill.scale = tm_scale_intervals(values = "pu_gn_div"),
		fill.legend = tm_legend("Economic inequality"),
		lwd = "pop_est",
		lwd.scale = tm_scale_continuous(values.scale = 5),
		lwd.legend = tm_legend("Population estimate")) +
tm_credits("made with tmap")

?tmap


tm_shape(NLD_muni) +            # Shape (group 1)
	tm_polygons(                  # Layer: data-driven fill
		fill = "income_high",
		fill.scale = tm_scale_continuous(values = "brewer.purples"),
		fill.legend = tm_legend(title = "Income")) +
	tm_shape(NLD_prov) +            # Shape (group 2)
	tm_borders(col = "black", lwd = 2) +
	tm_text(text = "name") +
	tm_basemap("Esri.WorldTerrain") +    # auxiliary layer
	tm_compass() +                       # map component
	tm_scalebar()

tm_shape(World) +
	tm_polygons(fill = "economy")

tm_shape(World) +
	tm_polygons(fill = "gdp_cap_est",
				fill.scale = tm_scale_continuous())

tm_shape(World) +
	tm_polygons(fill = "gdp_cap_est",
				fill.scale = tm_scale_continuous_log())

tm_shape(World) +
	tm_polygons(fill = "gdp_cap_est",
				fill.scale = tm_scale_intervals(label.format = tm_label_format(interval.disjoint = FALSE)))


tm_shape(World) +
	tm_polygons(fill = "gdp_cap_est",
				fill.scale = tm_scale_intervals(
					label.style = "continuous",
					label.format = tm_label_format(interval.disjoint = FALSE)))


World$is_netherlands = ifelse(World$name == "Netherlands",  "orange", "grey")

tm_shape(World) +
	tm_symbols(fill = "is_netherlands",
			   fill.scale = tm_scale_asis())
View(World)

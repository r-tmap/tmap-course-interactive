tmap_overview()

tmap_mode("plot")

tm_shape(World) +
	tm_polygons("HPI",
				fill.chart = tm_chart_bar(position = tm_pos_in("left", "bottom")))

tm_shape(World) +
	tm_polygons("HPI",
				fill.chart = tm_chart_bar(position = tm_pos_out("left", "bottom")))

tm_shape(World) +
	tm_polygons("HPI",
				fill.chart = tm_chart_bar(position = tm_pos_out("left", "center")))

tm_shape(World) +
	tm_polygons("HPI",
				fill.chart = tm_chart_bar(position = c("LEFT", "BOTTOM")))

tm_shape(World) +
	tm_polygons("HPI",
				fill.chart = tm_chart_bar(position = c(0.5, 0.5)))

tmap_mode("view")

tmap_options_reset()

tm_shape(NLD_muni) +
	tm_polygons("income_high",
				fill.legend = tm_legend("High income households",
										group_id = "A")) +
	tm_compass(group_id = "B") +
	tm_scalebar(breaks = c(0, 10, 25, 50), group_id = "B") +
	tm_components("A", position = c("left", "top"),    frame = TRUE) +
	tm_components("B", position = c("right", "bottom"),  frame = FALSE) +
	tm_minimap()

tm_shape(NLD_muni) +
	tm_polygons("income_high") +
	tm_minimap() +
	tm_basemap(NULL)


tmap_style("cobalt")

tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons("population") +
	tm_minimap(position = c("left", "bottom"),
			   toggle = TRUE,        # collapsible
			   minimized = FALSE)

tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons() +
	tm_mouse_coordinates(position = c("right", "bottom")) +
	tm_crs(28992) +
	tm_basemap(NULL)


tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons("population",
				hover = "name") +
	tm_title("Dutch municipalities",
			 position = c("left", "top")) +
	tm_scalebar(position = c("left", "bottom"))

tmap_mode("plot")
tm_shape(World) +
	tm_polygons()

# make new style

tmap_options(
	bg.color = "steelblue",
	outer.bg = TRUE,
	outer.bg.color = "salmon",
	frame.color = "purple3",
	frame.lwd = 5,
	compass.type = "8star",
	legend.bg.color = "gold",
	legend.position = tm_pos_in(pos.h = "left", pos.v = "top")
)

tm_shape(World) +
	tm_polygons()

tmap_options_save("fancy")

# switch styles
tmap_style("cobalt")

tm_shape(World) +
	tm_polygons()

tmap_style("fancy")

tm_shape(World) +
	tm_polygons()

# save the style for later
opt = tmap_options()

saveRDS(opt, "tmap_options.rds")

# new session
opt = readRDS("tmap_options.rds")

# reload the options
tmap_options(opt)

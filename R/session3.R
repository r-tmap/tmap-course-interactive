tmap_overview()

tmap_mode("plot")

tm_shape(NLD_muni) +
	tm_dots() +
	tm_title("My title", position = tm_pos_in("left", "center"))


tm_shape(NLD_muni) +
	tm_dots() +
	tm_title("My title", position = tm_pos_in("left", "bottom"))



tm_shape(NLD_muni) +
	tm_dots() +
	tm_title("My title", position = tm_pos_out("left", "bottom"))

tmap_mode("view")

tm_shape(NLD_muni) +
	tm_symbols(fill = "dwelling_value",
			   fill.legend = tm_legend(position = tm_pos_in("right", "top"))) +
	tm_title("My title", position = tm_pos_in("right", "bottom"))


opt = tmap_options()
library(lobstr)
tree(opt)

tmap_mode("plot")
tm_shape(World) +
	tm_polygons("gold") +
	tm_layout(bg.color = "purple")

ttm()

tm_shape(World) +
	tm_polygons("gold")

tmap_style("cobalt")

tm_shape(World) +
	tm_polygons("gold")

tmap_style("classic")

tm_shape(World) +
	tm_polygons("gold") +
	tm_text("name", options = opt_tm_text(remove_overlap = TRUE))

tmap_options_reset()

tmap_mode("view")
tm_shape(World) +
	tm_polygons("gold") +
	tm_text("name", options = opt_tm_text(remove_overlap = TRUE, clustering = TRUE))


tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons("population") +
	tm_minimap(position = c("left", "bottom"),
			   toggle = TRUE,        # collapsible
			   minimized = FALSE)

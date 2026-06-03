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

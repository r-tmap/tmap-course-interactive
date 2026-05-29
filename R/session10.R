library(tmap)

tmap_mode("plot")
(tm = tm_shape(World) + tm_polygons("press", fill.scale = tm_scale_intervals(values = "rainbow")) + tm_crs("`auto`"))

tm

tmap_save(tm, filename = "World.pdf", width = 8, height = 5)

tmap_save(tm, filename = "World_srgb.pdf", width = 8, height = 5, colormodel = "srgb")
tmap_save(tm, filename = "World_cmyk.pdf", width = 8, height = 5, colormodel = "cmyk")

tmap_mode("maplibre")
tmap_save(tm, filename = "World.html", in.iframe = TRUE)

tmap_mode("plot")


m <- tm_shape(World) +
	tm_fill("#dddddd") +
	tm_shape(metro) +
	tm_bubbles(
		size = paste0("pop", seq(1960, 2030, by = 10)),
		size.scale = tm_scale_continuous(values.scale = 2),
		size.legend = tm_legend("Population"),
		fill = "gold",
		size.free = FALSE) +
	#tm_facets(nrow = 2) +
	tm_animate(fps = 10, play = "pingpong") +
	tm_layout(panel.show = FALSE) +
	tm_title(seq(1960, 2030, by = 10), position = tm_pos_in("left", "bottom")) +
	tm_crs("auto")

print(m)


tmap_mode("view")

tm_shape(World) +
	tm_polygons(c("HPI", "economy")) +
	tm_facets(sync = TRUE)

m1 = tm_shape(World) +
	tm_polygons("HPI")

m2 = tm_shape(World) +
	tm_polygons("HPI")

tmap_arrange(m1, m2, sync = TRUE)

tm_shape(World) +
	tm_polygons("HPI") +
	tm_facets(by = "continent", sync = FALSE)


tmap_animation(m, filename = "metro_growth.gif", height = 1200, width = 2400, dpi = 300)
tmap_animation(m, filename = "metro_growth.mp4", width = 1200, height = 600, dpi = 150)




Africa = World[World$continent == "Africa", ]

tm_shape(Africa, crs = "+proj=robin") +
	tm_cartogram(
		size = "*pop_est",
		fill = "life_exp",
		fill.scale = tm_scale_intervals(values = "-cols4all.bu_br_div"),
		fill.legend = tm_legend("Age"),
		options = opt_tm_cartogram(itermax = 15)) +
	tm_text("name") +
	tm_title("Life Expectancy") +
	tm_animate_fast(play = "pingpong")

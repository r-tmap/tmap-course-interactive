library(tmap)

(tm = tm_shape(World) + tm_polygons("press") + tm_crs("auto"))

tmap_save(tm, filename = "world1.png", width = 2000, height = 1000)
tmap_save(tm, filename = "world2.png", width = 8, height = 4)


tm2 = tm_shape(World) + tm_polygons("press", fill.scale= tm_scale_continuous(values = "matplotlib.rainbow"))


tmap_save(tm2, filename = "world_srgb.pdf", width = 8, height = 4, colormodel = "srgb")

tmap_save(tm2, filename = "world_cmyk.pdf", width = 8, height = 4, colormodel = "cmyk")


tmap_save(tm, filename = "press_freedom_scale_0_5.png", width = 2000, height = 800, scale = 0.5)

tmap_save(tm, filename = "press_freedom.html")

tmap_mode("maplibre")
tmap_save(tm, filename = "press_freedom.html", selfcontained = FALSE)

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
	tm_animate(fps = 4) +
	tm_crs("auto")

print(m)


tm_shape(World) +
	tm_polygons(fill = c("HPI", "press"))

tm_shape(World) +
	tm_polygons(fill = "press") +
	tm_facets("continent")

tm_shape(World) +
	tm_polygons(fill = "press") +
	tm_facets_grid(rows = "continent", columns = "economy")

tm_ani = tm_shape(World) +
	tm_polygons(fill = "press") +
	tm_animate("continent")


tm_shape(World) +
	tm_polygons(fill = c("HPI", "press")) +
	tm_animate(fps = 1)

tmap_animation(tm_ani, "continent.mp4", width = 2000, height = 1000, dpi = 150)
tmap_animation(tm_ani, "continent.gif", width = 2000, height = 1000, dpi = 150)

tmap_mode("maplibre")
x = tm_shape(World) +
	tm_polygons_3d(height = "pop_est_dens")

tmap_save(x, filename = "map3d.html")


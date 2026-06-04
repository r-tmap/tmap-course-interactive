tmap_mode("view")

tm_shape(NLD_dist) +
	tm_polygons(
		fill = "dwelling_value",
		col = NULL,
		fill.legend = tm_legend("Dwelling value (×1000)"),
		group = "District data") +          # ← group name
tm_shape(NLD_muni) +
	tm_borders(lwd = 1, group = "Municipality borders") +
tm_shape(NLD_prov) +
	tm_borders(lwd = 3)                   # ← group name inherited from tm_shape()


tmap_mode("view")

tm_shape(NLD_dist) +
	tm_polygons(fill = "dwelling_value", col = NULL,
				fill.legend = tm_legend("Dwelling value (×1000)"),
				group = "District level", group.control = "radio") +

	tm_shape(NLD_muni) +
	tm_polygons(fill = "dwelling_value", col = NULL,
				fill.legend = tm_legend("Dwelling value (×1000)"),
				group = "Municipality level", group.control = "radio") +

	tm_shape(NLD_prov) +
	tm_borders(lwd = 3, group.control = "none") +
	tm_basemap("OpenStreetMap", group.control = "none")

# Explicit z-ordering: higher zindex = drawn on top
tm = tm_shape(NLD_dist) +
	tm_polygons("dwelling_value", zindex = 401, lwd = 0.5) +
	tm_shape(NLD_muni) +
	tm_borders(zindex = 403, lwd = 3)

tm + tm_shape(World) + tm_polygons("pink", zindex = 402)

tm_shape(NLD_dist) +
	tm_polygons("dwelling_value", zindex = 402, lwd = 0.5) +
	tm_shape(NLD_muni) +
	tm_borders(zindex = 401, lwd = 3)

tmap_mode("view")

tm_shape(NLD_dist) +
	tm_polygons(fill = "dwelling_value", col = NULL,
				group = "Dwelling values") +
	tm_shape(NLD_muni) +
	tm_borders(lwd = 1, group = "Municipality borders") +
	tm_basemap(c("CartoDB.Positron",
				 "OpenStreetMap",
				 "Esri.WorldImagery"))

tmap_mode("view")
tm_shape(NLD_dist) +
	tm_polygons(
		fill = "dwelling_value",
		fill.scale = tm_scale_intervals(values = "-brewer.rd_yl_bu",
										breaks = c(75, 150, 250, 500, 750, 1000, 1600)),
		fill.legend = tm_legend("Dwelling value (x 1000)"),
		group = "District") +

tm_shape(NLD_muni) +
	tm_polygons(
		fill = "dwelling_value",
		fill.scale = tm_scale_intervals(values = "-brewer.rd_yl_bu",
										breaks = c(75, 150, 250, 500, 750, 1000, 1600)),
		fill.legend = tm_legend_hide(),
		group = "Municipality") +

tm_borders(group = "District", lwd = 2) +

	tm_title("Zoom in for district level (and out for municipality level)") +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 3, group.control = "none") +
	tm_group("Municipality", zoom_levels = 7:10) +
	tm_group("District",     zoom_levels = 11:14) +
	tm_view(set_zoom_limits = c(7, 14)) +
	tm_mouse_coordinates()

tm_shape(NLD_dist) +
	tm_dots()


tm_shape(NLD_dist) +
	tm_dots(options = opt_tm_dots(clustering = TRUE)) +
	tm_view(use_WebGL = FALSE)


colors()
mypal = c("red", "yellow", "green")

tm_shape(NLD_muni) +
	tm_polygons(
		fill = "dwelling_value",
		fill.scale = tm_scale_intervals(values = "-ocean.balance",
										breaks = c(75, 150, 250, 500, 750, 1000, 1600)))


tm_shape(NLD_muni) +
	tm_polygons(
		fill = "dwelling_value",
		fill.scale = tm_scale_intervals(values = mypal,
										breaks = c(75, 150, 250, 500, 750, 1000, 1600)))


library(cols4all)
c4a_gui()

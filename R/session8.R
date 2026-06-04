library(tmap)
library(tmap.mapgl)

tmap_mode("maplibre")

tm_shape(World) +
	tm_polygons_3d(
		height = "pop_est_dens",  # variable controlling extrusion height
		fill = "well_being",        # variable controlling fill colour
		fill.scale=tm_scale_continuous(values = "pu_gn_div"),
		options = opt_tm_polygons_3d(height.max = "20%")
	)

tm_shape(World) +
	tm_polygons(
		fill = "well_being",        # variable controlling fill colour
		fill.scale=tm_scale_continuous(values = "pu_gn_div")
	)


tm_shape(World) +
	tm_symbols(
		size = "pop_est",
		fill = "well_being",        # variable controlling fill colour
		fill.scale=tm_scale_continuous(values = "pu_gn_div"),
		size.scale = tm_scale(values.scale = 3)
	) +
	tm_basemap(.tmap_providers$ofm.bright)

tmap_mode("maplibre")

tm_shape(World) +
	tm_polygons_3d(height = "pop_est_dens", fill = "continent") +
	tm_maplibre(
		pitch = 45   # tilt: 0 = top-down, 60 = oblique view
	)


tmap_mode("maplibre")

NLD_dist$pop_dens <- NLD_dist$population / NLD_dist$area


tm_shape(NLD_dist) +
	tm_polygons(
		fill = "edu_appl_sci",
		fill.scale = tm_scale_intervals(style = "kmeans", values = "-pu_gn"),
		fill.legend = tm_legend("Applied sci. degree (%)"),
		hover = "name"
	) +
	tm_crs(crs = 3857) +
	tm_maplibre(pitch = 45)

tm_shape(NLD_dist) +
	tm_symbols(
		size = "population",
		size.scale = tm_scale(values.scale = 2),
		fill = "edu_appl_sci",
		fill.scale = tm_scale_intervals(style = "kmeans", values = "-pu_gn"),
		fill.legend = tm_legend("Applied sci. degree (%)"),
		hover = "name"
	) +
	tm_crs(crs = 3857) +
	tm_maplibre(pitch = 45)

tm_shape(NLD_dist) +
	tm_polygons_3d(
		height = "pop_dens",
		fill = "edu_appl_sci",
		fill.scale = tm_scale_intervals(style = "kmeans", values = "-pu_gn"),
		fill.legend = tm_legend("Applied sci. degree (%)"),
		hover = "name"
	) +
	tm_crs(crs = 3857) +
	tm_maplibre(pitch = 45)

library(terra)

pop     <- rast("../tmap-paper/data/global_pop_2025_CN_1km_R2025A_UA_v1.tif")
pop_agg <- aggregate(pop, fact = 64, fun = sum, na.rm = TRUE)
names(pop_agg) <- "pop"

# bug - unhelpful error
tm_shape(pop_agg) +
	tm_raster()

ttm()

tm_shape(pop_agg) +
	tm_raster(col.scale = tm_scale_continuous_log1p()) +
tm_graticules(n.y = 20) +
	tm_crs(3857)

tm_shape(pop_agg) +
	tm_polygons_3d(height = "pop",
				   fill = "pop")


library(tmap)
library(tmap.mapgl)

tmap_mode("maplibre")

tm_shape(pop_agg) +
tm_polygons_3d(
	height     = "pop",
	fill       = "pop",
	fill.scale = tm_scale_intervals(
		values = "-ocean.thermal",
		style  = "kmeans"),       # handles skewed distribution well
	fill.legend = tm_legend_hide()
) +
tm_basemap("ofm.bright") +
tm_shape(metro) +
	tm_circles(size = 80000,
			   hover = "name",
			   fill = NULL,
			   col = NULL)



library(tmap.sources)
tmap_src_overture()

tm_shape(metro, bbox = "New York") +
	tm_bubbles(size = "pop2020")

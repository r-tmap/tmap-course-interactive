library(tmapverse)
tmap_mode_pool(c("plot", "maplibre"))


tm_shape(World) +
	tm_polygons(fill = "HPI")

rtm()
devtools::install_github("crazycapivara/openlayers")

library(openlayers)

ol() %>%
	add_stamen_tiles() %>%
	set_view(9.5, 51.31667, zoom = 10)

## Points
library("geojsonio")

cities <- us_cities[1:5, ]

ol()  %>%
	add_stamen_tiles() %>%
	add_features(cities, style = icon_style(),
				 popup = cities$name)

## Polygons
library("sf")

nc <- st_read(system.file("gpkg/nc.gpkg", package = "sf"),
			  quiet = TRUE)

ol() %>%
	add_stamen_tiles("watercolor") %>%
	add_stamen_tiles(
		"terrain-labels",
		options = layer_options(max_resolution = 13000)
	) %>%
	add_features(
		data = nc,
		style = fill_style("yellow") + stroke_style("blue", 1),
		popup = nc$AREA
	) %>%
	add_overview_map()

tmap_mode("view")
tm_shape(NLD_dist) +
	tm_polygons() +
	tm_view(use_WebGL = FALSE)



tmap_mode("maplibre")
tm_shape(NLD_dist) +
	tm_polygons() +
	tm_maplibre(pitch = 60)

tmap_mode()
rtm()

tmap_mode("maplibre")

tm_shape(World) +
	tm_polygons("well_being") +
	tm_geocoder()

tmap_overview()

tm_shape(NLD_muni, bbox = "Europe") +
	tm_polygons()

aus_bbox = st_bbox(World[World$name == "Australia", ])

aus_bbox2 = tmaptools::bb(aus_bbox, ext = 1.40)

tmap_mode("maplibre")
tm_shape(NLD_muni, bbox = "Amsterdam", ext = 10) +
	tm_polygons()


tmap_providers()

tmap_mode("maplibre")
tm_shape(NLD_muni, bbox = "Amsterdam", ext = 10) +
	tm_polygons() +
	tm_basemap("carto.dark_matter")

tm_shape(NLD_muni, bbox = "Amsterdam", ext = 10) +
	tm_polygons() +
	tm_basemap(.tmap_providers$carto.dark_matter)


tmap_style("classic")


tmap_mode("plot")

tm_shape(World) +
	tm_polygons("well_being")

tmap_mode("view")

tm_shape(World) +
	tm_polygons("well_being")


tmap_mode("maplibre")

tm_shape(World) +
	tm_polygons("well_being")


tmap_mode("maplibre")

tmap_style("white")

# World choropleth — globe CRS by default
tm_shape(World) +
	tm_polygons("HPI")

# Or a bubble map
tm_shape(World) +
	tm_polygons() +
	tm_shape(metro) +
	tm_bubbles(size = "pop2020")


library(tmap)
library(tmap.mapgl)

tmap_mode("maplibre")

tm_shape(World) +
	tm_polygons_3d(
		height = "pop_est_dens",  # variable controlling extrusion height
		fill = "continent"        # variable controlling fill colour
	)



tmap_mode("maplibre")

tm_shape(World) +
	tm_polygons_3d(height = "pop_est_dens", fill = "continent") +
	tm_maplibre(
		pitch = 45   # tilt: 0 = top-down, 60 = oblique view
	)

tmap_mode("maplibre")

NLD_dist$pop_dens <- NLD_dist$population / NLD_dist$area

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

tm_shape(NLD_dist) +
	tm_polygons(
		fill = "edu_appl_sci",
		fill.scale = tm_scale_intervals(style = "kmeans", values = "-pu_gn"),
		fill.legend = tm_legend("Applied sci. degree (%)"),
		hover = "name"
	)

# bivariate alternative
tmap_mode("plot")
tm_shape(NLD_dist) +
	tm_polygons(
		col = NULL,
		fill = tm_vars(c("edu_appl_sci","pop_dens"), multivariate = TRUE),
		fill.scale = tm_scale_bivariate(
			scale1 = tm_scale_intervals(style = "kmeans"),
			scale2 = tm_scale_intervals(n = 3),
			values = "-\\pu_gn_bivd"),
		fill.legend = tm_legend("Applied sci. degree (%)"),
		hover = "name"
	)


library(terra)

pop     <- rast("../tmap-paper/raw/global_pop_2025_CN_1km_R2025A_UA_v1.tif")
pop_agg <- aggregate(pop, fact = 64, fun = sum, na.rm = TRUE)
names(pop_agg) <- "pop"

library(tmap)
library(tmap.mapgl)

tmap_mode("maplibre")

# 3d map
tm_shape(pop_agg) +
	tm_polygons_3d(
		height     = "pop",
		fill       = "pop",
		fill.scale = tm_scale_intervals(
			values = "-ocean.thermal",
			style  = "kmeans"),       # handles skewed distribution well
		fill.legend = tm_legend_hide(),
		options = opt_tm_polygons_3d(height.max = "20%")
	) +
	tm_basemap("ofm.bright")      # light basemap so tall bars stand out

# raster alternative
tm_shape(pop_agg) +
	tm_raster(
		col       = "pop",
		col.scale = tm_scale_intervals(
			values = "-ocean.thermal",
			style  = "kmeans"),       # handles skewed distribution well
		options = opt_tm_polygons_3d(height.max = "20%")
	) +
	tm_basemap("ofm.bright")      # light basemap so tall bars stand out


tmap_mode("view")

tm_shape(NLD_dist) +
	tm_polygons(lwd = "dwelling_value") +
	tm_view(use_WebGL = TRUE)


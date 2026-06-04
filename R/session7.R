tmap_mode("plot")

tm_shape(land) +
	tm_raster("cover")

tmap_mode("maplibre")

tm_shape(land) +
	tm_raster("cover")

library(terra)

as(land, "SpatRaster")


tmap_providers()

tm_basemap("Esri.WorldImagery")

tm_shape(land) +
	tm_raster("elevation", blend = "screen") +
	tm_basemap("Esri.WorldImagery")

tmap_mode("maplibre")

tm_shape(land) +
	tm_raster("elevation", blend = "screen") +
	tm_basemap("carto.voyager")


tmap_providers("view")
tmap_providers("maplibre")

tm_shape(metro) +
	tm_bubbles(fill = "pop2020", fill.scale= tm_scale_continuous(values = "plasma")) +
	tm_basemap("ofm.positron")

tmap_mode("maplibre")
tmap_mode_pool(c("plot", "maplibre"))

ttm()

tmap_mode("maplibre")
tm_shape(World) +
	tm_polygons("well_being") +
	tm_maplibre(
		pitch = 60,    # camera pitch (0 = top-down, 60 = oblique)
		zoom = 2      # initial zoom level
	)

tmap_mode("maplibre")
tmap_providers()    # lists providers for the active mode

tm_shape(NLD_muni) +
	tm_polygons("employment_rate") +
	tm_basemap("ofm.positron")

tm_shape(World) +
	tm_polygons() +
	tm_shape(metro) +
	tm_bubbles(size = "pop2020") +
	tm_crs()

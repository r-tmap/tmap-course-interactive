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

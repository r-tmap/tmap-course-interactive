library(tmapverse)

rtm()

tm_shape(metro) +
	tm_dots()

tmap_mode("view")

tm_shape(World) +
	tm_polygons("HPI") +
	tm_view(
		control.position = c("left", "bottom"),
		set_view = 3          # default zoom level
	) +
	tm_basemap("OpenTopoMap")

tmap_providers()

tm_shape(World) +
	tm_polygons("HPI") +
	tm_basemap(.tmap_providers$Esri.WorldStreetMap)


tm_shape(World) +
	tm_polygons("HPI") +
	tm_basemap(NULL) +
	tm_crs("auto")


tm_shape(World) +
	tm_polygons("HPI")

tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate") +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 3) +
	tm_basemap(c("OpenStreetMap",
				 "CartoDB.Positron",
				 "Esri.WorldImagery"))

tmap_mode("view")
tmap_mode("plot")
tmap_mode("maplibre")
tm_shape(NLD_muni) +
	tm_polygons("employment_rate", group = "Choropleth") +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 3, group = "Choropleth") +
	tm_basemap(c("OpenStreetMap",
				 "CartoDB.Positron",
				 "Esri.WorldImagery"))


tmap_mode("plot")
tm_shape(NLD_muni) +
	tm_polygons()


st_crs(NLD_muni)

# 4326 lat/long, WGS 84
# 3857 # web-mercator

tm_shape(World) +
	tm_polygons() +
	tm_crs(4326) +
	tm_grid()


tm_shape(World) +
	tm_polygons() +
	tm_crs(3857) +
	tm_grid()

tmap_mode("maplibre")

tmap_mode("view")
tm_shape(World) + tm_borders()

tm_shape(NLD_muni) +
	tm_polygons("employment_rate", group = "Choropleth") +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 3, group = "Choropleth") +
	tm_basemap(c("OpenStreetMap",
				 "CartoDB.Positron",
				 "Esri.WorldImagery")) +
tm_group("Choropleth", control = "radio")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate", group = "Choropleth") +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 3, group = "Choropleth") +
	tm_basemap("OpenStreetMap", group = "Basemap") +
	tm_group("Choropleth", control = "radio")

Stadia_AlidadeSmooth

OpenRailwayMap
.tmap_providers$Stadia.AlidadeSmooth
.tmap_providers$OpenRailwayMap

tm_basemap(.tmap_providers$Stadia.AlidadeSmooth) +
tm_shape(NLD_muni) +
	tm_polygons("employment_rate", group = "Choropleth") +
tm_shape(NLD_prov) +
	tm_borders(lwd = 3, group = "Choropleth") +
tm_tiles(.tmap_providers$OpenRailwayMap) +
	tm_credits("CBS")

tmap_provider_credits(.tmap_providers$OpenRailwayMap)

tmap_mode("plot")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate", blend = "multiply") +
	tm_basemap("OpenStreetMap", zoom = 7)

tm_shape(NLD_muni) +
	tm_polygons("employment_rate") +
	tm_basemap("CartoDB.PositronNoLabels", zoom = 7) +
	tm_tiles("Stadia.StamenTonerLabels")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate", blend = "multiply") +
	tm_basemap("Stadia.StamenTonerLite", zoom = 7)

tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate") +
	tm_crs(28992) +       # RD New — virtually no tile providers support this
	tm_basemap(NULL)      # disable basemap explicitly

tmap_mode("maplibre")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate")

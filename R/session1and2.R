library(tmap)
library(tmap.mapgl)

# alternative: use tmapverse
install.packages("tmapverse")
library(tmapverse)

World

# constant values

tm_shape(World) +
	tm_polygons(fill = "gold")

tm_shape(World) +
	tm_polygons(fill = "#ddff00")

World$well_being

# data variables
tm_shape(World) +
	tm_polygons(fill = "well_being")

# modes
tmap_mode("view")

tm_shape(World) +
	tm_polygons(fill = "well_being")

tmap_mode("maplibre")

tm_shape(World) +
	tm_polygons(fill = "well_being")

# layers

tm_shape(World) +
	tm_polygons(fill = "well_being") +
	tm_bubbles(fill = "gold", size = "pop_est")


tm_shape(NLD_muni) +            # Shape (group 1)
	tm_polygons(                  # Layer: data-driven fill
		fill = "income_high",
		fill.scale = tm_scale_continuous(values = "brewer.purples"),
		fill.legend = tm_legend(title = "Income")) +
	tm_shape(NLD_prov) +            # Shape (group 2)
	tm_borders(col = "black", lwd = 2) +
	tm_text(text = "name", bgcol = "white", bgcol_alpha = 0.75) +
	tm_basemap("Esri.WorldTerrain") +    # auxiliary layer
	tm_compass() +                       # map component
	tm_scalebar()

tm_shape(NLD_muni, unit = "mi") +            # Shape (group 1)
	tm_polygons(                  # Layer: data-driven fill
		fill = "income_high",
		fill.scale = tm_scale_continuous(values = "brewer.purples"),
		fill.legend = tm_legend(title = "Income")) +
	tm_shape(NLD_prov) +            # Shape (group 2)
	tm_borders(col = "black", lwd = 2) +
	tm_text(text = "name", bgcol = "white", bgcol_alpha = 0.75) +
	tm_basemap("Esri.WorldTerrain") +    # auxiliary layer
	tm_compass(type = "8star") +                       # map component
	tm_scalebar(breaks = c(0, 10, 50), width = 25)


tm_shape(World) +
	tm_symbols(shape = "economy")

tmap_mode("view")
tm_shape(World) +
	tm_dots(fill = "economy", options = opt_tm_dots(point_per = "largest", clustering = TRUE))


World$is_netherlands = ifelse(World$iso_a3 == "NLD", "orange", "black")

tm_shape(World) +
	tm_polygons("is_netherlands", fill.scale = tm_scale_asis())


ttm()   # toggle to "view" mode

tm_shape(World) +
	tm_polygons(fill = c("HPI", "life_exp"),
				hover = "name",
				popup.vars = c("HPI", "life_exp"))



tm_shape(World) +
	tm_polygons(fill = "HPI",
				fill.scale = tm_scale_intervals(breaks = c(10, 20, 30, 40, 50, 60),
												values = "rd_yl_gn")
				)

tm_shape(World) +
	tm_polygons(fill = "HPI",
				fill.scale = tm_scale_continuous(values = "rd_yl_gn", midpoint = 40)
	)

rtm()

tm_shape(World) +
	tm_polygons(fill = "HPI",
				fill.scale = tm_scale_continuous(values = "rd_yl_gn", midpoint = 40)
	) +
	tm_basemap("OpenStreetMap")


tm_shape(World) +
	tm_borders(lwd = 3, col = "purple") +
	tm_basemap(.tmap_providers$CartoDB.DarkMatterNoLabels)

tmap_mode("plot")
tmap_providers()

tmap_mode("view")
tmap_providers()

tmap_mode("maplibre")
tmap_providers()


# without basemap
tm_shape(World) +
	tm_polygons() +
	tm_basemap(NULL)


# without basemap
tm_shape(World, crs = "+proj=eqearth") +
	tm_polygons() +
	tm_basemap(NULL)


tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate") +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 3) +
	tm_basemap(c("OpenStreetMap",
				 "CartoDB.Positron",
				 "Esri.WorldImagery"))

tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate", group = "Choropleth") +
	tm_shape(NLD_prov) +
	tm_borders(lwd = 3, group = "Choropleth") +
	tm_basemap(c("OpenStreetMap",
				 "CartoDB.Positron",
				 "Esri.WorldImagery")) +
	tm_group("Choropleth", control = "radio")


tm_shape(World) +
	tm_polygons("pink") +
	tm_symbols(fill = "purple", size = "pop_est")

tm_shape(World) +
	tm_symbols(fill = "purple", size = "pop_est") +
tm_polygons("pink")

tm_shape(World) +
	tm_polygons("pink") +
	tm_basemap("OpenStreetMap") +
	tm_tiles("OpenRailwayMap")

tm_shape(World) +
	tm_basemap("OpenStreetMap") +
	tm_tiles("OpenRailwayMap") +
	tm_polygons("pink")

tmap_mode("view")

tm_shape(NLD_muni) +
	tm_polygons("employment_rate") +
	tm_crs(28992) +       # RD New — virtually no tile providers support this
	tm_basemap(NULL)      # disable basemap explicitly

####################

# create grid of 25 points in the Atlantic
atlantic_grid = cbind(expand.grid(x = -51:-47, y = 20:24), id = seq_len(25))
x = sf::st_as_sf(atlantic_grid, coords = c("x", "y"), crs = 4326)

tm_shape(x, bbox = tmaptools::bb(x, ext = 1.2)) +
	tm_symbols(shape = "id",
			   size = 2,
			   lwd = 2,
			   fill = "orange",
			   col = "black",
			   shape.scale = tm_scale_asis()) +
	tm_text("id", ymod = -2)

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

library(tmapverse)
library(tidyverse)

library(sf)
library(terra)

tmap_mode("view")
data("World")

cols4all::c4a_gui()

#var_sel = tail(names(World), 5)[1:4]
#dput(var_sel)

var_sel2 = c("Happy Planet Index" = "HPI", "Economic Inequality" = "inequality", "Gender Inequality" = "gender", "Press Freedom" = "press")


tm_shape(World) +
	tm_symbols(fill = "HPI", size = "pop_est",
			   size.scale = tm_scale_continuous(values.scale = 3, ticks = c(200, 500, 1000) * 1e6),
			   fill.scale = tm_scale_intervals(values = "scico.roma"),
			   fill.legend = tm_legend("Happy Planex Index", position = c("left", "bottom"),bg.alpha = 0.8),
			   size.legend = tm_legend("Population", bg.alpha = 0.8),
			   hover = "name",
			   popup = tm_popup(vars = var_sel2)) +
	tm_basemap("ofm.positron")

tmap_mode("maplibre")


worldpop_url <- paste0(
	"https://data.worldpop.org/GIS/Population/",
	"Global_2015_2030/R2025A/2025/0_Mosaicked/v1/1km_ua/constrained/",
	"global_pop_2025_CN_1km_R2025A_UA_v1.tif"
)

local_file <- "../tmap-paper/data/global_pop_2025_CN_1km_R2025A_UA_v1.tif"
pop_global <- rast(local_file)
pop_global

data("World")

# --- Option A: Germany ---
area <- World |> filter(name == "Germany")

# --- Option B: Africa ---
# area <- World |> filter(continent == "Africa") |> st_union()

area_reproj <- st_transform(area, crs(pop_global))
pop_cropped <- crop(pop_global, area_reproj) |> mask(area_reproj)
names(pop_cropped) <- "pop"

pop_cropped

aggregate_pop <- function(r, fact = 8) {
	r_agg        <- terra::aggregate(r, fact = fact, fun = sum, na.rm = TRUE)
	names(r_agg) <- "pop"
	r_agg
}

# Suggested factors:
#   Germany:  fact = 8  → ~8km cells
#   Africa:   fact = 64 → ~32km cells
pop_agg <- aggregate_pop(pop_cropped, fact = 8)
pop_agg

tm_shape(pop_agg) +
	tm_raster()


tm_shape(pop_agg) +
	tm_raster(col = "pop",
			  col.scale = tm_scale_continuous(values = "brewer.yl_or_rd"),
			  col.legend = tm_legend("Population (2025)")) +
	tm_maplibre(pitch = 45)

tm_shape(pop_agg) +
	tm_polygons_3d(
		fill         = "pop",
		fill.scale   = tm_scale_continuous(values = "brewer.yl_or_rd"),
		height       = "pop",
		height.scale = tm_scale_continuous(),
		options      = opt_tm_polygons_3d(height.max = "20%", height.min = "0.1%")
	) +
	tm_maplibre(pitch = 45) +
	tm_shape(metro) +
	tm_circles(size = 20000,
			   hover = "name",
			   fill = NULL,
			   col = NULL)



tm_shape(World) +
	tm_polygons("pop_est_dens",
				popup = tm_popup(title = "name", vars = "HPI",
								 title.color = "purple",
								)) +
	tm_maplibre(pitch = 60) +
	tm_crs(3857)


area2 <- World |> filter(name == "Germany")
# Option B: Africa
area2 <- World |> filter(continent == "Africa") |> st_union() |> st_sf()



area2_reproj <- st_transform(area2, crs(pop_global))
pop_cropped2 <- crop(pop_global, area2_reproj) |> terra::mask(area2_reproj)
names(pop_cropped2) <- "pop"
pop_agg2 <- aggregate_pop(pop_cropped2, fact = 64)   # 8 for Germany, 64 for Africa

tm_shape(pop_agg2) +
	tm_polygons_3d(
		fill         = "pop",
		fill.scale   = tm_scale_intervals(values = "brewer.yl_or_rd", style = "kmeans", n = 9),
		fill.legend = tm_legend_hide(),
		height       = "pop",
		height.scale = tm_scale_continuous(),
		options      = opt_tm_polygons_3d(height.max = "10%", height.min = "0.1%")
	) +
	tm_maplibre(pitch = 45)

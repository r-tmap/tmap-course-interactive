library(tmap)
library(tmap.mapgl)
library(sf)
library(terra)
library(dplyr)

tmap_mode("view")
data("World")

tm_shape(World) +
	tm_symbols(fill = "HPI", size = "pop_est")

cols4all::c4a_gui()
tm_shape(World) +
	tm_symbols(fill = "HPI",
			   fill.scale = tm_scale_intervals(values = "-bu_br_div"),
			   size = "pop_est",
			   size.scale = tm_scale_continuous(values.scale = 6, ticks = c(200, 800, 1200) * 1e6))

tm_shape(World) +
	tm_symbols(fill = "HPI", size = "pop_est",
			   fill.scale = tm_scale_intervals(values = "pu_gn"),
			   size.scale = tm_scale_continuous(values.scale = 3),
			   hover = "name",
			   options = opt_tm_symbols(point_per = "largest"))

tmap_mode("maplibre")
tm_shape(World) +
	tm_symbols(
		fill       = "HPI",
		size       = "pop_est",
		fill.scale = tm_scale_intervals(values = "pu_gn", value.neutral = "grey70"),
		size.scale = tm_scale_continuous(values.scale = 3),
		id = "name",
		popup.vars = c("Name" = "name", "HappyPI" = "HPI")
	)

tmap_mode("maplibre")

tm_shape(World) +
	tm_symbols(
		fill       = "HPI",
		size       = "pop_est",
		fill.scale = tm_scale_intervals(values = "pu_gn"),
		size.scale = tm_scale_continuous(values = tm_seq(0, 1, power = 1/3),
										 values.scale = 6),
		hover      = "name",
		popup.vars = c("name", "HPI", "life_exp", "well_being",
					   "footprint", "gdp_cap_est", "pop_est")
	)


tmap_providers()

tm_basemap("ofm.dark") +
	tm_shape(World) +
	tm_symbols(
		fill       = "HPI",
		size       = "pop_est",
		fill.scale = tm_scale_intervals(values = "pu_gn"),
		size.scale = tm_scale_continuous(values = tm_seq(0, 1, power = 1/3),
										 values.scale = 6),
		hover      = "name",
		popup.vars = c("name", "HPI", "life_exp", "well_being",
					   "footprint", "gdp_cap_est", "pop_est")
	)


worldpop_url <- paste0(
	"https://data.worldpop.org/GIS/Population/",
	"Global_2015_2030/R2025A/2025/0_Mosaicked/v1/1km_ua/constrained/",
	"global_pop_2025_CN_1km_R2025A_UA_v1.tif"
)

local_file <- "../tmap-paper/raw/global_pop_2025_CN_1km_R2025A_UA_v1.tif"
dir.create("data", showWarnings = FALSE)

if (!file.exists(local_file)) {
	message("Downloading WorldPop 2025 (~280 MB) — this will take a while...")
	options(timeout = 2000)
	download.file(worldpop_url, destfile = local_file, mode = "wb")
}

pop_global <- rast(local_file)
pop_global

tm_shape(World) +
	tm_polygons() +
	tm_crs(3857)

data("World")

# --- Option A: Germany ---
area <- World |> filter(name %in% c("Belgium", "Netherlands", "Germany", "Luxembourg"))
#area <- World |> filter(continent == "Europe", name != "Russia")

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

# Germany: fact = 8  → ~8km cells
# Africa:  fact = 64 → ~64km cells
pop_agg <- aggregate_pop(pop_cropped, fact = 5)
pop_agg

NLD_muni2 = NLD_muni |>
	sf::st_transform(4326) |>
	sf::st_make_valid()

pop_agg$test = rep(LETTERS, lenght.out = 55500)


tm_shape(pop_agg) +
	tm_polygons(
		fill         = "pop",
		fill.scale   = tm_scale_continuous(values = "brewer.yl_or_rd"),
		fill.legend  = tm_legend("Population (2025)"),
		#height       = "pop",
		hover = "test"
		#height.scale = tm_scale_continuous(values.scale = 3),
		#options      = opt_tm_polygons_3d(height.max = "10%", height.min = "0.1%")
	) +
	tm_maplibre(pitch = 45)


area2        <- World |> filter(continent == "Africa") |> st_union()
area2_reproj <- st_transform(area2, crs(pop_global))
pop_cropped2 <- crop(pop_global, area2_reproj) |> mask(area2_reproj)
names(pop_cropped2) <- "pop"
pop_agg2     <- aggregate_pop(pop_cropped2, fact = 64)

tm_shape(pop_agg2) +
	tm_polygons_3d(
		fill         = "pop",
		fill.scale   = tm_scale_continuous(values = "brewer.yl_or_rd"),
		fill.legend  = tm_legend("Population (2025)"),
		height       = "pop",
		height.scale = tm_scale_continuous(values.scale = 3),
		options      = opt_tm_polygons_3d(height.max = "10%", height.min = "0.1%")
	) +
	tm_maplibre(pitch = 45)




NLD_muni_4326 <- st_transform(NLD_muni, 4326) |> st_make_valid()
tm_shape(pop_agg) +
	#  tm_raster(col = "pop",
	#            col.scale = tm_scale_continuous(values = "brewer.yl_or_rd"),
	#            col.legend = tm_legend("Population (2025)")) +
	tm_polygons_3d(
		fill = "pop",
		fill.scale = tm_scale_continuous(values = "brewer.yl_or_rd"),
		fill_alpha = 0.5,
		height = "pop",
		height.scale = tm_scale_continuous(values.scale = 1.5),
		group = "Population density",
		options      = opt_tm_polygons_3d(height.max = "3%", height.min = "0.1%")
	) +
	tm_maplibre(pitch = 45) +
	tm_shape(NLD_muni_4326) +
	tm_polygons(hover = "name", fill = NULL, lwd = 0)

library(sf)

q = function(x) {
	r = rank(x)
	r[is.na(x)] = NA
	r = r / max(r, na.rm = TRUE)
	r
}

World$norm_well_being = q((World$well_being / 8))
World$norm_footprint = q(((50 - World$footprint) / 50))
World$norm_inequality = q(((65 - World$inequality) / 65))
World$norm_press = q(1 - ((100 - World$press) / 100))
World$norm_gender = q(1 - World$gender)


tm_shape(World) +
	tm_polygons(fill = "white", popup.vars = FALSE) +
	tm_shape(World) +
	tm_flowers(parts = tm_vars(c("norm_gender", "norm_press", "norm_footprint", "norm_well_being", "norm_inequality"), multivariate = TRUE),
			   fill.scale = tm_scale(values = "friendly5"),
			   size = 1, popup.vars = c("norm_gender", "norm_press", "norm_footprint", "norm_well_being","norm_inequality"), id = "name") +
	tm_basemap(NULL) +
	tm_layout(bg.color = "grey90")


g = ggplot(mpg) + geom_bar(aes(y = class))

tmap_mode("plot")

ttm()

tm_shape(metro) +
	tm_dots() +
	tm_inset(g, position = tm_pos_out("center", "bottom"), width = 30)

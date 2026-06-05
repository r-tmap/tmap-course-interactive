a = 1
b = a + 10



b

a = 2

c4a_gui()


library(shiny)


n = 10000

x = rnorm(n, mean = 0.5, sd = 0.1)
y = rnorm(n, mean = 0.5, sd = 0.1)

plot(x,y, pch = 16)

ui <- fluidPage(
	titlePanel("Random points"),
	sidebarLayout(
		sidebarPanel(
			sliderInput("n", "Number of points", min = 500, max = 10000, step = 500, value = 1000),
			selectInput("distribution", "Distribution", choices = c("unif", "norm"))
		),
		mainPanel(
			plotOutput("scatterplot")
		)
	)
)

server <- function(input, output) {
	output$scatterplot = renderPlot({
		n = input$n

		if (input$distribution == "norm") {
			x = rnorm(n, mean = 0.5, sd = 0.1)
			y = rnorm(n, mean = 0.5, sd = 0.1)
		} else {
			x = runif(n)
			y = runif(n)
		}

		plot(x,y, pch = 16)
	})
}

shinyApp(ui, server)


library(shiny)
library(tmap)

tmap_mode("view")

pals = c(HPI = "brewer.blues", well_being = "brewer.purples", press = "brewer.greens", economy = "brewer.set3")

tmap_mode("maplibre")

ui <- fluidPage(
	tmapOutput("map", height = 800),
	radioButtons("var", label = "Variable", choices = c("Happy Planet Index" = "HPI", "Well being" = "well_being", "Press freedom" = "press", "Economy" = "economy"))
)

server <- function(input, output) {

	output$map <- renderTmap({
		scale = tm_scale(values = unname(pals[input$var]))
		tm_shape(World) +
			tm_polygons(fill = input$var,
						fill.scale = scale)
	})
}

shinyApp(ui, server)

# Alternative way

tm_shape(World) +
	tm_polygons("HPI", group = "HPI") +
	tm_polygons("economy", group = "Economy") +
	tm_group("HPI", control = "radio") +
	tm_group("Economy", control = "radio") +
	tm_basemap(group = "basemap") +
	tm_group("basemap", control = "none")


tmap_mode("view")

ui <- fluidPage(
	tmapOutput("map"),
	selectInput("var", "Variable",
				choices = c("inequality", "gender", "press"))
)

server <- function(input, output) {
	output$map <- renderTmap({
		tm_shape(World) +
			tm_polygons(fill = input$var)
	})
}

shinyApp(ui, server)




world_vars <- setdiff(names(World), c("iso_a3", "name", "sovereignt", "geometry"))
tmap_mode("view")


shinyApp(
	ui = fluidPage(
		tmapOutput("map", height = "600px"),
		selectInput("var", "Variable", world_vars)),

	server <- function(input, output, session) {
		output$map <- renderTmap({
			tm_shape(World) + tm_polygons(fill = world_vars[1], id = "iso_a3", zindex = 401)
		})

		observe({
			print(input)
			var <- input$var
			tmapProxy("map", session, {
				tm_remove_layer(401) +
					tm_shape(World) +
					tm_polygons(fill = var, id = "iso_a3", zindex = 401)
			})
		})
	}, options = list(launch.browser=TRUE)
)



tmap_mode("view")
ui <- fluidPage(
	tmapOutput("map"),
	verbatimTextOutput("info")
)
server <- function(input, output, session) {
	output$map <- renderTmap({
		tm_shape(World) +
			tm_polygons(fill = "HPI",
						popup.vars = c("name", "HPI", "life_exp"),
						id = "iso_a3")  # id at layer level
	})
	output$info <- renderText({
		print(input$map_shape_click)
		clicked <- input$map_shape_click$id
		if (is.null(clicked)) return("Click a country on the map")
		row <- World[World$iso_a3 == clicked, ]
		paste0(row$name, " — HPI: ", round(row$HPI, 1))
	})
}
shinyApp(ui, server)



tmap_mode("view")

ui <- fluidPage(
	tmapOutput("map"),
	selectInput("country", "Go to country",
				choices = sort(World$name))
)

server <- function(input, output, session) {
	output$map <- renderTmap({
		tm_shape(World) +
			tm_polygons(fill = "HPI", id = "name")  # id at layer level
	})

	observe({
		print(input)
		sel <- World[World$name == input$country, ]
		bb  <- sf::st_bbox(sel)
		leaflet::leafletProxy("map") |>
			leaflet::fitBounds(bb[["xmin"]], bb[["ymin"]],
							   bb[["xmax"]], bb[["ymax"]])
	})
}

shinyApp(ui, server)

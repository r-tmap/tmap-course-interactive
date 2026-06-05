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

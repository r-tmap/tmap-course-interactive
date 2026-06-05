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

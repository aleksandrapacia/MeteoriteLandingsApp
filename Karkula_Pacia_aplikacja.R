library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(DT)
library(bslib)

library(readr)
Meteorite_Landings2 <- read_csv("~/Desktop/Meteorite_Landings2.csv")
View(Meteorite_Landings2)

meteorites <- Meteorite_Landings2
names(meteorites)[names(meteorites) == "mass (g)"] <- "mass_g"
current_year <- as.numeric(format(Sys.Date(), "%Y"))
meteorites$year <- suppressWarnings(as.numeric(substr(meteorites$year, 1, 4)))
meteorites <- meteorites %>%
  filter(
    year >= 1400,
    year <= current_year
  )
meteorites <- meteorites %>%
  filter(!is.na(reclat), !is.na(reclong), !is.na(mass_g))


ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "solar",
    base_font = font_google("Roboto")
  ),
  titlePanel("Meteorite Landings"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("rok_filter", "Zakres lat:",
                  min = min(meteorites$year, na.rm = TRUE),
                  max = max(meteorites$year, na.rm = TRUE),
                  value = c(1900, 2020)),
      checkboxGroupInput("typ_filter", "Typ lądowania:",
                         choices = unique(meteorites$fall),
                         selected = unique(meteorites$fall)),
      radioButtons("scale_mass", "Skala wykresu mas:",
                   choices = c("Liniowa" = "identity",
                               "Logarytmiczna" = "log10"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Statystyki",
                 fluidRow(
                   # Każda kolumna 50% szerokości ekranu, karty w rzędach po 2
                   column(6,
                          div(style="border:1px solid #ddd; border-radius:10px; padding:25px; margin:10px; background:#f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align:center;",
                              h5("Wszystkie meteoryty"),
                              h3(textOutput("stat_total"))
                          )
                   ),
                   column(6,
                          div(style="border:1px solid #ddd; border-radius:10px; padding:25px; margin:10px; background:#f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align:center;",
                              h5("Typ 'Valid'"),
                              h3(textOutput("stat_valid_count"))
                          )
                   )
                 ),
                 fluidRow(
                   column(6,
                          div(style="border:1px solid #ddd; border-radius:10px; padding:25px; margin:10px; background:#f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align:center;",
                              h5("Średnia masa (g)"),
                              h3(textOutput("stat_mean_mass"))
                          )
                   ),
                   column(6,
                          div(style="border:1px solid #ddd; border-radius:10px; padding:25px; margin:10px; background:#f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align:center;",
                              h5("Najcięższy meteoryt"),
                              h3(textOutput("stat_max_mass"))
                          )
                   )
                 ),
                 fluidRow(
                   column(6,
                          div(style="border:1px solid #ddd; border-radius:10px; padding:25px; margin:10px; background:#f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align:center;",
                              h5("Najstarszy rok lądowania"),
                              h3(textOutput("stat_min_year"))
                          )
                   ),
                   column(6,
                          div(style="border:1px solid #ddd; border-radius:10px; padding:25px; margin:10px; background:#f9f9f9; box-shadow: 2px 2px 8px rgba(0,0,0,0.1); text-align:center;",
                              h5("Najmłodszy rok lądowania"),
                              h3(textOutput("stat_max_year"))
                          )
                   )
                 )
        ),
        tabPanel("Mapa",
                 fluidRow(
                   column(12, leafletOutput("meteoryt_map", height = 500))
                 )
        ),
        tabPanel("Rozkład mas",
                 fluidRow(
                   column(12, plotOutput("plot_mass_dist", height = 400))
                 )
        ),
        tabPanel("Liczba lądowań",
                 fluidRow(
                   column(12, plotOutput("plot_year_hist", height = 400))
                 )
        ),
        tabPanel("Tabela",
                 fluidRow(
                   column(12, DTOutput("data_table"))
                 )
        )
      )
    )
  )
)
server <- function(input, output, session) {
  data <- reactive({
    meteorites %>%
      filter(year >= input$rok_filter[1],
             year <= input$rok_filter[2],
             fall %in% input$typ_filter)
  })
  # Statystyki
  output$stat_total <- renderText({ nrow(data()) })
  output$stat_valid_count <- renderText({ data() %>% filter(nametype == "Valid") %>% nrow() })
  output$stat_mean_mass <- renderText({ format(round(mean(data()$mass_g, na.rm = TRUE),1), big.mark = " ") })
  output$stat_max_mass <- renderText({ format(max(data()$mass_g, na.rm = TRUE), big.mark = " ") })
  output$stat_min_year <- renderText({ min(data()$year, na.rm = TRUE) })
  output$stat_max_year <- renderText({ max(data()$year, na.rm = TRUE) })
  # Mapa
  output$meteoryt_map <- renderLeaflet({
    pal <- colorFactor(
      palette = c("Fell" = "#dc3545", "Found" = "#0d6efd"),
      domain = c("Fell", "Found")
    )
    leaflet(data()) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      addCircles(
        lng = ~reclong,
        lat = ~reclat,
        radius = ~log(mass_g + 1) * 200,
        color = ~pal(fall),
        fillColor = ~pal(fall),
        fillOpacity = 0.6,
        stroke = TRUE,
        weight = 1,
        popup = ~paste0(
          "<b>", name, "</b><br>",
          "Typ: ", fall, "<br>",
          "Masa: ", format(mass_g, big.mark = " "), " g<br>",
          "Klasa: ", recclass, "<br>",
          "Rok: ", year
        )
      ) %>%
      addLegend(
        position = "bottomright",
        pal = pal,
        values = ~fall,
        title = "Typ lądowania",
        opacity = 1
      ) %>%
      setView(lng = 0, lat = 20, zoom = 2)
  })
  output$plot_mass_dist <- renderPlot({
    df <- data()
    limit <- quantile(df$mass_g, 0.999, na.rm = TRUE)
    df %>%
      filter(mass_g <= limit) %>%
      ggplot(aes(x = mass_g)) +
      geom_histogram(bins = 50, fill = "#17a2b8", color = "black") +
      scale_x_continuous(trans = input$scale_mass) +
      labs(title = "Rozkład mas meteorytów", x = "Masa (g)", y = "Liczba") +
      theme_minimal()
  })
  output$plot_year_hist <- renderPlot({
    data() %>%
      group_by(year) %>%
      summarise(count = n()) %>%
      ggplot(aes(x = year, y = count)) +
      geom_line(color = "#dc3545", linewidth = 1.2) +
      labs(title = "Liczba lądowań w czasie", x = "Rok", y = "Liczba") +
      theme_minimal()
  })
  output$data_table <- DT::renderDT({
    DT::datatable(data(), options = list(pageLength = 10))
  })
}

shinyApp(ui = ui, server = server)
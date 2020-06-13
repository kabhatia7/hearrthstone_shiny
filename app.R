#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(tidyverse)
library(plotly)
library(glue)
library(shinythemes)
library(shinyWidgets)
library(hearrthstone)
library(gganimate)
library(png)
library(gifski)
library(dplyr)

df_cards <- get_all_cards()

ui <- fluidPage(

    # Application title
    theme = shinytheme("superhero"),
    setBackgroundImage(
        src = "https://i.pinimg.com/originals/13/dd/f3/13ddf355dedf14439696c80b3c2c81af.jpg"
    ),
    navbarPage(
        "Shiny exploration of hearrthstone",


        tabPanel("Class Comparison",
                 h4("Which class is truly the mightiest in Azeroth?"),
                    sidebarLayout(
                        sidebarPanel(
                            selectInput('trait', label = "Trait",
                                           choices = c("Health" = "health",
                                                       "Attack" = "attack",
                                                       "Text Length" = "Text_length",
                                                       "Mana Cost" = "manaCost",
                                                       "Weapon Durability" = "durability")),

                            hr(),
                            selectInput('type', label = "Card Type",
                                        choices = c("Minion",
                                                    "Spell",
                                                    "Weapon")
                                        )),
                                        mainPanel(plotlyOutput("Plotly_class")))),

tabPanel("Rarirty Comparison",
         h4("Have you ever wondered what makes a card Legendary?"),
         sidebarLayout(
             sidebarPanel(
                 selectInput('trait_2', label = "Trait",
                             choices = c("Health" = "health",
                                         "Attack" = "attack",
                                         "Text Length" = "Text_length",
                                         "Mana Cost" = "manaCost")
                 ),
                 br(),
                 selectInput('type_2', label = "Card Type",
                             choices = c("Minion",
                                         "Spell",
                                         "Weapon"),
                 ),
                 br(),
                 selectInput('class', label = "Class",
                             choices = c(
                                 "Hunter",
                                 "Demon Hunter" ,
                                 "Druid" ,
                                 "Mage" ,
                                 "Paladin",
                                 "Priest" ,
                                 "Rogue" ,
                                 "Shaman" ,
                                 "Warlock" ,
                                 "Warrior"),
                 )),
                 mainPanel(plotlyOutput("plotly_rarity")))),
tabPanel("Expansion Comparison",
         h4("Have you ever wondered how Blizzard changes how they release cards from expansion to expansion?"),
         sidebarLayout(
             sidebarPanel(
                 selectInput('classifier', label = "Trait",
                             choices = c("Tribe" = "MinionType",
                                         "Rarity" = "Rarity",
                                         "Card Type" = "CardType"
                             )
                 )),
                 mainPanel(plotlyOutput("expac_plot")
                 )
             )
         )
)
)


# Define server logic required to draw a histogram
server <- function(input, output) {



    output$Plotly_class <- renderPlotly({

        plot_class_stats(df_cards, input$trait, input$type)
})


    output$plotly_rarity <- renderPlotly({
        plot_rarity_stats(df_cards, input$trait_2, input$type_2, input$class)
    })

    output$expac_plot <- renderPlotly({
        changes_over_expac(df_cards,input$classifier)
    })
}

# Run the application
shinyApp(ui = ui, server = server)

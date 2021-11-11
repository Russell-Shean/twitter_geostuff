

library(shiny)
library(tmap)
library(dplyr)


ui <- fluidPage(

   

 
    fluidRow(
        column(4,
           selectInput("color_var",
                       "Color Variable",
                       choices = c("conference", "year", "none"))),
        
        column(4,
           
               selectInput("size_var",
                           "Size Variable",
                           choices = c("no_tweets","likes","replies","retweets","interactions","int_ratio","none"))
        )),

        
        fluidRow(
          tmapOutput("Happy_mappy")
        ),
    
    
    )



server <- function(input, output) {

    output$Happy_mappy <- renderTmap({
     tm_shape(tweet_points_sf) + tm_dots(size = ifelse(input$size_var=="none",1,{{input$size_var}}),
                                         col = ifelse(input$color_var=="none","green",{{input$color_var}}),
                                         alpha= 0.5 )
    })
}


shinyApp(ui = ui, server = server)

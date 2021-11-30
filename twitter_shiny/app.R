

library(shiny)
library(tmap)
library(dplyr)
library(lubridate)
library(sf)

load("./data/tweet_points_sf.rda")
load("./data/world_tweets.rda")

ui <- navbarPage("Brain Science Conference Tweets",
                 tabPanel("Point map",
                          
                          bootstrapPage(
                              #tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                              
                              tmapOutput("Happy_mappy", height=1080), 
                              
                              
                              
                              absolutePanel(top = 80, left = 280, width = 125, 
                                            selectInput("color_var",
                                                        "Color Variable",
                                                        choices = c("conference", "year", "none"))),
                              
                              
                              absolutePanel(top = 80, left = 110 ,width = 125,             
                                            selectInput("size_var",
                                                        "Size Variable",
                                                        choices = c("no_tweets","likes","replies","retweets","interactions","int_ratio","none"))
                              ))
                          
                          
                          
                          
                 ),
                 
                 
                 
                 tabPanel("Tweets by country map",
                          bootstrapPage(
                              #tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                              
                              tmapOutput("countries_mappy", height=1080),
                              
                              absolutePanel(top = 80, left = 110, width = 125, 
                                            selectInput("country_var",
                                                        "Variable",
                                                        choices = c("no_tweets","likes","replies","retweets","interactions","int_ratio"))),
                              
                              
                              
                              absolutePanel(top = 100, left = 300,
                                            checkboxInput("per_capita",
                                                          "Per Capita? (10^5 ppl)")
                              )
                              
                              
                              
                          )),
                 
                 
                 
                 tabPanel("Charts and stuff")
)

server <- function(input, output) {
    
    
    
    
    
    
    
    output$Happy_mappy <- renderTmap({
        tm_shape(tweet_points_sf) + tm_dots(size = ifelse(input$size_var=="none",1,{{input$size_var}}),
                                            col = ifelse(input$color_var=="none","green",{{input$color_var}}),
                                            alpha= 0.5 )})
    
    output$countries_mappy <- renderTmap({
        if(input$per_capita==TRUE){
            
            world_tweets <- world_tweets %>%
                mutate(across(no_tweets:int_ratio, ~ round(. /population*10^5)))
            
        }
        
        tm_shape(world_tweets) + tm_fill({{input$country_var}},
                                         alpha= 0.5 )
    })
}

shinyApp(ui = ui, server = server)

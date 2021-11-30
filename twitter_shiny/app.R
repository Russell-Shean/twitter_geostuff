

library(shiny)
library(tmap)
library(dplyr)

load("./data/tweet_points_sf.rda")
load("./data/world_tweets.rda")

ui <- navbarPage("Brain Science Conference Tweets",
                 tabPanel("Point map",
                          fluidPage(
                              
                              
                              
                              
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
                                  tmapOutput("Happy_mappy", height=1000)
                              ),
                              
                              
                          )),
                 tabPanel("Tweets by country map",
                          fluidPage(
                              
                              
                              
                              
                              fluidRow(
                                  column(4,
                                         selectInput("country_var",
                                                     "Variable",
                                                     choices = c("no_tweets","likes","replies","retweets","interactions","int_ratio"))),
                                  
                                  column(4,
                                         
                                         checkboxInput("per_capita",
                                                       "Per Capita? (10^5 ppl)")
                                  )),
                              
                              
                              fluidRow(
                                  tmapOutput("countries_mappy", height=1000)
                              ),
                              
                              
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

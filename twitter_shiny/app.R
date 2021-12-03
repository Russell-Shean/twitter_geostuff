

library(shiny)
library(tmap)
library(dplyr)

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
                              ),
                              absolutePanel(top = 100, left = 450,
                                            checkboxInput("years_ordered",
                                                          "Should years be colored in order?",
                                                          value = TRUE)))
                          
                          
                          
                          
                 ),
                 
                 
                 
                 tabPanel("Tweets by country map",
                          bootstrapPage(
                              #tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                              
                              tmapOutput("countries_mappy", height=1080),
                              
                              absolutePanel(top = 80, left = 110, width = 125, 
                                            selectInput("country_var",
                                                        "Variable",
                                                        choices = c("no_tweets","likes","replies","retweets","interactions","int_ratio","total_articles"))),
                              
                              
                              
                              #absolutePanel(top = 100, left = 300,
                               #             checkboxInput("per_capita",
                                #                          "Per Capita? (10^5 ppl)")
                            #  ),
                              
                              absolutePanel(top = 100, left = 300, 
                                            radioButtons("normalize_method",
                                                         "How would you like to normalize?",
                                                         choiceValues = c("per_capita","per_publications","no_normalize"),
                                                         choiceNames = c("Per Capita? (10^5 ppl)","Per total nueroscience publications?","Don't normalize"),
                                                         selected = "no_normalize",
                                                         inline = TRUE)
                                            ),
                            absolutePanel(top = 140, left = 500 ,
                                         checkboxInput("exclude_nigeria",
                                                      "Exclude Nigeria?",
                                                       value=FALSE)
                              ),
                              
                              
                              
                          )),
                 
                 
                 
                 tabPanel("Charts and stuff"),
                 tabPanel("About this project",
                          tags$div(
                              tags$h4("Background"), 
                              "This shiny visualization is part of the supplemental material that accompanies the paper ",tags$a(href="https://tmu.pure.elsevier.com/zh/persons/niall-w-duncan","Analysis of Neuroscience Conference Tweets, Duncan et al."),
                              tags$br(),tags$br(),
                              "In the paper we look at the distribution of tweets associated with four neuroscience conferences and analyze factors that are associated with an increase likilhood of a tweeting receiving an interaction. This shiny app shows a variety of different way of visualizing the data; feel free to play around with the map and let us know if you have any suggestions!",
                              
                              tags$br(),tags$br(),tags$h4("Code"),
                              "The code used to make this shiny app is available on ",tags$a(href="https://github.com/Russell-Shean/twitter_geostuff", "Github."),
                              tags$br(),tags$br(),tags$h4("Data Sources"),
                              tags$b("Tweets data: "), "The tweet data was accessed between Jan-March 2020 using the Twitter API. Unfortunately, Twitter has since changed their API, so our original data is no longer attainable using the original method",tags$br(),
                              tags$b("World population: "), "Country level world population data from 2019 was taken from the World Bank website, using their ", 
                              tags$a(href="https://datahelpdesk.worldbank.org/knowledgebase/articles/898581-api-basic-call-structures", "API."), "Taiwan's population in December 2019 was manually added to the shape file using data taken from ",tags$a(href="https://ws.moi.gov.tw/001/Upload/OldFile/site_stuff/321/1/month/month_en.html", "Taiwan's Ministry of Interior website"),tags$br(),
                              tags$b("Shape files: "), "We downloaded them from this ", tags$a(href="https://www.efrainmaps.es/english-version/free-downloads/world/", "website."),tags$br(),
                              
                              tags$br(),
                              tags$h4("Shiny inspirations: "), "There are some very cool shiny examples at the Rstudio ",tags$a(href="https://shiny.rstudio.com/gallery/","shiny gallery."),"Their code inspired a lot of my code. Thank you to everyone who shared their code! :)",
                              
                              
                              tags$br(),tags$br(),tags$h4("Authors"),
                              "Dr. Niall Duncan, Graduate Institute of Mind, Brain and Consciousness, Taipei Medical University",tags$br(),
                              "Russell Shean, Global Health Program, Taipei Medical University",tags$br(),
                              tags$br(),tags$br(),tags$h4("Contact"),
                              "nwduncan@tmu.edu.tw",tags$br(),tags$br(),tags$br(),tags$br(),
                              tags$img(src= "https://www.tmu.edu.tw/images/title.png",height = "75px", style="padding-right: 15px"), tags$img(src="https://github.com/Russell-Shean/twitter_geostuff/blob/main/shape_files/GIMBC_logo.png?raw=true", height = "75px", style="padding-right: 10px"), tags$img(src = "https://ichef.bbci.co.uk/news/976/cpsprodpb/12A9B/production/_111434467_gettyimages-1143489763.jpg", width = "150px", height = "75px")
                          )
                 )
)

server <- function(input, output) {
    
    
    
    
    
    
    
    output$Happy_mappy <- renderTmap({
        if(input$years_ordered == TRUE) {
            
            tweet_points_sf$year <- factor(tweet_points_sf$year, ordered = TRUE)
        }
        
        
        tm_shape(tweet_points_sf) + tm_dots(size = ifelse(input$size_var=="none",1,{{input$size_var}}),
                                            col = ifelse(input$color_var=="none","green",{{input$color_var}}),
                                            alpha= 0.5,
                                            popup.vars= c("country","conference","year","no_tweets",
                                                          "retweets","replies","likes","interactions","int_ratio"))})
    
    output$countries_mappy <- renderTmap({
        #if(input$per_capita==TRUE){
         #   
          #  world_tweets <- world_tweets %>%
           #     mutate(across(no_tweets:int_ratio, ~ round(. /population*10^5)))
            
    #    }
        
        if(input$exclude_nigeria==TRUE){
            world_tweets <- world_tweets %>%
                filter(country!="Nigeria")
        }
        
        if(input$normalize_method=="per_capita"){
               
              world_tweets <- world_tweets %>%
                 mutate(across(no_tweets:int_ratio, ~ round(. /population*10^5)))
            
        }
        
        if(input$normalize_method=="per_publications"){
            
            world_tweets <- world_tweets %>%
                mutate(across(no_tweets:int_ratio, ~ round(. /total_articles)))  
            
        }
        
        tm_shape(world_tweets) + tm_fill({{input$country_var}},
                                         alpha= 0.5,
                                         popup.vars = c("no_tweets",    "likes",        "replies",      "retweets",    
                                                         "interactions", "int_ratio", "population","total_articles"))
    })
}

shinyApp(ui = ui, server = server)

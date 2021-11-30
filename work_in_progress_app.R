

library(shiny)
library(tmap)
library(dplyr)

#load("./data/tweet_points_sf.rda")
#load("./data/world_tweets.rda")

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
                            
                            
                          
                 tabPanel("Charts and stuff"),
                 tabPanel("About this project",
                          tags$div(
                            tags$h4("Background"), 
                            "This shiny visualization is a supplemental material that accompanies the paper ",tags$a(href="https://tmu.pure.elsevier.com/zh/persons/niall-w-duncan","Analysis of Neuroscience Conference Tweets, Duncan et al."),
                            tags$br(),tags$br(),
                            "In our paper we look at the distribution of tweets associated with four neuroscience conferences and analyze factors that are associated with an increase likilhood of a tweeting receiving an interaction. This shiny app shows a variety of different way of visualizing the data; feel free to play around with the map and let us know if you have any suggestions!",
                          
                            tags$br(),tags$br(),tags$h4("Code"),
                            "The Code we used to make this shiny app is available at the following ",tags$a(href="https://github.com/Russell-Shean/twitter_geostuff", "Github repository."),
                            tags$br(),tags$br(),tags$h4("Data Sources"),
                            tags$b("Tweets data: "), "The tweet data was accessed between Jan first 2020 and March first 2020 using the Twitter API. Unfortunately, twitter has since changed their API, so our original data is no longer attainable using the original data importation method",tags$br(),
                            tags$b("World population: "), "Country level world population data from 2019 was taken from the World Bank website, using their ", tags$a(href="https://datahelpdesk.worldbank.org/knowledgebase/articles/898581-api-basic-call-structures", "API."), "Taiwan's population in December 2019 was manually added to the shape file using data taken from ",tags$a(href="https://ws.moi.gov.tw/001/Upload/OldFile/site_stuff/321/1/month/month_en.html", "Taiwan's Ministry of Interior website"),
                            tags$b("2003-SARS cases: "), tags$a(href="https://www.who.int/csr/sars/country/en/", "WHO situation reports"),tags$br(),
                            tags$b("2009-H1N1 confirmed deaths: "), tags$a(href="https://www.who.int/csr/disease/swineflu/updates/en/", "WHO situation reports"),tags$br(),
                            tags$b("2009-H1N1 projected deaths: "), "Model estimates from ", tags$a(href="https://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1001558", "GLaMOR Project"),tags$br(),
                            tags$b("2009-H1N1 cases: "), tags$a(href="https://www.cdc.gov/flu/pandemic-resources/2009-h1n1-pandemic.html", "CDC"),tags$br(),
                            tags$b("2009-H1N1 case fatality rate: "), "a systematic review by ", tags$a(href="https://www.ncbi.nlm.nih.gov/pubmed/24045719", "Wong et al (2009)"), "identified 
                        substantial variation in case fatality rate estimates for the H1N1 pandemic. However, most were in the range of 10 to 100 per 100,000 symptomatic cases (0.01 to 0.1%).
                        The upper limit of this range is used for illustrative purposes in the Outbreak comarisons tab.",tags$br(),
                            tags$b("2014-Ebola cases: "), tags$a(href="https://www.cdc.gov/flu/pandemic-resources/2009-h1n1-pandemic.html", "CDC"),tags$br(),
                            tags$b("Country mapping coordinates: "), tags$a(href="https://github.com/martynafford/natural-earth-geojson", "Martyn Afford's Github repository"),
                            tags$br(),tags$br(),tags$h4("Authors"),
                            "Dr Edward Parker, The Vaccine Centre, London School of Hygiene & Tropical Medicine",tags$br(),
                            "Quentin Leclerc, Department of Infectious Disease Epidemiology, London School of Hygiene & Tropical Medicine",tags$br(),
                            tags$br(),tags$br(),tags$h4("Contact"),
                            "edward.parker@lshtm.ac.uk",tags$br(),tags$br(),
                            tags$img(src = "https://ichef.bbci.co.uk/news/976/cpsprodpb/12A9B/production/_111434467_gettyimages-1143489763.jpg", width = "150px", height = "75px"), tags$img(src = "https://ichef.bbci.co.uk/news/976/cpsprodpb/12A9B/production/_111434467_gettyimages-1143489763.jpg", width = "150px", height = "75px")
                          )
                 )
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

library(leaflet)




#make the colors for conferences
factpal <- colorFactor(topo.colors(5), tweet_points_sf$conference) 
color = ~factpal(category)


leaflet(tweet_points_sf) %>% addCircleMarkers(color = ~factpal(conference), radius =  ~no_tweets/10)%>% addTiles()

library(tmap)
tmap_mode("view")

tm_shape(tweet_points_sf)+tm_dots(size= "likes", col="conference", popup.vars= c("country","conference","year","no_tweets",
                                                                                 "retweets","replies","likes","interactions","int_ratio"))

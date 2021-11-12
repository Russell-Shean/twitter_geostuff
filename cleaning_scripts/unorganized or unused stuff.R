#unorganized or unused stuff

# step 1: initial data exploration


range(tweets$int_ratio)

library(dplyr)
library(ggplot2)


# various plots exploring the range of number of tweets, interactions, and the ratio between them
tweets %>% 
  filter(country!="USA")%>%
  ggplot()+
  geom_point(aes(x=no_tweets, y= interactions, color= region))


ggplot(tweets)+geom_point(aes(x=no_tweets, y= interactions, color= conference))

# here's where the shape files came from

# https://www.naturalearthdata.com/features/

# https://www.statsilk.com/maps/download-free-shapefile-maps


#step 2: load shape files and plot lat-longs

world_shp <- st_read("./shape_files/ne_110m_admin_0_countries.shp")


# https://tapiquen-sig.jimdofree.com/english-version/free-downloads/world/

world_shp2 <- st_read("./shape_files/World_Countries.shp")

world_tweets <- world_shp2  full_join()

tm_shape(world_shp2)+
  tm_borders()+
  tm_shape(tweet_points_sf)+
  tm_dots(col = "red")+
  tm_layout(frame = FALSE)

library(tmap)

library(GISTools)
library(rgeos)
library(spatstat)
library(spatial)


tm_shape(world_shp)+tm_borders()


no_rus <- world_shp[-19,]

tm_shape(no_rus)+tm_borders()

no_sudan <- no_rus[-15,]

tm_shape(no_sudan)+tm_borders()

st_crs(no_sudan)


full_screen_map <- tm_shape(tweet_points)+tm_dots()

tmap_save(full_screen_map, filename = "./HTML_files/full_screen_map.html")

by_conference_map <- tm_shape(tweet_points)+tm_dots(col = "conference")


tmap_save(by_conference_map, filename = "./HTML_files/by_conference_map.html")


save(tweet_points_sf, file = "./twitter_shiny/data/tweet_points_sf.rda")

#next steps:

#1. a shiny points map

#2. incidence map

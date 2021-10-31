tweets <- read.csv("./data/tweet_information_location.csv")

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

library(sf)
library(GISTools)
library(rgeos)
library(spatstat)
library(spatial)

world_shp <- st_read("./shape_files/ne_110m_admin_0_countries.shp")


library(tmap)


tm_shape(world_shp)+tm_borders()


no_rus <- world_shp[-19,]

tm_shape(no_rus)+tm_borders()

no_sudan <- no_rus[-15,]

tm_shape(no_sudan)+tm_borders()

st_crs(no_sudan)


#step 3: convert lat long to a spatial object

library(dplyr)

twitter.coords <- tweets %>%
  dplyr::select(longitude, latitude)

tweet.points <- SpatialPointsDataFrame(coords=twitter.coords , 
                                   data=tweets,
                                   proj4string = CRS("+init=epsg:4326"))


full_screen_map <- tm_shape(tweet.points)+tm_dots()

tmap_save(full_screen_map, filename = "full_screen_map.html")

by_conference_map <- tm_shape(tweet.points)+tm_dots(col = "conference")


tmap_save(by_conference_map, filename = "full_screen_map.html")

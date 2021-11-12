tweets <- read.csv("./data/tweet_information_location.csv") 


library(sf)
library(sp)
library(dplyr)

twitter_coords <- tweets %>%
  dplyr::select(longitude, latitude)

tweet_points <- SpatialPointsDataFrame(coords=twitter_coords , 
                                   data=tweets,
                                   proj4string = CRS("+init=epsg:4326"))

tweet_points_sf <- st_as_sf(tweet_points)

rm(tweet_points,twitter_coords)


save(tweet_points_sf, file = "./twitter_shiny/data/tweet_points_sf.rda")

#world_union <- st_union(world_tweets)

library(geojsonsf)

wurld <- geojson_sf("https://opendata.arcgis.com/datasets/a21fdb46d23e4ef896f31475217cbb08_1.geojson")

wurld_union <- st_union(wurld)

st_is_longlat(wurld)
st_is_longlat(wurld_union)

tm_shape(wurld_union)+tm_borders(
)


wurld_3395  <- st_transform(wurld, 3395)

wurld_3395 %>% st_is_longlat()


wurld_3395 %>% st_union() %>% tm_shape() + tm_borders()



#kde
tm_shape(wurld)+tm_borders()+tm_shape(tweet_points_sf)+tm_dots(col = "green")

choose_bw<- function(spdf){
  X <- coordinates(spdf)
  stigma <- c(sd(X[,1]),sd(X[,2])) *(2/(3*nrow(X)))^(1/6)
  return(stigma)
}


library(tmaptools)
tmap_mode("view")
tweet_dens <- smooth_map(tweet_points_sp, cover=wurld_sp)


#this sources a file the builds a depreciated function from tmap

#discussion: https://github.com/r-tmap/tmap/issues/488


#this loads smooth_map()
#source:
source("https://raw.githubusercontent.com/mtennekes/oldtmaptools/master/R/smooth_map.R")

#this loads smooth_raster_cover()
source("https://raw.githubusercontent.com/mtennekes/oldtmaptools/master/R/smooth_raster_cover.R")

# the shape files need to be sp instead of sf
tweet_points_sp <- as(tweet_points_sf,"Spatial")

wurld_sp <- as(wurld, "Spatial")


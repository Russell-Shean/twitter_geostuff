# https://tapiquen-sig.jimdofree.com/english-version/free-downloads/world/

require(sf)

world_shp2 <- st_read("./shape_files/World_Countries.shp")



point_counts <- st_intersects(world_shp2, tweet_points_sf)


tweet_points_sf$country_new <- "boogers!"

for(i in 1:nrow(world_shp2)){
  tweet_points_sf$country_new[point_counts[[i]]] <- world_shp2$COUNTRY[i]
}





point_counts_us <- st_intersects(world_shp2[230,], tweet_points_sf)


buffered_us <- st_buffer(world_shp2[230,],dist = 0.5)

buffered_points <- st_buffer(tweet_points_sf, dist = 10)


library(tmap)
tmap_mode("view")

tm_shape(buffered_us)+tm_borders(col= "red")+tm_shape(world_shp2[230,])+tm_borders(col = "green")+tm_shape(tweet_points_sf)+tm_dots(col = "blue")

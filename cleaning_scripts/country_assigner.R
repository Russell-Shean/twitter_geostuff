# https://tapiquen-sig.jimdofree.com/english-version/free-downloads/world/

world_shp2 <- st_read("./shape_files/World_Countries.shp")



point_counts <- st_intersects(world_shp2, tweet_points_sf)


tweet_points_sf$country_new <- "boogers!"

for(i in 1:nrow(world_shp2)){
  tweet_points_sf$country_new[point_counts[[i]]] <- world_shp2$COUNTRY[i]
}





point_counts_us <- st_intersects(world_shp2[230,], tweet_points_sf)


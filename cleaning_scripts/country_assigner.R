# https://tapiquen-sig.jimdofree.com/english-version/free-downloads/world/

require(sf)

world_shp2 <- st_read("./shape_files/World_Countries.shp")



point_counts <- st_intersects(world_shp2, tweet_points_sf)


tweet_points_sf$country_new <- "boogers!"

for(i in 1:nrow(world_shp2)){
  tweet_points_sf$country_new[point_counts[[i]]] <- world_shp2$COUNTRY[i]
}


# import world population data

library(jsonlite)
library(rjson)

world_pop <- jsonlite::fromJSON("http://api.worldbank.org/countries/all/indicator/SP.POP.TOTL?per_page=2000&date=2019&format=json", flatten=TRUE)[[2]]




# add population datas to points

tweet_points_sf$county_population <- 0 

tweet_points2 <- world_pop %>%
                 select(country.id, country.value, value) %>%
                 right_join(tweet_points_sf, by= c("country.value"="country"))



# fix the US and UK
# but first figure out if any other countries didn't work either

tweet_points2 %>% 
  filter(is.na(value))%>%
  select(country.value) %>%
  unique()


country.value
1               UK  "United Kingdom"
2              USA  "United States"
32          Europe
34          Russia   "Russian Federation"
124    South Korea   "Korea, Rep." 
157    Scandinavia   "Slovak Republic"
401        Czechia
518          Egypt   "Egypt, Arab Rep."
744       Slovakia
764      Hong Kong   "Hong Kong SAR, China"
1117          Iran   "Iran, Islamic Rep."
2152        Taiwan
2190         Macao
2498     Venezuela
2868        Jersey


unique(world_pop$country.value)


point_counts_us <- st_intersects(world_shp2[230,], tweet_points_sf)


buffered_us <- st_buffer(world_shp2[230,],dist = 0.5)

buffered_points <- st_buffer(tweet_points_sf, dist = 100)


library(tmap)
tmap_mode("view")

tm_shape(buffered_us)+tm_borders(col= "red")+tm_shape(world_shp2[230,])+tm_borders(col = "green")+tm_shape(tweet_points_sf)+tm_dots(col = "blue")



tm_shape(world_shp2)+ tm_borders() 

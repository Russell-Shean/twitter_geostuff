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


# shape file source
# https://tapiquen-sig.jimdofree.com/english-version/free-downloads/world/

require(sf)
require(dplyr)

world_shp <- st_read("./shape_files/World_Countries.shp")




# import world population data
library(jsonlite)
library(rjson)


# changing the url allows us to change stuff like the date range, the variables we want to import etc. 
world_pop <- jsonlite::fromJSON("http://api.worldbank.org/countries/all/indicator/SP.POP.TOTL?per_page=2000&date=2019&format=json", flatten=TRUE)[[2]]


# rename the variables we need
world_pop <- world_pop %>%
  rename(country=country.value,
         population=value)




#Change world bank country names to match our own dataset
world_pop <- world_pop %>%
  mutate(country=replace(country,country=="United Kingdom","UK"),
         country=replace(country,country== "United States",  "USA"  ), 
         country=replace(country,country== "Russian Federation",    "Russia"     ),
         country=replace(country,country=="Korea, Rep.",    "South Korea"    ),
         country=replace(country,country== "Czech Republic",   "Czechia"    ),
         country=replace(country,country=="Egypt, Arab Rep.",    "Egypt"    ),
         country=replace(country,country== "Slovak Republic",   "Slovakia"  ),
         country=replace(country,country=="Hong Kong SAR, China",    "Hong Kong"     ),
         country=replace(country,country==   "Iran, Islamic Rep."  ,  "Iran"  ),
         country=replace(country,country==   "Macao SAR, China"  ,  "Macao"  ),
         country=replace(country,country==    "Venezuela, RB" ,  "Venezuela"  ))



# And then the countries that don't match on the shape file

#first standardize the names
world_shp <- world_shp %>%
  mutate(COUNTRY=replace(COUNTRY,COUNTRY=="United Kingdom","UK"),
         COUNTRY=replace(COUNTRY,COUNTRY== "United States",  "USA"  ), 
         COUNTRY=replace(COUNTRY,COUNTRY== "Czech Republic",   "Czechia"))


#then attach population to shape files
world_shp <- world_pop %>%
  select(country.id, country, population) %>%
  right_join(world_shp, by= c("country"="COUNTRY"))


# manually add Taiwan's population
world_shp[world_shp$country=="Taiwan",]$population <- 23773876

# Taiwan does not appear in the World bank's dataset, bc the world bank has capitulated to the CCP
# probably the reason, my guess, I dunno for sure
# I don't know if this means I have to subtract 23 million from the world bank's population of China
# We can deal with this question luego


#change the population of countries with NA population and zero tweets to  1
# that way they won't show up as NA on on the map, and their population of 1 will still lead to zero incidence of tweets
# bc there were zero tweets lol
world_shp <- world_shp %>% 
  mutate(across(population, ~replace(.,is.na(.),1)))

# calculate aggregated sums by country for tweets, likes, etc

country_tweet_summaries <- tweet_points_sf %>%
  st_drop_geometry() %>%
  group_by(country) %>%
  summarise(across(c(no_tweets:retweets,interactions), sum)) %>%
  mutate(int_ratio= interactions/no_tweets) 


# attach the totals to our shape file
world_tweets <- world_shp %>%
  left_join(country_tweet_summaries, by = ("country"="country")) %>%
  st_sf(sf_column_name = "geometry")



# and now let's replace NA's with zeros
# For everything!!!!!
world_tweets <-  world_tweets %>% 
  mutate(across(everything() & !country.id, ~replace(.,is.na(.),0)))

world_tweets %>% st_drop_geometry() %>% View()

world_shp %>% 
  filter(is.na(population))%>%
  select(country) %>%
  unique()



##############################################################################################
####    Stuff we're still working on     ########################################
###############################################################################


# add population data to points
tweet_points2 <- world_pop %>%
  select(country.id, country, population) %>%
  right_join(tweet_points_sf, by= c("country"="country"))




# manually add Taiwan's population
tweet_points2[tweet_points2$country=="Taiwan",]$population <- 23773876




point_counts <- st_intersects(world_shp2, tweet_points_sf)


tweet_points_sf$country_new <- "boogers!"

for(i in 1:nrow(world_shp2)){
  tweet_points_sf$country_new[point_counts[[i]]] <- world_shp2$COUNTRY[i]
}


# figure out if any other countries didn't work either
tweet_points2 %>% 
  filter(is.na(population))%>%
  select(country) %>%
  unique()



#country shapes don't link to population'



unique(world_pop$country.value)


point_counts_us <- st_intersects(world_shp2[230,], tweet_points_sf)


buffered_us <- st_buffer(world_shp2[230,],dist = 0.5)

buffered_points <- st_buffer(tweet_points_sf, dist = 100)


library(tmap)
tmap_mode("view")

tm_shape(buffered_us)+tm_borders(col= "red")+tm_shape(world_shp2[230,])+tm_borders(col = "green")+tm_shape(tweet_points_sf)+tm_dots(col = "blue")



tm_shape(world_shp2)+ tm_borders() 



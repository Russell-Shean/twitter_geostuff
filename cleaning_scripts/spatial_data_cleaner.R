################################################################################
################################################################################
#                                                                              #
#                     Step 1: Points                                           #
#                                                                              #
################################################################################
################################################################################


#load the twitter data
tweets <- read.csv("./data/tweet_information_location.csv") 

#load some libraries that we'll need
require(sf)
require(sp)
require(dplyr)

# pull out the coordinates for later use in making the sf dataframe
twitter_coords <- tweets %>%
  dplyr::select(longitude, latitude)

#this fixes the format for some of the dates
tweets$year <- paste(tweets$year,"01", "01", sep = "-") %>% as.Date() %>% year()

# first we'll make a sp spatial data frame using the coordinates we just pulled out and the CRS of epsg code 4326
tweet_points <- SpatialPointsDataFrame(coords=twitter_coords , 
                                   data=tweets,
                                   proj4string = CRS("+init=epsg:4326"))

#then we convert the sp dataframe to a simple features dataframe
tweet_points_sf <- st_as_sf(tweet_points)



#now we remove some intermediate data structures we don't need
rm(tweet_points,twitter_coords)

#this saves the points to the shiny repository for later use
save(tweet_points_sf, file = "./twitter_shiny/data/tweet_points_sf.rda")


################################################################################
################################################################################
#                                                                              #
#                     Step 2: Countries                                        #
#                                                                              #
################################################################################
################################################################################


# load the countries
world_shp <- st_read("./shape_files/World_Countries.shp")

# shape file source
# https://tapiquen-sig.jimdofree.com/english-version/free-downloads/world/


# import world population data

#we'll need these libraries to pull JSON files from the web
library(jsonlite)
library(rjson)

#this pulls world population data from 2019 from the World Bank api

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



# And then standardize the names of countries that don't match between the shape file and world bank data
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
# We can deal with that question later


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

rm(country_tweet_summaries, world_pop, world_shp)

#this saves the country shape file to the shiny repository for later use
save(world_tweets, file = "./twitter_shiny/data/world_tweets.rda")


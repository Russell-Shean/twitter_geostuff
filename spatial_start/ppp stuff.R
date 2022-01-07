#ppp stuff

# first convert our points to a projected crs
# we'll start with mercator for simplicity and to show that the code flow works
# if that's not the best projection we can change to a differnt one late
#my suspicion is that there's no good projection for the whole world


#3857 is epsg code for mercator

tweet_points_3857 <- st_transform(tweet_points_sf, 3857)

tweet_points_3857 <- tweet_points_3857 %>% relocate(interactions)

# now we convert to a ppp 
tweet_points_ppp <- as.ppp(tweet_points_3857)

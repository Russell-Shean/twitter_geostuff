world_union <- st_union(world_tweets)

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

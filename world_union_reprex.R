# World union reprex


# libraries

#these are the core spatial libraries I am using
library(geojsonsf)
library(sf)

#I've loaded dplyr to allow for piping
library(dplyr)

#this map is the mapping package I am using
library(tmap)


#this reads in the shape file I am using from the web
# I didn't use built in data, because I sort of want to know
# if this problem is a problem with the method I am using 
# or if it's a problem with the shape file

wurld <- geojson_sf("https://opendata.arcgis.com/datasets/a21fdb46d23e4ef896f31475217cbb08_1.geojson")

# Here's a link to shape file source and a description:
#  https://hub.arcgis.com/datasets/a21fdb46d23e4ef896f31475217cbb08_1/explore?location=3.619607%2C-42.159146%2C1.70

#I checked to see if all the geometries are valid
st_is_valid(wurld) %>% all()
# and they are

# and now I use st_union to combine  one shape
wurld_union <- st_union(wurld)






# Here is version information for R and the packages I am using

# R
R.Version()

#platform
#[1] "x86_64-w64-mingw32"

#$arch
#[1] "x86_64"

#$os
#[1] "mingw32"

#$system
#[1] "x86_64, mingw32"

#$status
#[1] ""

#$major
#[1] "4"

#$minor
#[1] "1.2"

#$year
#[1] "2021"

#$month
#[1] "11"

#$day
#[1] "01"

#$`svn rev`
#[1] "81115"

#$language
#[1] "R"

#$version.string
#[1] "R version 4.1.2 (2021-11-01)"

#$nickname
#[1] "Bird Hippie"

# packages
packageVersion("sf")
#[1] ‘1.0.4’

packageVersion("dplyr")
#[1] ‘1.0.7’

packageVersion("geojsonsf")
#[1] ‘2.0.1’

#packageVersion("tmap")
#[1] ‘3.3.2’
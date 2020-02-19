## #############################################################################
## warm-up exercise and security reminder

## clean your R session from past objects ...
rm(list = ls())

## running an R script from a trusted source
source('http://bit.ly/CEU-R-heights-2018')
ls()
heights

## but wow:
ls(all = TRUE)
.secret # "A warm hello from the Internet."

readLines('http://bit.ly/CEU-R-heights-2018')

## Take aways:
## * don't use `rm(list = ls())` in your scripts ... rather set RStudio to never save/load your session again
## * don't `source` R scripts downloaded from the Internet without first checking the content

## #############################################################################
## intro / recap on R and ggplot2 from previous courses by introducing MDS

## distance between 40 Hungarian cities -> 2D scatterplot
## http://bit.ly/hun-cities-distance

## download data
t <- tempfile()
t
t <- tempfile(fileext = '.xls')
t
download.file('http://bit.ly/hun-cities-distance', t)
## on windows, you might need to specify the mode as well
download.file('http://bit.ly/hun-cities-distance', t, mode = 'wb')

## further checks on the downloaded file
file.info(t)
pander::openFileInOS(t)

## read the downloaded file
library(readxl)
cities <- read_excel(t)

cities
## tibble VS data.frame VS data.table
str(cities)

## get rid of 1st column and last row (metadata)
cities <- cities[, -1]
cities <- cities[-nrow(cities), ]
str(cities)

mds <- cmdscale(as.dist(cities))
mds

plot(mds)
text(mds[, 1], mds[, 2], names(cities))

## flipping both x and y axis
mds <- -mds
plot(mds)
text(mds[, 1], mds[, 2], names(cities))

## ggplot2 way
mds <- as.data.frame(mds)
mds$city <- rownames(mds)
str(mds)

library(ggplot2)
ggplot(mds, aes(V1, V2, label = city)) +
    geom_text() + theme_bw()

## #############################################################################
## TODO visualize the distance between the European cities
## stored in the built-in dataframe:

?eurodist

mds <- cmdscale(eurodist)
mds <- as.data.frame(mds)
mds$city <- rownames(mds)
ggplot(mds, aes(V1, -V2, label = city)) +
    geom_text() + theme_bw()

## #############################################################################
## TODO non-geo example

?mtcars
str(mtcars)
mtcars

mds <- cmdscale(dist(mtcars))
plot(mds)
text(mds[, 1], mds[, 2], rownames(mtcars))
## oh no, the overlaps!

mds <- as.data.frame(mds)
mds$car <- rownames(mds)
ggplot(mds, aes(V1, V2, label = car)) +
    geom_text() + theme_bw()

library(ggrepel)
ggplot(mds, aes(V1, V2, label = car)) +
    geom_text_repel() + theme_bw()

## #############################################################################
## NOTE think about why the above visualization is off

## check actual distances eg for Camaro (or other sport cars)
which(rownames(mtcars) == 'Camaro Z28')
sort(as.matrix(dist(mtcars))[, 24])

mtcars

subset(mtcars, hp >= 245)

?cmdscale
?dist

summary(mtcars)

## need to standardize to give every variable equal weight!
mtcars$hp - mean(mtcars$hp)
mean(mtcars$hp - mean(mtcars$hp))

(x <- (mtcars$hp - mean(mtcars$hp)) / sd(mtcars$hp))
mean(x)
sd(x)
hist(x)

x
scale(mtcars$hp)
plot(x, scale(mtcars$hp))
x - scale(mtcars$hp)

plot(mtcars$hp, scale(mtcars$hp))

?scale
scale(mtcars)

mds <- cmdscale(dist(scale(mtcars)))
mds <- as.data.frame(mds)
mds$car <- rownames(mds)
ggplot(mds, aes(V1, V2, label = car)) +
    geom_text_repel() + theme_bw()

subset(mtcars, hp >= 200)

## #############################################################################
## introduction to Simpson's paradox with the Berkeley example

## then do the analysis in R
UCBAdmissions
plot(UCBAdmissions)

berkeley <- as.data.frame(UCBAdmissions)

ggplot(berkeley, aes(Gender, Freq, fill = Admit)) + geom_col()

p <- ggplot(berkeley, aes(Gender, Freq, fill = Admit)) + geom_col(position = 'fill')
p

p + facet_wrap(~Dept)
p + facet_wrap(~Dept) + scale_fill_manual(values = c('Admitted' = 'darkgreen', 'Rejected' = 'red'))
p + facet_wrap(~Dept) + scale_fill_brewer(palette = 'Dark2')

## #############################################################################
## TODO exercise visualize a model on the association between
## the lengh and width of sepal in the iris dataset

?iris
str(iris)

ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point()
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point() +
    geom_smooth()
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point() +
    geom_smooth(method = 'lm', se = FALSE)
## note the change in the sign of the slope!
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + geom_point() +
    geom_smooth(method = 'lm', se = FALSE)

summary(lm(Sepal.Width ~ Sepal.Length, data = iris))
summary(lm(Sepal.Width ~ Sepal.Length + Species, data = iris))

## NOTE when checking the scatterplot colored by Species
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + geom_point()
## compare the overlap of groups with the MDS version:
mds <- as.data.frame(cmdscale(dist(iris)))
ggplot(mds, aes(V1, V2, color = iris$Species)) + geom_point()
ggplot(mds, aes(V1, V2, color = iris$Species)) + geom_point() + geom_smooth(method = 'lm')

## #############################################################################
## more on data transformations: data.table

library(data.table)

?fread

bookings <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
str(bookings)
bookings

## dt[i]
bookings[1]
bookings[1:5]
bookings[price < 100]
bookings[offer == 0 & price < 100]
bookings[price < 100 & offer == 0 & nnights == 4 & holiday == 1]
bookings[price < 100 & offer == 0 & nnights == 4 & holiday == 1][1:5]

## dt[i, j]
bookings[, .N]
bookings[price < 100, .N]
bookings[price < 100, mean(price)]
bookings[price < 100, summary(price)]
bookings[price < 100, hist(price)]

## TODO compute the average price of bookings on weekends
bookings[weekend == 1, mean(price)]
## TODO compute the average price of bookings on weekdays
bookings[weekend == 0, mean(price)]

bookings[, mean(price), by = weekend] # dt[, j, by]
bookings[, mean(price), by = weekend][order(weekend)] # dt[, j, by][i]
?setorder

str(bookings)
bookings[, mean(price), by = list(weekend, nnights)]
bookings[, mean(price), by = .(weekend, nnights, holiday, year)]

bookings[, .(price = mean(price)), by = .(weekend, nnights, holiday, year)]

bookings[, .(price = mean(price), .N), by = .(weekend, nnights, holiday, year)]
bookings[, .(price = mean(price), .N, min = min(price), max = max(price)),
         by = .(weekend, nnights, holiday, year)]

## TODO compute the average price per number of stars
?merge
## x[y] -> rolling joins, overlap joins

features <- fread('http://bit.ly/CEU-R-hotels-2018-features')
merge(bookings, features)

## NOTE hotel_id was picked as the join key
bookings[hotel_id == 1]
features[hotel_id == 1]
merge(bookings, features)[hotel_id == 1]

## NOTE there's a missing row??
bookings[, .N]
merge(bookings, features)[, .N]

features[is.na(hotel_id)]
bookings[!hotel_id %in% features$hotel_id]
features[hotel_id == 2]

## NOTE do we really need to merge features to all bookings??
booking_summary <- bookings[, .(price = mean(price)), by = hotel_id]
hotels <- merge(features, booking_summary, by = 'hotel_id')
hotels[, mean(price), by = stars][order(stars)]

## hm ... 4.5 stars more expensive than 5 stars?
## probaly only a few cases with 4.5 stars ...
## should we divide price per nnights?
bookings[hotel_id == 2]

booking_summary <- bookings[, .(bookings = .N, price = mean(price/ nnights)), by = hotel_id]
hotels <- merge(features, booking_summary, by = 'hotel_id')
hotels[, .(bookings = sum(bookings), price = mean(price)), by = stars][order(stars)]

## #############################################################################
## creating new variables: numeric

## new variable via the data.frame way
bookings$price_per_night <- bookings$price / bookings$nnights
## new variable via data.table's in-place update operator
bookings[, price_per_night := price / nnights]

hotels <- merge(
  features,
  bookings[, .(bookings = .N, price_per_night = mean(price_per_night)), by = hotel_id],
  by = 'hotel_id')

## TODO compute average price per number of stars
hotels[, mean(price_per_night), by = stars]
hotels[, mean(price_per_night), by = stars][order(stars)]
hotels[!is.na(stars), mean(price_per_night), by = stars][order(stars)]
hotels[!is.na(stars), .(rating = mean(price_per_night)), by = stars][order(stars)]
## NOTE we have not weighted ...
hotels[!is.na(stars), .(rating = weighted.mean(
  price_per_night, bookings, na.rm = TRUE)), by = stars][order(stars)]

plot(hotels[!is.na(stars), .(rating = weighted.mean(
  price_per_night, bookings, na.rm = TRUE)), by = stars][order(stars)])

## TODO list countries above average rating
countries <- hotels[, .(
    price = mean(price_per_night),
    rating = mean(rating, na.rm = TRUE),
    stars = mean(stars, na.rm = TRUE)
), by = country]
countries[country == 'Hungary']

mean(countries$rating, na.rm = TRUE)
countries[rating > mean(rating, na.rm = TRUE)]

## #############################################################################
## creating new variables: numeric to factor

## TODO add a new column to hotels: categorize price into 3 buckets
?cut
hotels[, pricecat := cut(price_per_night, 3, dig.lab = 8)]
str(hotels)
hotels[, .N, by = pricecat]

hotels[, pricecat := cut(price_per_night, c(0, 100, 250, Inf))]
hotels[, .N, by = pricecat]

hotels[, pricecat := cut(price_per_night, c(0, 100, 250, Inf),
                         labels = c('cheap', 'average', 'expensive'))]
hotels[, .N, by = pricecat]

## TODO use a stats approach to categorize hotels into below avg, avg, above avg price groups
price_mean <- mean(hotels$price_per_night)
price_sd <- sd(hotels$price_per_night)

## NOTE below avg: 0 -> mean - sd
## NOTE avg: mean - sd -> mean + sd
## NOTE above avg: mean + sd

hotels[, pricecat := cut(price_per_night, c(
  0,
  price_mean - price_sd,
  price_mean + price_sd,
  Inf),
  labels = c('below avg', 'avg', 'above avg'))]
hotels[, .N, by = pricecat]
## NOTE skewed distribution & very different by country

## TODO avg and sd by country
hotels[, avg_price_per_country := mean(price_per_night), by = country]
hotels[, sd_price_per_country := sd(price_per_night), by = country]
str(hotels)

hotels[, pricecat := cut(price_per_night, c(
  0,
  avg_price_per_country[1] - sd_price_per_country[1], # NOTE skip [1] first
  avg_price_per_country[1] + sd_price_per_country[1],
  Inf),
  labels = c('below avg', 'avg', 'above avg')),
  by = country]
## OH NOOO!!

hotels[, .N, by = pricecat]

## NOTE the above not working due to
hotels[, hotels_per_country := .N, by = country]
hotels[hotels_per_country == 1]
hotels <- hotels[hotels_per_country > 1]

## TODO create a new variable on city type: small / big <- number of hotels in the city
hotels[, hotels_per_city := .N, by = city_actual]
hotels[, citytype := cut(hotels_per_city, 2, labels = c('small', 'big'))]
hotels[, .N, by = citytype]

## TODO number of cases by citytype + pricecat
hotels[, .N, by = .(pricecat, citytype)][order(pricecat, citytype)]
hotels[, .N, by = .(pricecat, citytype)][order(-N)]

hotels[citytype == 'big', .N, by = country]

## TODO compute percentages of price categories withing city typex
price_per_type <- hotels[, .N, by = list(pricecat, citytype)][order(citytype, pricecat)]
price_per_type[, P := N / sum(N), by = citytype]
price_per_type[, P := round(N / sum(N) * 100, 2), by = citytype]
price_per_type

## #############################################################################
## creating new variables: numeric to numeric

## TODO create a new variable with the count of hotels in the same country
hotels[, hotels_in_country := .N, by = country]

## TODO create a new variable with the count of cities in the same country
hotels[, cities_in_country := length(unique(city_actual)), by = country]

## NOTE does not work below???

## TODO create a new variable with the count of small cities in the same country
## NOTE longer example if we have time
unique(hotels, by = 'city_actual')
unique(hotels, by = 'city_actual')[, .(city_actual, citytype)]
unique(hotels, by = 'city_actual')[, .(city_actual, citytype)][citytype == 'big']
## NOTE Rome?

hotels[, citytype := cut(hotels, 2)]
hotels[, .N, by = citytype]
hotels[, citytype := cut(hotels, 2, dig.lab = 8)]
hotels[, .N, by = citytype]

hotels[, citytype := cut(hotels, c(0, 250, Inf), labels = c('small', 'big'))]
hotels[, .N, by = citytype]

unique(hotels, by = 'city_actual')[, .(city_actual, citytype)][citytype == 'big']

hotels[, .N, by = .(country, citytype)][citytype == 'small']
hotels[citytype == 'small', .N, by = .(country, citytype)]
## NOTE drop citytype from group by

hotels[citytype == 'small', unique(length(city_actual)), by = country]
country_summary <- hotels[citytype == 'small',
                          .(small_cities_in_country = unique(length(city_actual))),
                          by = country]

hotels <- merge(hotels, country_summary, by = 'country')

## #############################################################################
## multiple summaries

## reminder
hotels[, .(price_avg = mean(price_per_night)), by = city]

## TODO compute the average price, rating and stars per city in a new dataset
hotels[, .(price_avg = mean(price_per_night),
           rating_avg = mean(rating),
           stars_avg = mean(stars)), by = city]

## NOTE we need to remove NAs
hotels[, .(price_avg = mean(price_per_night),
           rating_avg = mean(rating, na.rm = TRUE),
           stars_avg = mean(stars, na.rm = TRUE)), by = city]

## TODO check the same on distance and the number of bookings as well ...
hotels[, lapply(.SD, mean), by = city,
       .SDcols = c('price_per_night', 'rating', 'stars', 'distance', 'bookings')]

hotels[, lapply(.SD, mean, na.rm = TRUE), by = city,
       .SDcols = c('price_per_night', 'rating', 'stars', 'distance', 'bookings')]

numcols <- c('price_per_night', 'rating', 'stars', 'distance', 'bookings')
hotels[, lapply(.SD, mean, na.rm = TRUE), by = city, .SDcols = numcols]

sapply(hotels, is.numeric)
numcols <- which(sapply(hotels, is.numeric))
hotels[, lapply(.SD, mean, na.rm = TRUE), by = city, .SDcols = numcols]

## #############################################################################
## extra examples on multiple summaries

## TODO min, avg, median and max price in EUR per city
hotels[, list(
    min_price = min(price_per_night),
    price_per_night = mean(price_per_night),
    med_price = median(price_per_night),
    max_price = max(price_per_night)
), by = city]

## TODO round it up to EUR
hotels[, list(
    min_price = round(min(price_per_night)),
    price_per_night = round(mean(price_per_night)),
    med_price = round(median(price_per_night)),
    max_price = round(max(price_per_night))
), by = city]

mystats <- function(x) list(
    min = min(x),
    mean = mean(x),
    median = median(x),
    max = max(x))

hotels[, lapply(.SD, mystats), .SDcols = c('price_per_night')]
hotels[, as.list(unlist(lapply(.SD, mystats))), .SDcols = c('price_per_night')]

mystats <- function(x) list(
    min = round(min(x, na.rm = TRUE), 2),
    mean = round(mean(x, na.rm = TRUE), 2),
    median = round(median(x, na.rm = TRUE), 2),
    max = round(max(x, na.rm = TRUE), 2))
hotels[, as.list(unlist(lapply(.SD, mystats))), .SDcols = c('price_per_night', 'rating')]
hotels[, as.list(unlist(lapply(.SD, mystats))), .SDcols = which(sapply(hotels, is.numeric))]
summary(hotels)

hotels[, as.list(unlist(lapply(.SD, mystats))), .SDcols = which(sapply(hotels, is.numeric)), by = country]

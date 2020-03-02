## 1. Load `bookings` data from http://bit.ly/CEU-R-hotels-2018-prices and the hotel `features` from http://bit.ly/CEU-R-hotels-2018-features
library(data.table)
bookings <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
features <- fread('http://bit.ly/CEU-R-hotels-2018-features')

## 2. Count the number of 4 stars hotels in Hungary
features[stars == 4 & country == 'Hungary', .N]
nrow(features[stars == 4 & country == 'Hungary'])

## 3. Compute the average rating of 4 and 5 star hotels in Hungary and Germany
features[stars >= 4 & country %in% c('Hungary', 'Germany'), mean(rating, na.rm = TRUE)]
features[stars >= 4 & country %in% c('Hungary', 'Germany') & !is.na(rating), mean(rating)]

## 4. Round up the previously computed average rating to 2 digits
features[stars >= 4 & country %in% c('Hungary', 'Germany') & !is.na(rating), round(mean(rating), 2)]

## 5. Do we have any bookings in unknown hotels (as per the features dataset)?
bookings[!hotel_id %in% unique(features$hotel_id)]
features

## 6. Clean up the bookings dataset from bookings from unknown hotels and print the number of remaining bookings
bookings <- bookings[hotel_id %in% unique(features$hotel_id)]

## 7. What's the average distance of hotels from the city central in Budapest
features[city_actual == 'Budapest', mean(distance)]

## 8. List all neighbourhoods in Budapest
features[city_actual == 'Budapest', unique(neighbourhood)]
features[city_actual == 'Budapest', mean(distance), by = neighbourhood][, neighbourhood]

## 9. Compute the average distance from the city center for the neighbourhoods in Budapest
features[city_actual == 'Budapest', mean(distance), by = neighbourhood]

## 10. Count the number of bookings in Hungary
bookings[hotel_id %in% features[country == 'Hungary', hotel_id], .N]

## 11. Count the number of nights booked in Hungary
merge(bookings, features, by = 'hotel_id')[country == 'Hungary'][, sum(nnights)]

## 12. Compute the average number of nights per booking in Hungary
merge(bookings, features, by = 'hotel_id')[country == 'Hungary'][, mean(nnights)]

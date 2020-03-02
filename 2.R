# 1. Load `bookings` data from http://bit.ly/CEU-R-hotels-2018-prices and the hotel `features` from http://bit.ly/CEU-R-hotels-2018-features
library(data.table)
bookings <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
str(bookings)
features <- data.table(read.csv('http://bit.ly/CEU-R-hotels-2018-features', encoding="UTF-8", stringsAsFactors = F))
str(features)
?fread
# 2. Count the number of 4 stars hotels in Hungary
nrow(features[country %in% c("Hungary") & stars == 4,])

# 3. Compute the average rating of 4 and 5 star hotels in Hungary and Germany
a <- features[country %in% c("Hungary", "Germany") & stars %in% c(4,5),]
mean(na.omit(a$rating))
features[country %in% c("Hungary", "Germany") & stars %in% c(4,5),mean(rating, na.rm = TRUE)]
# 4. Round up the previously computed average rating to 2 digits
# 5. Do we have any bookings in unknown hotels (as per the features dataset)?
bookings[!hotel_id %in% unique(features$hotel_id)]

# 6. Clean up the bookings dataset from bookings from unknown hotels and print the number of remaining bookings
bookings[hotel_id != 2]
bookings[hotel_id %in% unique(features$hotel_id)]

# 7. What's the average distance of hotels from the city central in Budapest?
str(features)
features[city == "Budapest" & accommodation_type == "Hotel", mean(distance, na.rm = TRUE)]

# 8. List all neighbourhoods in Budapest
features[city == "Budapest" ,unique(neighbourhood)]

# 9. Compute the average distance from the city center for the neighbourhoods in Budapest
str(features)
features[city == "Budapest", mean(distance, na.rm = T), by=neighbourhood]

# 10. Count the number of bookings in Hungary
# 11. Count the number of nights booked in Hungary
# 12. Compute the average number of nights per booking in Hungary


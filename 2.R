#############################
# Second class - Data.Table #
#############################

# 1. Load `bookings` data from http://bit.ly/CEU-R-hotels-2018-prices and the hotel `features` from http://bit.ly/CEU-R-hotels-2018-features

library(data.table)
booking <- fread('http://bit.ly/CEU-R-hotels-2018-prices')
hotels <- fread('http://bit.ly/CEU-R-hotels-2018-features')
str(booking)
str(hotels)

# 2. Count the number of 4 stars hotels in Hungary
hotels[stars == 4 & country == 'Hungary', .N]

# 3. Compute the average rating of 4 and 5 star hotels in Hungary and Germany
hotels[stars == 4 | stars == 5 & country == 'Hungary' | country == 'Germany', list(avg_rate = mean(rating)), by = list(stars, country)]

hotels[stars == 4 | stars == 5 & country == 'Hungary' | country == 'Germany', mean(rating, na.rm = TRUE)]

# 4. Round up the previously computed average rating to 2 digits
round(hotels[stars == 4 | stars == 5 & country == 'Hungary' | country == 'Germany', mean(rating, na.rm = TRUE)], 2)

# 5. Do we have any bookings in unknown hotels (as per the features dataset)?
booking[!hotel_id %in% unique(hotels$hotel_id)]

# 6. Clean up the bookings dataset from bookings from unknown hotels and print the number of remaining bookings
booking[hotel_id != 2]
booking[hotel_id %in% unique(hotels$hotel_id)]

# 7. What's the average distance of hotels from the city central in Budapest?

# 8. List all neighbourhoods in Budapest

# 9. Compute the average distance from the city center for the neighbourhoods in Budapest

# 10. Count the number of bookings in Hungary
# 11. Count the number of nights booked in Hungary
# 12. Compute the average number of nights per booking in Hungary




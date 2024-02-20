
require(dplyr)
require(gbfs)
require(lubridate)

# cities <- get_gbfs_cities()
Sys.setenv(TZ = "EST")

current_date <- Sys.Date()
current_hour <- hour(Sys.time())

file_name_bird <- paste0("Data/Escooter/Collected/bird_",current_date,"_",current_hour,".csv")
file_name_lime <- paste0("Data/Escooter/Collected/lime_",current_date,"_",current_hour,".csv")

print(c(file_name_lime,file_name_bird))

nyc_bird <- list()
nyc_lime <- list()

Sleep.time <- 30 # seconds 

# estimate duration
current_time <- Sys.time()
end_time <- ceiling_date(current_time, unit = "hour")
Duration <- difftime(end_time,current_time, units = "secs") # one hour

print(Duration)

N <- (Duration/Sleep.time) %>% as.integer()

for (i in 1:N) {
  nyc_bird[[i]] <- get_free_bike_status(
    city= "https://mds.bird.co/gbfs/v2/public/new-york/gbfs.json",
    output="return")
  
  nyc_lime[[i]] <- get_free_bike_status(
    city= "https://data.lime.bike/api/partners/v2/gbfs/new_york/gbfs.json",
    output="return")
  Sys.sleep(Sleep.time)
}

bird <- bind_rows(nyc_bird)
lime <- bind_rows(nyc_lime)

write.csv(bird, file = file_name_bird)
write.csv(lime, file = file_name_lime)



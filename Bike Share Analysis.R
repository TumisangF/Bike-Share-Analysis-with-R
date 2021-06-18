#Cyclist_Exercise

#The purpose of this script is to consolidate downloaded Divvy data into a single dataframe
#Then conduct simple analysis to help answer the key question:
#"In what ways do members and casual riders use Divvy bikes differently?"

#Install and load required packages and set up the working directory
library(pacman)
pacman::p_load(pacman,tidyverse,lubridate,ggplot2,dplyr,psych)

#Set working directory
setwd("C:/Users/T Fokase/Desktop/Bike Share Case Study/Data/12_months_data/")


#====================
#STEP 1: COLLECT DATA
#===================

#upload Divvy datasets(csv files)
tripdata_2020_04 <- read_csv('202004-divvy-tripdata.csv')
tripdata_2020_05 <- read_csv('202005-divvy-tripdata.csv')
tripdata_2020_06 <- read_csv('202006-divvy-tripdata.csv')
tripdata_2020_07 <- read_csv('202007-divvy-tripdata.csv')
tripdata_2020_08 <- read_csv('202008-divvy-tripdata.csv')
tripdata_2020_09 <- read_csv('202009-divvy-tripdata.csv')
tripdata_2020_10 <- read_csv('202010-divvy-tripdata.csv')
tripdata_2020_11 <- read_csv('202011-divvy-tripdata.csv')
tripdata_2020_12 <- read_csv('202012-divvy-tripdata.csv')
tripdata_2021_01 <- read_csv('202101-divvy-tripdata.csv')
tripdata_2021_02 <- read_csv('202102-divvy-tripdata.csv')
tripdata_2021_03 <- read_csv('202103-divvy-tripdata.csv')
tripdata_2021_04 <- read_csv('202104-divvy-tripdata.csv')


#===================================================
#STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#===================================================

#Compare the column names of each of the files.
#Names need to match perfectly before we can join.
colnames(tripdata_2020_04)
colnames(tripdata_2020_05)
colnames(tripdata_2020_06)
colnames(tripdata_2020_07)
colnames(tripdata_2020_08)
colnames(tripdata_2020_09)
colnames(tripdata_2020_10)
colnames(tripdata_2020_11)
colnames(tripdata_2020_12)
colnames(tripdata_2021_01)
colnames(tripdata_2021_02)
colnames(tripdata_2021_03)
colnames(tripdata_2021_04)
colnames(tripdata_2020_05)

#Compare the column names of each of the files.
#Names need to match perfectly before we can join.

#compare the structure of the table
str(tripdata_2020_04)
str(tripdata_2020_05)
str(tripdata_2020_06)
str(tripdata_2020_07)
str(tripdata_2020_08)
str(tripdata_2020_09)
str(tripdata_2020_10)
str(tripdata_2020_11)
str(tripdata_2020_12)
str(tripdata_2021_01)
str(tripdata_2021_02)
str(tripdata_2021_03)
str(tripdata_2021_04)

#Convert start_station_id and end_station_id to number so that they can stack correctly
tripdata_2020_04 <- mutate(tripdata_2020_04, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2020_05 <- mutate(tripdata_2020_05, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2020_06 <- mutate(tripdata_2020_06, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2020_07 <- mutate(tripdata_2020_07, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2020_08 <- mutate(tripdata_2020_08, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2020_09 <- mutate(tripdata_2020_09, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2020_10 <- mutate(tripdata_2020_10, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2020_11 <- mutate(tripdata_2020_11, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2020_12 <- mutate(tripdata_2020_12, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2021_01 <- mutate(tripdata_2021_01, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2021_02 <- mutate(tripdata_2021_02, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2021_03 <- mutate(tripdata_2021_03, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))
tripdata_2021_04 <- mutate(tripdata_2021_04, start_station_id = as.character(start_station_id),
                           end_station_id = as.character(end_station_id))

#check to see if it worked.
str(tripdata_2020_05)
str(tripdata_2020_06)
str(tripdata_2020_07)
str(tripdata_2020_08)
str(tripdata_2020_09)
str(tripdata_2020_10)
str(tripdata_2020_11)

#Combine all the individual data frame into one big data frame
all_tripdata <- bind_rows(tripdata_2020_04,tripdata_2020_05,tripdata_2020_06,tripdata_2020_07,
                          tripdata_2020_08,tripdata_2020_09,tripdata_2020_10,tripdata_2020_11,
                          tripdata_2020_12,tripdata_2021_01,tripdata_2021_02,tripdata_2021_03,
                          tripdata_2021_04)


#======================================================
#STEP3 : CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================

#Inspect the new table that has been created
colnames(all_tripdata)
nrow(all_tripdata)
dim(all_tripdata)
head(all_trips)
str(all_tripdata)
summary(all_tripdata)

#The data can only be aggregated at the ride-level, 
#which is too granular. We will want to add some additional columns of data 
#-- such as day, month, year -- that provide additional opportunities to aggregate the data.
all_tripdata$date <- as.Date(all_tripdata$started_at) #The default format is yyyy-mm-dd
all_tripdata$month <- format(as.Date(all_tripdata$date), "%m")
all_tripdata$day <- format(as.Date(all_tripdata$date), "%d")
all_tripdata$year <- format(as.Date(all_tripdata$date), "%Y")
all_tripdata$day_of_week <- format(as.Date(all_tripdata$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)
all_tripdata$ride_length <- difftime(all_tripdata$ended_at,all_tripdata$started_at)

# Inspect the structure of the columns
str(all_tripdata)

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(all_tripdata$ride_length)                    #Checks to see if data type is a factor
all_tripdata$ride_length <- as.numeric(as.character(all_tripdata$ride_length)) #Conversion to numeric
is.numeric(all_tripdata$ride_length)       #Checks to see if the data is numeric

# Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of docks and
# checked for quality by Divvy or ride_length was negative
summary(all_tripdata$ride_length)

# We will create a new version of the dataframe (v2) since data is being removed
all_trip_data_v2 <- all_tripdata[!(all_tripdata$start_station_name == "HQ QR" | all_tripdata$ride_length<0),]

#create another version(v3) that omits missing values(NAs)
all_trip_data_v3 <- na.omit(all_trip_data_v2)


#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================

#Descriptive analysis on ride_length (all figures in seconds)
mean(all_trip_data_v3$ride_length)  #straight average (total ride length / rides)
median(all_trip_data_v3$ride_length)     #midpoint number in the ascending array of ride lengths
max(all_trip_data_v3$ride_length)        #longest ride
min(all_trip_data_v3$ride_length)        #shortest 

# You can condense the four lines above to one line using summary() on the specific attribute
summary(all_trip_data_v3$ride_length)

# Compare members and casual users
aggregate(all_trip_data_v3$ride_length ~ all_trip_data_v3$member_casual, FUN = mean)
aggregate(all_trip_data_v3$ride_length ~ all_trip_data_v3$member_casual, FUN = median)
aggregate(all_trip_data_v3$ride_length ~ all_trip_data_v3$member_casual, FUN = max)
aggregate(all_trip_data_v3$ride_length ~ all_trip_data_v3$member_casual, FUN = min)

#See the average ride time by each day for members vs casual users
aggregate(all_trip_data_v3$ride_length ~ all_trip_data_v3$member_casual + 
            all_trip_data_v3$day_of_week,FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
all_trip_data_v3$day_of_week <- ordered(all_trip_data_v3$day_of_week, 
                                levels=c("Sunday", "Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trip_data_v3$ride_length ~ all_trip_data_v3$member_casual + 
          all_trip_data_v3$day_of_week, FUN = mean)

# analyze ridership data by type and weekday
all_trip_data_v3 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>% #creates weekday field using wday()
  group_by(member_casual, weekday) %>%                 #groups by usertype and weekday
  summarise(number_of_rides = n(),                     #calculates the number of rides and average duration
  average_duration = mean(ride_length)) %>%           # calculates the average duration
  arrange(member_casual, weekday)

# Let's visualize the number of rides by rider type
all_trip_data_v3 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(),
  average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Number of Rides vs Weekdays",x = "Weekdays",y = "Number of Rides",fill = "Type of Rider") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual("Type of Rider", values = c("casual"= "#6da9d2", "member" = "#0048ba"))

# Let's create a visualization for average duration
all_trip_data_v3 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(),
  average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  labs(title = "Average Duration vs Weekdays",x = "Weekdays",y = "Average Duration",fill = "Type of Rider") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_manual("Type of Rider", values = c("casual"= "#6da9d2", "member" = "#0048ba")) +
  geom_col(position = "dodge")

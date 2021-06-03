### Cyclistic_Exercise_Full_Year_Analysis ###

# This analysis is for case study 1 from the Google Data Analytics Certificate (Cyclistic).  
# It’s originally based on the case study "'Sophisticated, Clear, and Polished’: Divvy and Data Visualization" written by Kevin Hartman (found here: https://artscience.blog/home/divvy-dataviz-case-study). 
# We will be using the Divvy dataset for the case study. 
# The purpose of this script is to consolidate downloaded Divvy data into a single dataframe and then conduct simple analysis to help answer the key question: “In what ways do members and casual riders use Divvy bikes differently?

# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# libridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)    #helps visualize data
getwd()             #displays your working directory
setwd("/home/tumisang/Desktop/Data Analytics/Google Certificate/8. Google Data Analytics Capstone: Complete a Case Study/Case Study 1/Analysis using R")

#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload Divvy datasets (csv files) here

q2_2019 <- read_csv("Divvy_Trips_2019_Q2.zip")
q3_2019 <- read_csv("Divvy_Trips_2019_Q3.zip")
q4_2019 <- read_csv("Divvy_Trips_2019_Q4.zip")
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.zip")

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compare column names each of the files
# While the names don't have to be in the same order, they DO need to match perfectly before before we can use a command to join them into one file

colnames(q3_2019)
colnames(q4_2019)
colnames(q2_2019)
colnames(q1_2020)

# Rename columns  to make them consistent with q1_2020 (as this will be the supposed going-forward table design for Divvy)
q4_2019 <- rename(q4_2019
                  ,ride_id = trip_id
                  ,rideable_type = bikeid 
                  ,started_at = start_time  
                  ,ended_at = end_time  
                  ,start_station_name = from_station_name 
                  ,start_station_id = from_station_id 
                  ,end_station_name = to_station_name 
                  ,end_station_id = to_station_id 
                  ,member_casual = usertype)
q3_2019 <- rename(q3_2019
                  ,ride_id = trip_id
                  ,rideable_type = bikeid 
                  ,started_at = start_time  
                  ,ended_at = end_time  
                  ,start_station_name = from_station_name 
                  ,start_station_id = from_station_id 
                  ,end_station_name = to_station_name 
                  ,end_station_id = to_station_id 
                  ,member_casual = usertype)
q2_2019 <- rename(q2_2019
                  ,ride_id = trip_id
                  ,rideable_type = bikeid
                  ,started_at = start_time
                  ,ended_at = end_time
                  ,start_station_name = from_station_name  
                  ,start_station_id = from_station_id
                  ,end_station_name = to_station_name
                  ,end_station_id = to_staion_id
                  ,member_casual = usertype)

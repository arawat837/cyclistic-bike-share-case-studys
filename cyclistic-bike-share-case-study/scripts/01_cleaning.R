# =========================================================
# Cyclistic Bike-Share Case Study
# Author: Abhishek Rawat
# Date: 2025-09-01
# Purpose: Analyze differences between casual riders and members
# =========================================================

# --- Load Packages ---
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, lubridate, vroom, janitor, duckdb, writexl)

# --- Define Paths ---
base_path   <- "C:/Users/abhis/OneDrive/Documents/Desktop/Cyclistic_BikeShare_CaseStudy/Cyclistic_BikeShare_CaseStudy"
data_path   <- file.path(base_path, "data")
output_path <- file.path(base_path, "outputs")

# --- Import Data ---
files <- list.files(path = data_path, pattern = "*.csv", full.names = TRUE)

all_trips <- vroom(files) %>%
  clean_names()

glimpse(all_trips)

# --- Cleaning ---
all_trips <- all_trips %>%
  mutate(
    started_at   = ymd_hms(started_at),
    ended_at     = ymd_hms(ended_at),
    ride_length  = as.numeric(difftime(ended_at, started_at, units = "mins")),
    day_of_week  = wday(started_at, label = TRUE, abbr = FALSE),
    month        = month(started_at, label = TRUE, abbr = FALSE)
  ) %>%
  filter(ride_length > 1, ride_length < 1440) %>%
  filter(member_casual %in% c("member", "casual"))

# Quick checks
dim(all_trips)
summary(all_trips$ride_length)
table(all_trips$member_casual)


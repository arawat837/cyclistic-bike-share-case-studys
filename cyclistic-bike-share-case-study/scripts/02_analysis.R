
# --- Define Plot Theme ---
theme_cyclistic <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# --- Analysis: Average Ride Length ---
avg_ride_length <- all_trips %>%
  group_by(member_casual) %>%
  summarise(
    avg_minutes   = mean(ride_length, na.rm = TRUE),
    median_minutes = median(ride_length, na.rm = TRUE),
    n_rides       = n(),
    .groups = "drop"
  )

print(avg_ride_length)

p1 <- ggplot(avg_ride_length, aes(x = member_casual, y = avg_minutes, fill = member_casual)) +
  geom_col(width = 0.6) +
  labs(title = "Average Ride Length: Members vs Casuals",
       x = "Rider Type", y = "Average Ride Length (minutes)") +
  theme_cyclistic

ggsave(file.path(output_path, "avg_ride_length.png"), plot = p1, width = 6, height = 4, dpi = 300)

# --- Analysis: Rides by Weekday ---
rides_weekday <- all_trips %>%
  group_by(member_casual, day_of_week) %>%
  summarise(rides = n(), .groups = "drop")

print(rides_weekday)

p2 <- ggplot(rides_weekday, aes(x = day_of_week, y = rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Rides by Day of Week: Members vs Casuals",
       x = "Day of Week", y = "Number of Rides") +
  theme_cyclistic

ggsave(file.path(output_path, "rides_by_weekday.png"), plot = p2, width = 7, height = 5, dpi = 300)

# --- Analysis: Rides by Month ---
rides_month <- all_trips %>%
  group_by(member_casual, month) %>%
  summarise(rides = n(), .groups = "drop")

print(rides_month)

p3 <- ggplot(rides_month, aes(x = month, y = rides, color = member_casual, group = member_casual)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(title = "Rides by Month: Members vs Casuals",
       x = "Month", y = "Number of Rides") +
  theme_cyclistic

ggsave(file.path(output_path, "rides_by_month.png"), plot = p3, width = 7, height = 5, dpi = 300)

# --- Export Cleaned Dataset ---
write_csv(all_trips, file.path(output_path, "all_trips_cleaned.csv"))

# Sample rows for presentation/demo
sample_rows <- all_trips %>% sample_n(10)
write_csv(sample_rows, file.path(output_path, "sample_cleaned_data.csv"))

# --- Aggregated Summaries ---
summary_month <- all_trips %>%
  group_by(member_casual, month) %>%
  summarise(
    rides = n(),
    avg_ride_length = mean(ride_length, na.rm = TRUE),
    .groups = "drop"
  )

summary_weekday <- all_trips %>%
  group_by(member_casual, day_of_week) %>%
  summarise(
    rides = n(),
    avg_ride_length = mean(ride_length, na.rm = TRUE),
    .groups = "drop"
  )

summary_overall <- all_trips %>%
  group_by(member_casual) %>%
  summarise(
    total_rides = n(),
    avg_ride_length = mean(ride_length, na.rm = TRUE),
    median_ride_length = median(ride_length, na.rm = TRUE),
    .groups = "drop"
  )

# Save Excel workbook with 3 sheets
write_xlsx(
  list(
    "By Month"   = summary_month,
    "By Weekday" = summary_weekday,
    "Overall"    = summary_overall
  ),
  file.path(output_path, "cyclistic_summary.xlsx")
)

# Save RDS for faster reload (optional)
saveRDS(all_trips, file.path(output_path, "all_trips_cleaned.rds"))
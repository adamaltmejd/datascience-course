# Dogs

Small dog-shelter files used in the wrangling lectures.

## Files

- `dog_inventory.csv`: intentionally messy intake file used for import checks
- `dog_breeds.csv`: breed lookup table used for joins
- `dog_sales.csv`: transaction-style table used for join and date practice
- `dog_events.csv`: timestamped intake, vet-check, and adoption log used for time and composite-key practice

## Teaching Purpose

The files are small enough to inspect by hand but messy enough to teach real import habits:

- metadata lines before the header
- non-UTF-8 text in names
- spaces in column names
- identifier columns that must stay character
- fake missing-value codes such as `-99`
- multiple related tables for join checks
- local timestamps without an explicit timezone column

## Reading Notes

`dog_inventory.csv` needs explicit import choices:

```r
dogs <- data.table::fread(
  "data-sources/data/dogs/dog_inventory.csv",
  skip = 3,
  encoding = "Latin-1",
  check.names = TRUE,
  na.strings = c("", "-99"),
  colClasses = list(character = "dog_id")
)
```

`dog_events.csv` stores `event_time` as Swedish local clock time, but the timezone is not written in the file. For timestamp work, read the timestamp as text first and then parse it with the intended timezone:

```r
events <- data.table::fread(
  "data-sources/data/dogs/dog_events.csv",
  colClasses = list(character = c("dog_id", "event_time"))
)

events[, event_time := as.POSIXct(
  event_time,
  format = "%Y-%m-%d %H:%M:%S",
  tz = "Europe/Stockholm"
)]
```

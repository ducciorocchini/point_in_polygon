Great! Let's revise your code example using **simulated data** so that it’s fully self-contained and reproducible without relying on external shapefiles like GBIF or WDPA datasets. We'll simulate some **random species sightings** (points) and **protected areas** (polygons), perform the **point-in-polygon** test using `sf`, and then generate a **final plot** using `ggplot2`.

---

### ✅ Revised R Code with Simulated Data and Plot

```r
# Load required libraries
library(sf)
library(dplyr)
library(ggplot2)

# Set random seed for reproducibility
set.seed(1234)

# 1. Simulate protected area polygons (as simple squares)
protected_areas <- st_sf(
  reserve_name = c("Reserve A", "Reserve B"),
  geometry = st_sfc(
    st_polygon(list(rbind(c(2,2), c(5,2), c(5,5), c(2,5), c(2,2)))),  # Reserve A
    st_polygon(list(rbind(c(6,6), c(9,6), c(9,9), c(6,9), c(6,6))))   # Reserve B
  ),
  crs = 4326
)

# 2. Simulate species sightings (random points)
num_points <- 100
sightings_points <- data.frame(
  id = 1:num_points,
  lon = runif(num_points, 0, 10),
  lat = runif(num_points, 0, 10)
)

# Convert to sf point object
sightings <- st_as_sf(sightings_points, coords = c("lon", "lat"), crs = 4326)

# 3. Perform spatial join to test which points are inside reserves
sightings_in_reserves <- st_join(sightings, protected_areas)

# 4. Label whether the point is inside any reserve
sightings_in_reserves <- sightings_in_reserves %>%
  mutate(inside_protected_area = !is.na(reserve_name))

# 5. Final output: print some points inside protected areas
print(head(sightings_in_reserves[sightings_in_reserves$inside_protected_area, ]))

# 6. Plotting
ggplot() +
  geom_sf(data = protected_areas, fill = "lightgreen", color = "darkgreen", alpha = 0.4) +
  geom_sf(data = sightings_in_reserves, aes(color = inside_protected_area), size = 1.5) +
  scale_color_manual(values = c("FALSE" = "red", "TRUE" = "blue")) +
  theme_minimal() +
  labs(title = "Simulated Species Sightings in Protected Areas",
       subtitle = "Blue = Inside Protected Area, Red = Outside",
       color = "Inside Protected Area")
```

---

### 🗺️ What This Does:

- Simulates **2 square protected areas**.
- Generates **100 random species sightings** in a 10x10 area.
- Performs a **point-in-polygon** analysis using `st_join`.
- Uses `ggplot2` to make a clear map where:
  - Blue points = inside a reserve
  - Red points = outside reserves

---

Let me know if you'd like to export this as an image or embed the plot in a PDF or report. Also, would you like me to write a small explanation block in LaTeX to include in your document?

library(ggplot2)
library(dplyr)
library(tidyr)

# Define polygon
polygon <- data.frame(
  x = c(1, 4, 6, 4, 1),
  y = c(1, 1, 4, 6, 4)
)
polygon <- rbind(polygon, polygon[1, ])

# Define two test points: one inside, one outside
points <- data.frame(
  name = c("Inside", "Outside"),
  x = c(3.5, 6.5),
  y = c(3, 3)
)

# Reuse polygon edges
edges <- data.frame(
  x0 = polygon$x[-nrow(polygon)],
  y0 = polygon$y[-nrow(polygon)],
  x1 = polygon$x[-1],
  y1 = polygon$y[-1]
)

# Function to evaluate crossings for one point
evaluate_point <- function(px, py) {
  df <- edges %>%
    rowwise() %>%
    mutate(
      crosses = (y0 <= py & y1 > py) | (y1 <= py & y0 > py),
      x_intersect = ifelse(crosses,
                           x0 + (py - y0) * (x1 - x0) / (y1 - y0),
                           NA),
      crossed = !is.na(x_intersect) & x_intersect > px,
      direction = ifelse(crosses & y1 > y0, "up", ifelse(crosses & y0 > y1, "down", NA)),
      px = px,
      py = py
    ) %>%
    ungroup()

  winding_number <- sum(ifelse(df$crossed & df$direction == "up", 1,
                               ifelse(df$crossed & df$direction == "down", -1, 0)))

  list(
    crossings = df,
    winding_number = winding_number,
    inside = winding_number != 0
  )
}

# Apply to both points
results <- lapply(1:nrow(points), function(i) {
  pt <- points[i, ]
  res <- evaluate_point(pt$x, pt$y)
  crossings <- res$crossings
  crossings$name <- pt$name
  points$winding_number[i] <- res$winding_number
  points$inside[i] <- res$inside
  crossings
})

# Combine edge data with crossing info
crossings_all <- bind_rows(results)

# Plot
ggplot() +
  geom_polygon(data = polygon, aes(x = x, y = y), fill = "lightblue", color = "black", alpha = 0.4) +
  geom_segment(data = edges, aes(x = x0, y = y0, xend = x1, yend = y1), color = "black") +
  geom_segment(data = points,
               aes(x = x, y = y, xend = max(polygon$x) + 1, yend = y),
               linetype = "dashed", color = "darkred") +
  geom_point(data = points, aes(x = x, y = y, color = inside), size = 4) +
  scale_color_manual(values = c("TRUE" = "green", "FALSE" = "red")) +
  geom_text(data = points,
            aes(x = x, y = y + 0.4, label = paste0(name, "\nWinding number = ", winding_number)),
            color = "black", size = 3.5) +
  geom_point(data = filter(crossings_all, crossed),
             aes(x = x_intersect, y = py), color = "purple", size = 2.5) +
  geom_text(data = filter(crossings_all, crossed),
            aes(x = x_intersect, y = py + 0.2, label = direction),
            color = "purple", size = 3) +
  coord_fixed() +
  theme_minimal() +
  ggtitle("Sunday's Point-in-Polygon Algorithm: Inside vs Outside")

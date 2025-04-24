library(ggplot2)

# Define polygon
polygon <- matrix(c(0,0, 4,0, 3,3, 1,4), ncol=2, byrow=TRUE)
polygon_df <- as.data.frame(rbind(polygon, polygon[1,]))
colnames(polygon_df) <- c("x", "y")

# Create grid of test points
x_vals <- seq(0, 6, by = 0.2)
y_vals <- seq(0, 5, by = 0.2)
grid <- expand.grid(x = x_vals, y = y_vals)

# Check which points are inside
grid$inside <- apply(grid, 1, function(pt) point_in_polygon(c(pt[1], pt[2]), polygon))

# Plot grid with polygon
ggplot() +
  geom_tile(data = grid, aes(x = x, y = y, fill = inside), alpha = 0.7) +
  geom_polygon(data = polygon_df, aes(x = x, y = y), 
               fill = NA, color = "black", size = 1) +
  scale_fill_manual(values = c("TRUE" = "green", "FALSE" = "red")) +
  labs(title = "Ray Casting: Grid of Points",
       fill = "Inside Polygon?",
       x = "X", y = "Y") +
  coord_equal() +
  theme_minimal()

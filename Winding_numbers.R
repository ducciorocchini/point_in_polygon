# Required packages
library(ggplot2)
library(ggforce)
library(grid)

# Polygon vertices (clockwise, with a slight twist to suggest self-intersection)
polygon <- data.frame(
  x = c(0, 2, 2, 1, 0),
  y = c(0, 0.5, 2, 3, 2),
  label = LETTERS[1:5]
)
polygon <- rbind(polygon, polygon[1,])  # close the loop

# Point P (inside)
P <- data.frame(x = 1.1, y = 1.5)

# Create edges from point P to each vertex
edges <- data.frame(
  x = rep(P$x, nrow(polygon)),
  y = rep(P$y, nrow(polygon)),
  xend = polygon$x,
  yend = polygon$y
)

# Plot with grid and coordinates
ggplot() +
  # Polygon
  geom_polygon(data = polygon, aes(x = x, y = y), fill = "lightblue", color = "black", alpha = 0.4) +

  # Arrows from point P to polygon vertices
  geom_segment(data = edges, aes(x = x, y = y, xend = xend, yend = yend),
               arrow = arrow(length = unit(0.2, "cm")), color = "red") +

  # Point P
  geom_point(data = P, aes(x = x, y = y), color = "red", size = 3) +
  geom_text(data = P, aes(x = x, y = y), label = "P", vjust = -1.2, hjust = 1.2, size = 4) +

  # Annotate polygon vertex labels
  geom_text(data = polygon[-nrow(polygon),], aes(x = x, y = y, label = label),
            nudge_y = 0.15, color = "black", size = 3.5) +

  # Example angle annotation (between vectors to A and B)
  annotate("text", x = 1.4, y = 0.8, label = expression(theta[1]), size = 4) +
  annotate("text", x = 1.8, y = 1.3, label = expression(theta[2]), size = 4) +

  # Informative text
  annotate("text", x = 1.2, y = -0.3,
           label = "Winding number = sum(theta[i])", size = 4) +
  annotate("text", x = 3.5, y = 2.6,
           label = "If winding number ≠ 0,\nthen P is inside.\nIf = 0, then outside.",
           hjust = 0, size = 4) +

  # Add grid
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "gray", size = 0.5, linetype = "dotted"),
    panel.grid.minor = element_line(color = "gray", size = 0.25, linetype = "dotted"),
    legend.position = "right",  # Position legend on the right side
    legend.justification = "center", # Center the legend
    legend.box.spacing = unit(0.5, "cm"),  # Adjust space between legend and plot
    legend.margin = margin(0, 0, 0, 0) # Remove margins around the legend box
  ) +
  
  # Add coordinate axes
  scale_x_continuous(breaks = seq(0, 4, by = 1)) +
  scale_y_continuous(breaks = seq(0, 3.5, by = 0.5)) +

  # Title and equal aspect ratio
  coord_equal(xlim = c(-0.5, 4), ylim = c(-0.5, 3.5)) +
  ggtitle("Winding Number: Geometric Intuition with Grid and Coordinates") +
  theme(
    plot.margin = margin(10, 30, 10, 10)  # Adjust the plot margin to prevent clipping
  )

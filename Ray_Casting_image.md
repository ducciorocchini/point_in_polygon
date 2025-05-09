Needed: 

- A polygon
- Two points: one **inside**, one **outside**
- Dashed rays extending to the right from each point

---

### ✅ R Code to Replicate the TikZ Ray Casting Diagram

```r
library(ggplot2)

# Define polygon coordinates
polygon_df <- data.frame(
  x = c(0, 4, 3, 1, 0),  # closed polygon
  y = c(0, 0, 3, 4, 0)
)

# Define inside and outside points
points_df <- data.frame(
  x = c(2, 0.1),
  y = c(2, 3),
  label = c("Inside", "Outside"),
  color = c("blue", "green")
)

# Define intersections
inters <- data.frame(
  x = c(.75, 3, 3.3),
  y = c(3, 3, 2),
  label = c("", "", ""),
  color = c("black", "black", "black")
)

# Define dashed ray segments (extend rays to x = 6)
rays_df <- data.frame(
  x = c(2, 0.1),
  y = c(2, 3),
  xend = c(5, 5),
  yend = c(2, 3)
)

  # Plot
pdf("~/Desktop/output_ray.pdf")
  ggplot() +
    geom_polygon(data = polygon_df, aes(x = x, y = y),
                 fill = "lightblue", color = "black", alpha = 0.5) +
    geom_point(data = points_df, aes(x = x, y = y, color = label), size = 3) +
    geom_text(data = points_df, aes(x = x, y = y, label = label),
              hjust = -0.3, vjust = -1, size = 4) +
    geom_point(data = inters, aes(x = x, y = y, color = label), size = 3, shape=4) +
    geom_text(aes(x = 5, y = 3.2, label = "Even # of intersections"), inherit.aes = FALSE) +
    geom_text(aes(x = 5, y = 2.2, label = "Odd # of intersections"), inherit.aes = FALSE) +
    geom_segment(data = rays_df, aes(x = x, y = y, xend = xend, yend = yend),
                 linetype = "dashed", arrow = arrow(length = unit(0.2, "cm"))) +
    scale_color_manual(values = c("Inside" = "blue", "Outside" = "green")) +
    coord_equal(xlim = c(0, 6.5), ylim = c(-1, 5)) +
    labs(title = "Ray Casting Method: Point-in-Polygon",
         x = "X", y = "Y") +
    theme_minimal()
dev.off()
```

---

### 📍 What this replicates from TikZ:
- A polygon in light blue with black border
- A **green "Inside"** point and a **blue "Outside"** point
- **Dashed rays** going right from each point with arrows
- Matching labels to TikZ

---


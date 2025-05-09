Sure! Here's a full **Markdown document** that explains and demonstrates the **Ray Casting (Sunday’s) algorithm** for determining whether a point lies inside a polygon, using a complex non-convex polygon in R.

---

````markdown
# Point-in-Polygon Test in R using Sunday’s (Ray Casting) Algorithm

This document demonstrates how to use **Sunday’s algorithm** (also known as the **Ray Casting** method or **Even-Odd Rule**) to test if points lie **inside** or **outside** a complex polygon using R.

## 🔍 Problem

We are given:
- A **non-convex polygon** (e.g., a star-shaped figure).
- A set of **points** in the same coordinate plane.

We want to determine which of these points are **inside** the polygon.

## 📐 The Algorithm

The Ray Casting algorithm works by drawing an imaginary ray from the test point and counting how many times it intersects the edges of the polygon. 
- If the count is **odd**, the point is **inside**.
- If the count is **even**, the point is **outside**.

## 🧪 R Code

```r
library(ggplot2)
library(dplyr)

# Define a complex star-shaped polygon
polygon <- data.frame(
  x = c(0, 2, 3, 4, 6, 4.5, 5.5, 3, 0.5, 1.5),
  y = c(0, 3, 3, 0, 0, 2, 5, 3.5, 5, 2)
)
polygon <- rbind(polygon, polygon[1, ])  # Close the polygon

# Define test points
points <- data.frame(
  x = c(2, 3.5, 4.5, 3, 1, 5, 2.5),
  y = c(1, 2.5, 4, 3.9, 4.5, 1, 0.5)
)

# Sunday’s (Ray Casting) algorithm
point_in_polygon <- function(x, y, poly_x, poly_y) {
  n <- length(poly_x)
  inside <- FALSE
  j <- n
  for (i in 1:n) {
    xi <- poly_x[i]; yi <- poly_y[i]
    xj <- poly_x[j]; yj <- poly_y[j]
    intersect <- ((yi > y) != (yj > y)) &&
      (x < (xj - xi) * (y - yi) / (yj - yi + 1e-12) + xi)
    if (intersect) inside <- !inside
    j <- i
  }
  return(inside)
}

# Define dashed ray segments (extend rays to x = 6)
rays_df <- data.frame(
  x = c(2, 3.5, 4.5, 3, 1, 5, 2.5),
  y = c(1, 2.5, 4, 3.9, 4.5, 1, 0.5),
  xend = c(6, 6, 6, 6, 6, 6, 6),
  yend = c(1, 2.5, 4, 3.9, 4.5, 1, 0.5)
)

# Apply algorithm to each point
points$inside <- mapply(point_in_polygon,
                        x = points$x,
                        y = points$y,
                        MoreArgs = list(poly_x = polygon$x, poly_y = polygon$y))

# Visualization
pdf("~/Desktop/sundays.pdf")
ggplot() +
  geom_polygon(data = polygon, aes(x = x, y = y),
               fill = "lightblue", color = "black", alpha = 0.6) +
  geom_point(data = points, aes(x = x, y = y, color = inside), size = 4) +
  geom_segment(data = rays_df, aes(x = x, y = y, xend = xend, yend = yend),
                 linetype = "dashed", arrow = arrow(length = unit(0.2, "cm"))) +
  geom_text(aes(x = 1.3, y = 4.7, label = "(+1)"), inherit.aes = FALSE) +
  geom_text(aes(x = 4.6, y = 4.7, label = "(-1)"), inherit.aes = FALSE) +
  geom_text(aes(x = 5.3, y = 4.7, label = "(+1)"), inherit.aes = FALSE) +
  scale_color_manual(values = c("TRUE" = "blue", "FALSE" = "green")) +
  coord_equal() +
  labs(title = "Point-in-Polygon Test with Complex Polygon (Sunday's algorithm)",
       color = "Inside?")
dev.off()

# Visualization with arrows

# Calculate the midpoints of each edge
midpoints <- data.frame(
  x = (polygon$x + c(polygon$x[-1], polygon$x[1])) / 2,
  y = (polygon$y + c(polygon$y[-1], polygon$y[1])) / 2
)

pdf("~/Desktop/sundays.pdf")
ggplot() +
  geom_polygon(data = polygon, aes(x = x, y = y),
               fill = "lightblue", color = "black", alpha = 0.6) +
  geom_point(data = points, aes(x = x, y = y, color = inside), size = 4) +
  geom_segment(data = rays_df, aes(x = x, y = y, xend = xend, yend = yend),
                 linetype = "dashed", arrow = arrow(length = unit(0.2, "cm"))) +
  geom_segment(data = midpoints,
               aes(x = x, y = y,
                   xend = c(tail(polygon$x, -1), polygon$x[1]),
                   yend = c(tail(polygon$y, -1), polygon$y[1])),
               arrow = arrow(type = "closed", length = unit(0.2, "inches")),
               linewidth = 1, color = "red") +  # Arrows colored red
  geom_text(aes(x = 1.3, y = 4.7, label = "(+1)"), inherit.aes = FALSE) +
  geom_text(aes(x = 4.6, y = 4.7, label = "(-1)"), inherit.aes = FALSE) +
  geom_text(aes(x = 5.3, y = 4.7, label = "(+1)"), inherit.aes = FALSE) +
  scale_color_manual(values = c("TRUE" = "blue", "FALSE" = "green")) +
  coord_equal() +
  labs(title = "Point-in-Polygon Test with Complex Polygon (Sunday's algorithm)",
       color = "Inside?")
dev.off()

````

## 🖼️ Output

* **Blue points** are **inside** the polygon.
* **Green points** are **outside** the polygon.
* The polygon is filled in light blue.

## ✅ Conclusion

This demonstration uses a star-shaped polygon to visualize how Sunday’s algorithm effectively handles complex and non-convex shapes in 2D space. The method is robust and works well for general-purpose point-in-polygon tests.

```

---

Let me know if you'd like this saved as a `.Rmd` (R Markdown) or `.md` file, or if you want to add a section on performance or extensions (like shapefiles or spatial libraries).
```

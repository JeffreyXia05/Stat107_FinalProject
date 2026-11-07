HZ_LOWER <- 0.35
HZ_UPPER <- 1.75

classify_habitable_zone <- function(insolation) {
  cls <- ifelse(is.na(insolation), "Unknown",
         ifelse(insolation < HZ_LOWER, "Too cold",
         ifelse(insolation > HZ_UPPER, "Too hot", "Habitable zone")))
  return(factor(cls, levels = c("Too cold", "Habitable zone", "Too hot", "Unknown")))
}

summarize_habitable_zone <- function(df) {
  cls     <- classify_habitable_zone(df$pl_insol)
  counts  <- table(cls)
  n_known <- sum(cls != "Unknown")

  out <- data.frame(class = names(counts), n = as.integer(counts))
  out$pct_of_all   <- round(100 * out$n / nrow(df), 1)
  out$pct_of_known <- ifelse(out$class == "Unknown", NA,
                             round(100 * out$n / n_known, 1))
  return(out)
}

numeric_summary <- function(df, cols) {
  rows <- lapply(cols, function(col) {
    x <- df[[col]]
    data.frame(variable = col,
               n        = sum(!is.na(x)),
               missing  = sum(is.na(x)),
               min      = min(x, na.rm = TRUE),
               q1       = quantile(x, 0.25, na.rm = TRUE),
               median   = median(x, na.rm = TRUE),
               mean     = mean(x, na.rm = TRUE),
               q3       = quantile(x, 0.75, na.rm = TRUE),
               max      = max(x, na.rm = TRUE))
  })
  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  return(out)
}

plot_insolation_histogram <- function(df) {
  x <- log10(df$pl_insol[!is.na(df$pl_insol) & df$pl_insol > 0])
  hist(x, breaks = 60, col = "grey80", border = "white",
       xlab = "log10(Insolation)   (Earth = 0)",
       main = "Distribution of insolation for confirmed exoplanets")
  rect(log10(HZ_LOWER), 0, log10(HZ_UPPER), 1e6,
       col = adjustcolor("forestgreen", 0.3), border = NA)
  abline(v = 0, col = "blue", lty = 2, lwd = 2)
  legend("topright", bty = "n",
         legend = c("Habitable zone", "Earth"),
         fill = c(adjustcolor("forestgreen", 0.3), NA),
         border = c("black", NA),
         lty = c(NA, 2), col = c(NA, "blue"))
}

plot_radius_density <- function(df) {
  cls     <- classify_habitable_zone(df$pl_insol)
  classes <- c("Too cold", "Habitable zone", "Too hot")
  colors  <- c("steelblue", "forestgreen", "firebrick")
  dens    <- lapply(classes, function(k)
    density(log10(df$pl_rade[cls == k & !is.na(df$pl_rade)]), bw = 0.1))
  plot(NULL, xlim = range(sapply(dens, function(d) range(d$x))),
       ylim = c(0, max(sapply(dens, function(d) max(d$y)))),
       xlab = "log10(Planet radius)   (Earth = 0)", ylab = "Density",
       main = "Planet size by habitable-zone class")
  for (i in seq_along(dens)) lines(dens[[i]], col = colors[i], lwd = 2)
  abline(v = log10(c(0.5, 1.5)), lty = 2, col = "grey40")
  legend("topright", bty = "n", lwd = 2, col = colors, legend = classes)
}

plot_radius_boxplot <- function(df) {
  cls  <- classify_habitable_zone(df$pl_insol)
  keep <- cls != "Unknown" & !is.na(df$pl_rade)
  boxplot(df$pl_rade[keep] ~ droplevels(cls[keep]), log = "y",
          col = c("steelblue", "forestgreen", "firebrick"),
          xlab = "Habitable-zone class", ylab = "Planet radius (Earth = 1, log scale)",
          main = "Planet radius by habitable-zone class")
  abline(h = 1, col = "blue", lty = 2, lwd = 2)
  rect(0, 0.5, 4, 1.5, col = adjustcolor("grey50", 0.15), border = NA)
  legend("topleft", bty = "n",
         legend = c("Earth (radius = 1)", "Earth-size range (0.5 - 1.5)"),
         lty = c(2, NA), lwd = c(2, NA), col = c("blue", NA),
         fill = c(NA, adjustcolor("grey50", 0.15)), border = c(NA, "black"))
}

save_plot_png <- function(plot_fun, df, file_name) {
  dir.create("../figures", showWarnings = FALSE)
  png(file.path("../figures", file_name), width = 1400, height = 900, res = 150)
  plot_fun(df)
  dev.off()
}
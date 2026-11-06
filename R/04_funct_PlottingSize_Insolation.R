plot_size_energy <- function(df) ### plotting earth size (in  radii) to the amount of energy it receives 
{
  df[,"index"] <- size_energy_comparisons(df) 
  
  plot(
    x = df[,"pl_insol"], 
    y = df[,"pl_rade"], 
    log = "x",
    pch = 16,
    col = ifelse(
      df["index"] == TRUE, "red", "grey" ),
    xlab = "Insolation (Earth = 1)",
    ylab = "Planet Radius (Earth = 1)",
    main = "Exoplanets by Insolation and Planet Size",
    xlim = c(0.10, 25),
    ylim = c(0, 7),
  )
  rect(
    xleft = 0.35,
    ybottom = 0.5,
    xright = 1.70,
    ytop = 1.5,
    border = "purple",
    lwd = 2,
  )
  abline(v = c(0.35, 1.70), lty = 2, col = "blue")
  abline(h = c(0.5, 1.5), lty = 2, col = "darkgreen")
  
  legend(
    "topright",
    legend = c("Habitable-zone boundaries",
               "Earth-size boundaries"),
    col = c("blue", "darkgreen"),
    pch = c(NA, NA),
    lty = c(2, 2),
    bty = "n"
  )
}

plot_density_energy <- function(df) ### makes a plot that is density to energy received
{
  remove_na(df)
  df <- find_density(df) ### add density
  df <- find_gravity(df) ### add gravity
  
  plot(
    x = df[,'pl_insol'],
    y = df[,"pl_density"],
    log = "x",
    pch = 16,
    xlim = c(.25, 25),
    ylim = c(0, 15),
    col = ifelse(
      df["pl_insol"] >= 0.35 &
        df["pl_insol"] <= 1.70,
      "red",
      "gray"
    ),
    xlab = "Insolation (Earth = 1)",
    ylab = "Planet Density (g/cm³)",
    main = "Planet Density vs. Insolation"
  )
  abline(v = c(0.35, 1.70), col = "blue", lty = 2)
  abline(h = 5.514, col = "darkgreen", lty = 2)

}

size_energy_comparisons <- function(df) ### checks if the planet is in the habitable zone and earth like
{
  earth_like_planets_index <- relative_size_to_earth(df) ### gets index for earth like size
  habitable_planet_index <- check_habitable(df) ### gets index for all habitable
  
  n_obs <- nrow(df)
  index <- rep(FALSE, n_obs)
  
  for ( i in 1:nrow(df) )
  {
    if (earth_like_planets_index[i] == TRUE & habitable_planet_index[i] == TRUE) ###
      index[i] <- TRUE
  }
  
  return(index) 
}
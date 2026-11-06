relative_size_to_earth <- function(df) ###singles out only planets that are earth like in size
{
  habitable_upper <- 1.5 ### upper limit
  habitable_lower <- 0.5 ### lower limit
  n_obs <- nrow(df)
  habitableSizeIndex <- rep(FALSE, n_obs) ### index used to mark the rows
  
  for (i in 1:n_obs)
  {
    size <- df[i, "pl_rade"]
    
    if (!is.na(size) && size <= habitable_upper && size >= habitable_lower)
    {
      habitableSizeIndex[i] <- TRUE
    }
  }
  return(habitableSizeIndex)
}

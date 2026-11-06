check_habitable<- function(df)
{
  
  habitable_upper <- 1.75
  habitable_lower <- 0.35
  
  
  n_obs <- nrow(df)
  habitableZoneIndex <- rep(FALSE, n_obs)### index used to mark the rows
  for (i in 1:n_obs)
  {
    insol <- df[i, "pl_insol"]
    if (!is.na(insol)  && insol <= habitable_upper && insol >= habitable_lower)
    {
      habitableZoneIndex[i] <- TRUE 
    }
  }
  return(habitableZoneIndex)
}
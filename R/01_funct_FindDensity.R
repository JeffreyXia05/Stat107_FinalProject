find_density <- function(df) ###add density to the data frame passed
{
  n_obs <- nrow(df)
  index <- rep(0, n_obs)
  
  for ( i in 1:nrow(df) )
  {
    obs <- df[i,]
    if ( is.na(obs["pl_bmasse"]) == FALSE && obs["pl_bmasse"] != 0 && obs["pl_rade"] != 0 && is.na(obs["pl_rade"]) == FALSE)
    {
      df[i, 'pl_density'] <- 5.514 * (obs["pl_bmasse"] / obs["pl_rade"]^3)
    }
  }
  return(df)
}

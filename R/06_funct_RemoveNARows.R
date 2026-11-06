remove_na <- function(df) {
  n_obs <- nrow(df)
  missing <- rep(FALSE, n_obs)
  for (obs_ind in 1:n_obs) {
    obs <- df[obs_ind, ]
    n_missing <- sum(is.na(obs))
    if(n_missing > 0) {
      missing[obs_ind] <- TRUE
    }
  }
  df <- df[!missing, ]
  return(df)
}

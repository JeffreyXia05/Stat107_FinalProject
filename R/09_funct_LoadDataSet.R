### loads full data set and takes the important columns from them
load_dataset<- function()
{
exoplanets <- read.csv("PSCompPars_2026.11.03_10.19.30.csv", skip = 88) ### must skip 858 lines ti get to data


### Strip data leaving the Columns that will help with data. Compared to Earth, (etc, radii = 1.5 is Earth radius x 1.5)
usablePlanets <- exoplanets[, 
                            c(
                              "pl_name", # "Planet Name"
                              "hostname", # "Host Name"
                              "pl_insol", # "Insolation/Energy Recieved" 
                              "pl_orbsmax", # "Orbital Distance", 
                              "pl_rade" , #  "Radius in Earth radii"	
                              "pl_bmasse", # "Mass of the planet"
                              "pl_eqt", # "Equilibrium Temperature "
                              "st_teff" # "Host Star Temp"
                            )
]
return(usablePlanets)
}

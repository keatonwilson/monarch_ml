#Making synthetic data set
#Keaton Wilson
#keatonwilson@me.com
#2019-06-27

#packages
library(tidyverse)
library(synthpop)


#reading in real data
monarch_data = read_csv("./data/monarch_data_real.csv")

#Adding one more feature - the number of hectares the previous year
monarch_data = monarch_data %>%
  mutate(hectare_prev_year = lag(hectares)) 

#Also going to pull out some variables based on preliminary analysis
#We want to keep 8, 14, 19, 5, 37, 2, 10, 5, 12, 15


monarch_small = monarch_data %>%
  dplyr::select(hectares, day_first_sighting, obs_37_norm, active_months_obs_norm,
                n_obs_total,
                contains("_8"), contains("_14"), contains("_19"), 
                contains("_5"), contains("_37"), contains("_2"), 
                contains("_10"), contains("_12"), contains("_15"))

write_csv(monarch_small, "./data/monarch_data_real.csv")

smooth_list = as.list(rep("density", 45))
names(smooth_list) = names(monarch_data)

syn_monarch = synthpop::syn(monarch_small, k = 25000, method = "norm")

# compare(syn_monarch, monarch_data)

#Writing synthesized data
write_csv(syn_monarch$syn, "./data/monarch_synth.csv")

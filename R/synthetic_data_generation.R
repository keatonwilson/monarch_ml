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

write_csv(monarch_data, "./data/monarch_data_real.csv")

smooth_list = as.list(rep("density", 45))
names(smooth_list) = names(monarch_data)

syn_monarch = synthpop::syn(monarch_data, k = 25000, smoothing = smooth_list)

# compare(syn_monarch, monarch_data)

#Writing synthesized data
write_csv(syn_monarch$syn, "./data/monarch_synth.csv")
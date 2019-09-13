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
#

monarch_small = monarch_data %>%
  dplyr::select(hectares, day_first_sighting, obs_37_norm, active_months_obs_norm,
                n_obs_total,
                contains("_8"), contains("_14"), contains("_19"), 
                contains("_5"), contains("_37"), contains("_2"), 
                contains("_10"), contains("_12"), contains("_15")) %>%
  mutate(hectares = log(hectares))

write_csv(monarch_small, "./data/monarch_data_small.csv")

library(psych)

pairs.panels(monarch_small,
             hist.col = "#00AFBB", 
             density = TRUE,
             ellipses = TRUE)

#methods
methods = c("lognorm", "lognorm", "norm", "norm", "lognorm", rep("norm", 16))

#Smoothing parameters
smooth_list = as.list(rep("", 21))
names(smooth_list) = names(monarch_small)


syn_monarch = synthpop::syn(monarch_small, k = 50000, method = "norm", 
                            #smoothing = smooth_list, 
                            visit.sequence = ncol(monarch_small):1)

# compare(syn_monarch, monarch_data)

#Writing synthesized data
write_csv(syn_monarch$syn, "./data/monarch_synth.csv")


#Ok, so let's compare
ggplot(data = syn_monarch$syn %>%
         filter(hectares < 1000), aes(x = hectares)) +
  geom_density(fill = "blue", alpha = 0.7) +
  geom_density(data = monarch_small, aes(x = hectares), 
               fill = "yellow", alpha = 0.7) +
  theme_classic()

ggplot(data = monarch_small, aes(x = log(hectares))) +
  geom_density(fill = "blue", alpha = 0.6)

#Problematic. Can we generate synthetic data better way by fitting distributions for each variable and then drawing?
library(fitdistrplus)

par(mfrow = c(1,1))
descdist(monarch_data$hectares, discrete=FALSE, boot = 500)

fit_ln = fitdist(monarch_data$hectares, "lnorm")
fit_g = fitdist(monarch_data$hectares, "gamma")
fit_w = fitdist(monarch_data$hectares, "weibull")

par(mfrow=c(2,2))
plot.legend <- c("Weibull", "lognormal", "gamma")
denscomp(list(fit_w, fit_g, fit_ln), legendtext = plot.legend)
cdfcomp (list(fit_w, fit_g, fit_ln), legendtext = plot.legend)
qqcomp  (list(fit_w, fit_g, fit_ln), legendtext = plot.legend)
ppcomp  (list(fit_w, fit_g, fit_ln), legendtext = plot.legend)



lnorm = data.frame(to_plot = rlnorm(n = 100, meanlog = fit_ln$estimate[1], sdlog = fit_ln$estimate[2]))
weibull = data.frame(to_plot = rweibull(n = 100, shape = fit_w$estimate[1], scale = fit_w$estimate[2]))
ggplot(data = monarch_small, aes(x = hectares)) +
  geom_density(fill = "blue", alpha = 0.7) +
  geom_density(data = lnorm, aes(x = to_plot), fill = "yellow", alpha = 0.7) +
  geom_density(data = weibull, aes(x = to_plot), fill = "pink", alpha = 0.7)
  

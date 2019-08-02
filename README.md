# monarch_ml
Machine learning algorithm for predicting Mexico monarch population estimates  

This is the complete project repository for work building a machine learning algorithm(s) that predicts overwintering numbers for Monarchs (*Danaus plexxipus*) in Mexico.  
General steps include:  
1. Pulling and cleaning citizen science and museum records from online repositories  
2. Generating feature sets that include environmental and observation data for 'real' data  
3. Using the `synthpop` package to create a large data set to train on from the relatively small 'real' data set  
4. Train and tune ML algorithms  
5. Test on 'real' data  

For replicatibility, the attached dockerfile will build a container and clone the github repo into the container for analysis. The image we used for analysis can also be found on [dockerhub](https://cloud.docker.com/u/keatonwilson/repository/docker/keatonwilson/monarch_ml). 



Package: BayesBigDataLM

Title: Methods for generating Markov chain Monte Carlo posterior
        samples of Bayesian linear regression model parameters for big
        data sets that are too large to fit into R memory.

Version: 1.0

Authors: Evgeny Savelev, Alexey Miroshnikov, Erin Conlon

Description: This package contains functions for generating Markov chain Monte Carlo (MCMC) posterior samples of Bayesian linear regression model parameters for big data sets that are too large to fit into R memory. The Bayesian linear regression models require only summary statistics of data as input. One function reads in big data sets in chunks and calculates summary statistics necessary for Bayesian linear regression. The summary statistics are used as input to the second function that carries out the MCMC posterior sampling. The output MCMC objects can be analyzed using the R CODA package.

Depends: mvnfast, ff

License: GPL (>= 2)


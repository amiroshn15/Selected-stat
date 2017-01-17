\name{bayes.regress}
\alias{bayes.regress}

\title{Markov chain Monte Carlo posterior sampling of Bayesian linear regression model parameters using only summary statistics, for big data sets too large to fit into R memory}
\description{This function generates MCMC posterior samples of the Bayesian linear regression model parameters, using only summary statistics \eqn{X'X}, \eqn{X'Y} and \eqn{Y'Y} calculated by the function \code{read.regress.data.ff()} (in this package). The \code{read.regress.data.ff()} function can analyze big data sets too large to fit into memory in R. Here, the user specifies the choices of prior distributions, hyperprior distributions and fixed parameter values where required; the user also specifies starting values for unknown model parameters.}
\usage{
bayes.regress(data.values=NULL, 
              beta.prior=list("flat"), 
              sigmasq.prior=list("inverse.gamma", 1.0, 1.0, 1.0),
              Tsamp.out=1000, zero.intercept=FALSE)
}

\arguments{
  \item{data.values}{a list with four (optionally five) components, which are created by the function \code{read.regress.data.ff()} (in this package): 
  \itemize{
    \item \code{xtx}: a square matrix that stores the product \eqn{X'X}, where \eqn{X} is the data from predictor columns with a leading column of 1's for the y-intercept term. 
    \item \code{xty}: a column vector that stores the product \eqn{X'Y}, where \eqn{X} is the same as above and \eqn{Y} is a column of response data values.
    \item \code{yty}: a scalar value that stores the product \eqn{Y'Y}, where \eqn{Y} is the same as above.
    \item \code{numsamp.data}: an integer equal to the number of data values of the predictor variables \eqn{X}.
    \item \code{xtx.inv} (optional): the inverse of the matrix \code{xtx} that is used for the \dQuote{Uniform} prior distribution for \eqn{\beta} to speed up computations if the function is used repeatedly with the same \code{xtx}. If omitted, this inverse will be computed automatically. This component is ignored for other prior distributions.
    }}
 
  \item{beta.prior}{a list that specifies the characteristics of the prior distribution for \eqn{\beta}, the vector of coefficients of the Bayesian linear regression model. There are three possible types: 
\itemize{\item \code{flat}: Uniform distribution.
\item\code{mvnorm.known}: Multivariate Normal with known mean vector \eqn{\mu} and known covariance matrix \eqn{C}.
\item\code{mvnorm.unknown}: Multivariate Normal with unknown mean vector \eqn{\mu} and unknown covariance matrix \eqn{C}. This prior also includes the hyperpriors for \eqn{\mu} and \eqn{C}, where \eqn{\mu ~ } Multivariate Normal(\eqn{\eta, D)}, and \eqn{C^(-1) ~ } Wishart(d.f. = \eqn{\lambda}, scale matrix = \eqn{V}); \eqn{\eta, D, \lambda, V} assumed known.}
  In each of these three prior types, the list has a different structure, as follows:
  \itemize{
  \item {\code{beta.prior=list(type = "flat")}: a Uniform prior distribution for \eqn{\beta}; no other specification is necessary. This prior distribution is used by default.}
  \item {\code{beta.prior=list(type = "mvnorm.known", mean.mu = ..., cov.C = ..., prec.Cinv = ... )} 
    \itemize{
    \item \code{mean.mu}: the fixed known prior mean vector \eqn{\mu} for the Multivariate Normal prior of \eqn{\beta}. The default is a vector of 0's with length equal to the length of \eqn{\beta}.
    \item \code{cov.C}: the fixed known prior covariance matrix \eqn{C} for the Multivariate Normal prior of \eqn{\beta}. The default is an identity matrix with dimension equal to the length of \eqn{\beta}.
    \item \code{prec.Cinv}: the inverse of the covariance matrix \eqn{C} above. If \code{cov.C} is not specified, \code{prec.Cinv} is assigned the identity matrix by default, with dimension equal to the length of \eqn{\beta}.
    }
    It is advised to supply \code{prec.Cinv} matrix and omit \code{cov.C} for speeding up the algorithm. In case both are supplied, the algorithm gives preference to \code{prec.Cinv}.
  }
  \item {\code{beta.prior=list(type = "mvnorm.unknown", mu.hyper.mean.eta = ..., mu.hyper.prec.Dinv = ..., Cinv.hyper.df.lambda = ..., Cinv.hyper.invscale.Vinv = ..., mu.init = ..., Cinv.init = ...)}
    \itemize{
    \item \code{mu.hyper.mean.eta}: the fixed known hyperparameter mean vector \eqn{\eta} for the Multivariate Normal hyperprior mean \eqn{\mu}. The default is a vector of 0's with length equal to the length of \eqn{\beta}.
    \item \code{mu.hyper.prec.Dinv}: the fixed known hyperparameter precision matrix \eqn{D}^(-1) for the Multivariate Normal hyperprior mean \eqn{\mu}. The default is an identity matrix with dimension equal to the length of \eqn{\beta}.
    \item \code{Cinv.hyper.df.lambda}: the fixed known degrees of freedom \eqn{\lambda} for the Wishart hyperprior for \eqn{C}^(-1). The default value is the length of \eqn{\beta} .
    \item \code{Cinv.hyper.invscale.Vinv}: 
the fixed known hyperparameter inverse scale matrix \eqn{V}^(-1) for the Wishart hyperprior for \eqn{C}^(-1). The default is an identity matrix with dimension equal to the length of \eqn{\beta}.
    \item \code{mu.init}: initial value for \eqn{\mu} for the MCMC chain. 
The default is a vector of 1's with length equal to the length of \eqn{\beta}. 
    \item \code{Cinv.init}: initial value for \eqn{C}^(-1) for the MCMC chain. The default is an identity matrix with dimension equal to the length of \eqn{\beta}.
    }
  }
  
  }For all three of the above \code{beta.prior} distributions, only the \code{type} is mandatory. The remaining parameters are assigned default values if omitted.}
  
  \item{sigmasq.prior}{a list that specifies the characteristics of the prior distribution for \eqn{\sigma^2} (the variance of \eqn{\epsilon_i}, i.e. the variance of the error terms in the Bayesian linear regression model). There are two types:
  \itemize{
    \item \code{inverse.gamma}: Inverse Gamma distribution with known shape and scale parameters \eqn{a} and \eqn{b}, respectively.
    \item \code{sigmasq.inverse}: inverse sigma-squared distribution.
  }
  Similar to \code{beta.prior} above, the structure of the list depends on the type of prior distribution chosen. The list must be supplied in either of the following structures:
  \itemize{

    \item \code{sigmasq.prior=list(type = "inverse.gamma", inverse.gamma.a = ..., inverse.gamma.b = ..., sigmasq.init = ...)}.
    \itemize{
    \item \code{inverse.gamma.a}: the shape parameter \eqn{a} for the Inverse Gamma prior distribution, assumed known; default = 1.
    \item \code{inverse.gamma.b}: the scale parameter \eqn{b} for the Inverse Gamma prior distribution, assumed known; default = 1.
    \item \code{sigmasq.init}: the initial value for the unknown \eqn{\sigma^2} parameter for the MCMC chain; default = 1.
}
    \item \code{sigmasq.prior=list(type="sigmasq.inverse", sigmasq.init = ...)}.
    \itemize{
    \item \code{sigmasq.init}: the initial value for the unknown \eqn{\sigma^2} parameter for the MCMC chain; default = 1.}
}}


 \item{Tsamp.out}{an optional scalar that specifies the number of MCMC samples to generate; default = 1,000.}
  \item{zero.intercept}{an optional logical parameter with default = \code{FALSE}. If \code{zero.intercept = TRUE} is specified, the linear regression model sets the y-intercept term \eqn{\beta_0} to zero; the corresponding y-intercept terms of the matrices \code{data.values$xtx} and \code{data.values$xty} are ignored, and the \eqn{\beta} vector is revised throughout the models and output automatically by the function.}
}

\details{This function uses the following Bayesian linear regression model: 
\deqn{y_i=x_i' \beta + \epsilon_i,}
where \eqn{i = 1,...,numsamp.data}; \eqn{\epsilon_i ~ N(0,\sigma^2)}; \eqn{k} is the number of predictor variables.
The function uses user-supplied prior distributions for \eqn{\beta} and \eqn{\sigma^2}.

The Gibbs sampler is used to sample from all full conditional posterior distributions, which only depend on the summary statistics \eqn{X'T}, \eqn{X'Y} and \eqn{Y'Y} (and \eqn{Y'X = (X'Y)'}); these summary statistics are calculated by the function \code{read.regress.data.ff()} (in this package), or can be provided by the user. Starting values are not needed for the vector \eqn{\beta}, since this vector is updated first, conditioned on all other unknown model parameters.


  \itemize{
\item{The full conditional posterior distributions are the following
for each prior specification of \eqn{\beta}; these depend on the data only through summary statistics \eqn{X'X} and \eqn{X'Y}:}
\itemize{
  \item{\code{beta.prior=list(type = "flat")}: 
\deqn{\beta | \sigma^2, X, Y ~ Normal_{k+1} (mean=((X'X)^(-1)(X'Y), covariance=(\sigma^2(X'X)^(-1))))}}
  \item{\code{beta.prior=list(type = "mvnorm.known")}:
\deqn{\beta | \sigma^2, X, Y ~ Normal_{k+1} (mean=(C^(-1)+\sigma^(-2)(X'X))^(-1)(C^(-1)\mu + \sigma^(-2)X'Y),covariance=(C^(-1)+\sigma^(-2)(X'X)^(-1)))}}
  \item{\code{beta.prior=list(type = "mvnorm.unknown")}:
\deqn{\beta | \sigma^2, \mu, C^(-1), X, Y ~ Normal_{k+1} (mean=(C^(-1)+\sigma^(-2)(X'X))^(-1)(C^(-1)\mu + \sigma^(-2)X'Y),covariance=(C^(-1)+\sigma^(-2)(X'X)^(-1)))}
\deqn{\mu | \beta, \sigma^2, C^(-1), X, Y ~ Normal_{k+1} (mean=(D^(-1)+C^(-1))^(-1)(C^(-1)\beta+D^(-1)\eta), covariance=(D^(-1)+C^(-1))^(-1))}
\deqn{C^(-1) | \beta, \sigma^2, \mu, X, Y ~ Wishart_{k+1} (d.f. = (1+\lambda), scale matrix = (V^(-1)+ (\beta - \mu)(\beta - \mu)')^(-1))}
}
}
}

  \itemize{
\item{The full conditional posterior distributions are the following
for each prior specification of \eqn{\sigma^2}; these depend on the data only through summary statistics \eqn{X'X}, \eqn{X'Y} and \eqn{Y'Y}:}
\itemize{
  \item{\code{sigmasq.prior=list(type = "inverse.gamma")}:
\deqn{\sigma^2 | \beta, X, Y ~ Inverse Gamma (numsamp.data/2+a, (0.5(Y'Y-\beta'X'Y-Y'X\beta+\beta'X'X\beta)+1/b)^(-1))}}
  \item{\code{sigmasq.prior=list(type = "sigmasq.inverse")}: 
\deqn{\sigma^2 | \beta, X, Y ~ Inverse Gamma (numsamp.data/2, (0.5(Y'Y-\beta'X'Y-Y'X\beta+\beta'X'X\beta))^(-1))}}
}
}
}



\value{The returned value is a list containing the MCMC samples of the unknown Bayesian linear regression model parameters; the number of MCMC samples is equal to the argument \code{Tsamp.out}. Further analysis, including plotting and creating summary statistics, can be carried out using the \code{coda} R package (see References).
}

\references{
Carlin, B.P. and Louis, T.A. (2009) \emph{Bayesian Methods for Data Analysis, 3rd ed.}, Boca Raton, FL: Chapman and Hall/CRC Press.

Gelman, A., Carlin, J.B., Stern, H.S., Dunson, D.B., Vehtari, A. and Rubin, D.B. (2013) \emph{Bayesian Data Analysis, 3rd ed.}, Boca Raton, FL: Chapman and Hall/CRC Press.

Plummer, M., Best, N., Cowles, K. and Vines, K. (2006) CODA: Convergence diagnosis and output analysis for MCMC. \emph{R News}, \bold{6}(1), 7-11. 

Adler, D., Glaser, C., Nenadic, O., Oehlschlagel, J. and Zucchini, W. (2013) ff: memory-efficient storage of large data on disk and fast access functions. R package: \url{http://CRAN.R-project.org/package=ff}. 

Fasiolo, M. (2014) An introduction to mvnfast. R package: \url{http://CRAN.R-project.org/package=mvnfast}. 

}

\examples{
##################################################
## Simulate data 
##################################################
set.seed(284698)

num.samp  <- 100 # number of data values to simulate
Tsamp.out <- 100 # number of MCMC samples to produce
beta <- c( -0.33, 0.78, -0.29, 0.47, -1.25)

beta_0 <- beta[1]

num.pred <- length(beta)-1

rho       <- 0.0  # correlation between predictors
mean.vec  <- rep(0,num.pred)
sigma.mat <- matrix(rho,num.pred,num.pred) + diag(1-rho,num.pred)
sigmasq.sim <- 0.05

x       <- rmvn(num.samp, mu=mean.vec, sigma=sigma.mat )       
epsilon <- rnorm(num.samp, mean=0, sd=sqrt(sigmasq.sim))
y       <- beta_0 + as.numeric( x \%*\% as.matrix(beta[2:length(beta)]) +  epsilon )

## Prepare the summary statistics

# Compute summary statistics (without y-intercept beta_0)

xtx <- t(x)\%*\%x 
xty <- t(x)\%*\%y 
yty <- t(y)\%*\%y 

# then compute sums

sum.x <- colSums(x)
sum.y <- sum(y)

# next, form the "data" structure corresponding to a model with nonzero beta_0 coefficient 

xtx.ext <- matrix(0,num.pred+1,num.pred+1)    
xtx.ext[2:(num.pred+1),2:(num.pred+1)] <- xtx
xtx.ext[1,1] <- num.samp
xtx.ext[1,2:(num.pred+1)] <- sum.x
xtx.ext[2:(num.pred+1),1] <- t(sum.x)

xty.ext <- rep(0,(num.pred+1))
xty.ext[1]     <- sum.y
xty.ext[2:(num.pred+1)] <- xty 

data.values=list(xtx=xtx.ext,xty=xty.ext, yty=yty, numsamp.data = num.samp, xtx.inv = chol2inv(chol(xtx)))

##########################################################
## Bayesian linear regression analysis
##########################################################

## beta: Uniform prior; sigma-squared: Inverse Gamma prior 

beta.prior    <- list(type="flat")
sigmasq.prior <- list("inverse.gamma", inverse.gamma.a = 1.0, inverse.gamma.b = 1.0, sigmasq.init = 1.0 )

set.seed(284698)

run <- bayes.regress(data.values, beta.prior, sigmasq.prior = sigmasq.prior, Tsamp.out = Tsamp.out)

print(c(colMeans(run$beta), mean(run$sigmasq)))

# check that output is close to simulated values (although Tsamp.out is small):
# c(-0.33,  0.78, -0.29,  0.47, -1.25,  0.05):


## Run all 6 combinations of priors for beta.prior and sigmasq.prior:

beta.priors <- list(
  list(type = "flat"),
  
  list( type = "mvnorm.known", 
        mean.mu = rep(0.0,    (num.pred+1)), 
        prec.Cinv = diag(1.0, (num.pred+1))),
        
  list( type="mvnorm.unknown",
        mu.hyper.mean.eta         = rep(0.0,(num.pred+1)),  
        mu.hyper.prec.Dinv        = diag(1.0, (num.pred+1)),  
        Cinv.hyper.df.lambda      = (num.pred+1), 
        Cinv.hyper.invscale.Vinv  = diag(1.0, (num.pred+1)),  
        mu.init                   = rep(1.0, (num.pred+1)), 
        Cinv.init                 = diag(1.0,(num.pred+1)))   
)
sigmasq.priors <- list(
  list("inverse.gamma", inverse.gamma.a = 1.0, inverse.gamma.b = 1.0, sigmasq.init = 0.1 ),
  list( type="sigmasq.inverse", sigmasq.init=0.1)
)

for (beta.prior in beta.priors)
{
  for(sigmasq.prior in sigmasq.priors)
  {
    set.seed(284698)
    run <- bayes.regress(data.values, beta.prior, sigmasq.prior = sigmasq.prior, Tsamp.out = Tsamp.out)
    print(c(colMeans(run$beta), mean(run$sigmasq)))
  }
}

# check that output is close to simulated values (although Tsamp.out is small);
# the output includes both beta and sigmasq:
# c(-0.33,  0.78, -0.29,  0.47, -1.25,  0.05):


############################################################
## Bayesian linear regression analysis with zero y-intercept 
############################################################

# The first coefficient in regression, beta_0, can be forced to be zero
# The option zero.intercept is used to change the model in bayes.regress()
# The matrices and vectors in data.values must be in their extended form
# The matrices and vectors in beta.prior will be trimmed to the right side automatically

## Simulate updated data with y-intercept equal zero
set.seed(284698)
num.samp  <- 100 # number of data values to simulate
Tsamp.out <- 100 # number of MCMC samples to produce

beta <- c( 0, 0.78, -0.29, 0.47, -1.25)
# !!!!!!!!!!!!!!!!
beta_0 <- 0 # !!!!
# !!!!!!!!!!!!!!!!
num.pred <- length(beta)-1
rho       <- 0.0  # correlation between predictors
mean.vec  <- rep(0,num.pred)
sigma.mat <- matrix(rho,num.pred,num.pred) + diag(1-rho,num.pred)
sigmasq.sim <- 0.05
x       <- rmvn(num.samp, mu=mean.vec, sigma=sigma.mat )       
epsilon <- rnorm(num.samp, mean=0, sd=sqrt(sigmasq.sim))
y       <- beta_0 + as.numeric( x \%*\% as.matrix(beta[2:length(beta)]) +  epsilon )

## Prepare the summary statistics

# Compute summary statistics (without y-intercept beta_0)

xtx <- t(x)\%*\%x 
xty <- t(x)\%*\%y 
yty <- t(y)\%*\%y 

# then compute sums

sum.x <- colSums(x)
sum.y <- sum(y)

# next, form the simulated data structure corresponding to a model with nonzero beta_0 coefficient 
xtx.ext <- matrix(0,num.pred+1,num.pred+1)    
xtx.ext[2:(num.pred+1),2:(num.pred+1)] <- xtx
xtx.ext[1,1] <- num.samp
xtx.ext[1,2:(num.pred+1)] <- sum.x
xtx.ext[2:(num.pred+1),1] <- t(sum.x)

xty.ext <- rep(0,(num.pred+1))
xty.ext[1]     <- sum.y
xty.ext[2:(num.pred+1)] <- xty 
data.values=list(xtx=xtx.ext,xty=xty.ext, yty=yty, numsamp.data = num.samp)


## Run all 6 combinations of priors for beta.prior and sigmasq.prior:

for (beta.prior in beta.priors)
{
  for(sigmasq.prior in sigmasq.priors)
  {
    set.seed(284698)
    run <- bayes.regress(data.values, beta.prior, sigmasq.prior = sigmasq.prior, Tsamp.out = Tsamp.out, zero.intercept = TRUE)
    print(c(colMeans(run$beta), mean(run$sigmasq)))
  }
}

# check that output is close to simulated values (although Tsamp.out is small);
# the output includes both beta and sigmasq:
# c( 0.78, -0.29,  0.47, -1.25,  0.05)


#######################################################################
## Reading the data from a file and Bayesian linear regression analysis
#######################################################################

## non-zero y-intercept data
# read the files and compute summary statistics

filename <- system.file('data/regressiondata.nz.all.csv.gz', package='BayesBigDataLM')
data.values <- read.regress.data.ff(filename)
num.pred <- length(data.values$xty)-1

# prepare the priors

beta.priors <- list(
  list(type = "flat"),
  
  list( type = "mvnorm.known", 
        mean.mu = rep(0.0,    (num.pred+1)), 
        prec.Cinv = diag(1.0, (num.pred+1))),
        
  list( type="mvnorm.unknown",
        mu.hyper.mean.eta         = rep(0.0,  (num.pred+1)),  
        mu.hyper.prec.Dinv    	  = diag(1.0, (num.pred+1)),  
        Cinv.hyper.df.lambda      = (num.pred+1), 
        Cinv.hyper.invscale.Vinv  = diag(1.0, (num.pred+1)),  
        mu.init                   = rep(1.0, (num.pred+1)),      
        Cinv.init                 = diag(1.0,(num.pred+1)))   
)
sigmasq.priors <- list(
  list("inverse.gamma", inverse.gamma.a = 1.0, inverse.gamma.b = 1.0, sigmasq.init = 0.5 ),
  list( type="sigmasq.inverse", sigmasq.init=0.5)
)

Tsamp.out <- 100

for (beta.prior in beta.priors)
{
  for(sigmasq.prior in sigmasq.priors)
  {
    set.seed(284698)
    run <- bayes.regress(data.values, beta.prior, sigmasq.prior = sigmasq.prior, Tsamp.out = Tsamp.out)
    print(c(colMeans(run$beta), mean(run$sigmasq)))
  }
}


# check that output is close to simulated values (although Tsamp.out is small);
# the output includes both beta and sigmasq:
# c( -0.75, 0.9, -0.92, 0.5, -1.65, 0.25)


}
\keyword{combine}
\keyword{consensus}
\keyword{subposterior}
\keyword{posterior}
\keyword{parallel}
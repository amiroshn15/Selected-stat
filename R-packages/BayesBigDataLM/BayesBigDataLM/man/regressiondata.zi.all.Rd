\name{regressiondata.zi.all}
\alias{regressiondata.zi.all}
\docType{data}
\title{
Samples of linear regression data.
}
\description{
20 000 samples of random data. First column is computed according to the formula \deqn{y=-0.75*x_1 + 0.9*x_2 -0.92*x_3 + 0.5*x_4 -1.65*x_5 +\epsilon}
Here \eqn{x_i} are distributed normally with zero mean and variance 1.0 and \eqn{\epsilon} is normally distributed noise with zero mean and variance 0.25. Remaining five columns contain predictor variables \eqn{x_i}
}
\usage{data("regressiondata.zi.all")}
\format{
  A data frame with 20 000 observations on six variables \eqn{y,x_1, x_2, x_3, x_4, x_5}
}
\keyword{datasets}

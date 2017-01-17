\name{regressiondata.zi.pt1}
\alias{regressiondata.zi.pt1}
\docType{data}
\title{
Samples of linear regression data.
}
\description{
10 000 samples of random data. First column is computed according to the formula \deqn{y=-0.75*x_1 + 0.9*x_2 -0.92*x_3 + 0.5*x_4 -1.65*x_5 +\epsilon}
Here \eqn{x_i} are distributed normally with zero mean and variance 1.0 and \eqn{\epsilon} is normally distributed noise with zero mean and variance 0.25. Remaining  four columns contain predictor variables \eqn{x_i}.

This file is a copy of the first 10 000 entries from the file \code{regressiondata.zi.all}
}
\usage{data("regressiondata.nz.pt1")}
\format{
  A data frame with 10 000 observations on six variables \eqn{y,x_1, x_2, x_3, x_4, x5}
}
\keyword{datasets}

\name{regressiondata.nz.pt1}
\alias{regressiondata.nz.pt1}
\docType{data}
\title{
Samples of linear regression data.
}
\description{
10 000 samples of random data. First column is computed according to the formula \deqn{y=-0.75 + 0.9*x_1 -0.92*x_2 + 0.5*x_3 -1.65*x_4 +\epsilon }
Here \eqn{x_i} are distributed normally with zero mean and variance 1.0 and \eqn{\epsilon} is normally distributed noise with zero mean and variance 0.25. Remaining  four columns contain predictor variables \eqn{x_i}.

This file is a copy of the first 10 000 entries from the file \code{regressiondata.nz.all}
}
\usage{data("regressiondata.nz.pt1")}
\format{
  A data frame with 10 000 observations on five variables \eqn{y,x_1, x_2, x_3, x_4}
}
\keyword{datasets}

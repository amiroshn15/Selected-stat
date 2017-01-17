\name{read.regress.data.ff}
\alias{read.regress.data.ff}

\title{Compute Bayesian regression summary statistics for big data sets that are too large to fit into R memory}


\description{This function reads in big data sets that are too large to fit into R memory and produces summary statistics needed for Bayesian linear regression models. The function takes as input data files with the predictor variables \eqn{X} and response values \eqn{Y}, and returns the summary statistics \eqn{X'X}, \eqn{X'Y} and \eqn{Y'Y} that are used as input to the function \code{bayes.regress()} (in this package), for Bayesian linear regression models. The data sets can be split across multiple files. This function incorporates the R package \code{ff} and its function \code{read.table.ffdf()}. The \code{read.table.ffdf()} function keeps only a portion of a data set in memory as it reads it in chunks; thus, there is no memory limit on the size of files that can be processed.}
\usage{
read.regress.data.ff(filename=NULL,predictor.cols=NA,response.col=NA,update.summaries=NULL
                   , fileEncoding = "", nrows = -1, first.rows = 1e5, next.rows = 1e5
                   , levels = NULL, appendLevels = TRUE, FUN = "read.table", transFUN = NULL
                   , asffdf_args = list(), BATCHBYTES = getOption("ffbatchbytes"), VERBOSE = FALSE
                   , header = FALSE, sep = ",", quote = "\"'", dec = "."
                   , numerals = c("allow.loss", "warn.loss", "no.loss")
                   , na.strings = "NA", colClasses = "numeric", skip = 0
                   , check.names = TRUE, fill = TRUE, strip.white = FALSE
                   , blank.lines.skip = TRUE, comment.char = "#", allowEscapes = FALSE
                   , flush = FALSE, skipNul = FALSE)
}

\arguments{
  \item{filename}{the name of a file or a list of file names, from which the data will be read. By default it is assumed that the file(s) contain data in comma separated format; this can be changed using the \code{sep} argument. File names must be in the format acceptable by standard functions such as \code{\link{read.table}. Default = NULL.}
}
 
  \item{predictor.cols}{a vector of integers that specifies the columns to treat as predictor variables, to create the design matrix \eqn{X}. By default, all columns after the first are treated as columns with predictor variables. Default = \code{NA}.}
  
  \item{response.col}{an integer that specifies the column that contains the response variable values, to create the response vector \eqn{Y}. By default, the first column that is not used as a predictor variable column is selected as the response values column. Default = \code{NA}.}
  
  \item{update.summaries}{The name of the R object containing previously-calculated summary statistics, to be updated with new data. This must be a list similar in structure to the returned value, containing entries \code{xtx}, \code{xty}, \code{yty} and \code{numsamp.data} of appropriate dimensions and class that match the data contained in \code{filename}. Default = \code{NULL}.}
  The remaining arguments are passed directly to the function \code{\link{read.table.ffdf}()}. A description of the primary arguments are the following:
  \item{first.rows}{The number of rows to read in the first chunk of data. Default = 100,000.}
  \item{next.rows}{The number of rows to read in the remaining chunks of data. Default = 100,000.}
  \item{sep}{The character that separates the columns of data. Default = ",".}
}


\details{The function reads data from a comma separated (or similarly formatted) file(s) and computes summary statistics to be used in Bayesian linear regression by the function \code{bayes.regress()} (in this package). The function assumes the regression model will have a non-zero y-intercept; this option can be changed in the \code{bayes.regress()} function (see \code{bayes.regress()} help for details).  
}

\value{The returned value for the \code{read.regress.data.ff()} function is a list containing the summary statistics named \code{xtx} (for \eqn{X'X}), \code{xty} (for \eqn{X'Y}), \code{yty} (for \eqn{Y'Y}) and the total number of data values \code{numsamp.data}. The summary statistic \code{xtx} contains a square matrix obtained by computing a dot product of the predictor variables data \eqn{X} with itself; a leading column of 1's is added to \eqn{X} for the y-intercept term. \code{xty} contains the vector obtained by computing the dot product of the transposed predictor variables data \eqn{X} with response variable data \eqn{Y}; a leading column of 1's is added to \eqn{X} for the y-intercept term. \code{yty} contains the dot product of the response variable data \eqn{Y} with itself. \code{numsamp.data} is the number of data values read from the data file(s); this number may be smaller than the number of rows in the data file, since some of the rows with missing data may be skipped according to specified function arguments.

The returned values are used as input to the function \code{bayes.regress()} (in this package). Note that the matrix \code{X} is given a leading column of 1's by default, for the y-intercept term of the Bayesian linear regression model. This can be removed by specifying a model with zero intercept in the function \code{bayes.regress()} (see \code{bayes.regress()} help for details).}

\references{
Carlin, B.P. and Louis, T.A. (2009) \emph{Bayesian Methods for Data Analysis, 3rd ed.}, Boca Raton, FL: Chapman and Hall/CRC Press.

Gelman, A., Carlin, J.B., Stern, H.S., Dunson, D.B., Vehtari, A. and Rubin, D.B. (2013) \emph{Bayesian Data Analysis, 3rd ed.}, Boca Raton, FL: Chapman and Hall/CRC Press.

Adler, D., Glaser, C., Nenadic, O., Oehlschlagel, J. and Zucchini, W. (2013) ff: memory-efficient storage of large data on disk and fast access functions. R package: \url{http://CRAN.R-project.org/package=ff}. 

}

\examples{
# The package includes several example data files.
# The following command finds the location of the data file
# that includes 4 predictor variables and 20,000 simulated data values

filename <- system.file('data/regressiondata.nz.all.csv.gz', package='BayesBigDataLM')

# The file is formatted so that the response variable is in first column
# the columns 2 to 5 contain simulated predictor variables.
# The simulated coefficients are: beta <- c(0.76, -0.92, 0.64, 0.57, -1.65), 
# where the first number is the y-intercept term in the 
# linear regression model.
# The sigmasq term, i.e. the variance of the normally distributed
# error terms is simulated as: sigmasq <- 0.25

## Next, read the data and compute the summary statistics.
# By default, the first column is assumed to be the response variable, 
# and the remaining columns are assumed to contain predictor variable values.
# The function will check if the file exists and can be read.

data.values <- read.regress.data.ff(filename)
data.values

## Several files can be given in a list to be read sequentially
filenames <- list(
  system.file('data/regressiondata.nz.pt1.csv.gz', package='BayesBigDataLM'),
  system.file('data/regressiondata.nz.pt2.csv.gz', package='BayesBigDataLM')
)
data.values <- read.regress.data.ff(filenames)
# compare this to the data.values obtained previously. They are the same, 
# since the current files are just copies of the same data split between two files.
data.values

## The files can be read progressively through time, updating the statistics with data in each file
filenames <- list(
  system.file('data/regressiondata.nz.pt1.csv.gz', package='BayesBigDataLM'),
  system.file('data/regressiondata.nz.pt2.csv.gz', package='BayesBigDataLM')
)
data.values <- read.regress.data.ff(filenames[[1]])
data.values
data.values2 <- read.regress.data.ff(filenames[[2]], update.summaries = data.values)
data.values2

## If not all columns are to be used in regression analysis, one can specify
# which columns to use in the "predictor.cols" and "response.col" options.
filename <- system.file('data/regressiondata.nz.all.csv.gz', package='BayesBigDataLM')
data.values <- read.regress.data.ff(filename, predictor.cols=c(4,2,3), response.col=5)
data.values

## If the R session must be terminated, the summary statistics can be saved and then loaded using standard methods in R
filenames <- list(
  system.file('data/regressiondata.nz.pt1.csv.gz', package='BayesBigDataLM'),
  system.file('data/regressiondata.nz.pt2.csv.gz', package='BayesBigDataLM')
)
data.values <- read.regress.data.ff(filenames[[1]])
tmpfname <- tempfile()

save(data.values, file = tmpfname)
rm(data.values)
# Now the R session can be terminated. Note that the file name must be
# stored to be used for updating.
# Upon starting the new session, the state can be restored
load(tmpfname)
unlink(tmpfname)
# if a new portion of data arrived, update the summary stistics
data.values2 <- read.regress.data.ff(filenames[[2]], update.summaries = data.values)
data.values2
}
\keyword{multilinear}
\keyword{regression}
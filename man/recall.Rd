% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/context_log.R
\name{recall}
\alias{recall}
\title{Recall a function call that is stored in the context tree}
\usage{
recall(funCall = getFunctionCall(i), i = toIndex(id), id = "", ...)
}
\arguments{
\item{funCall}{Function call to be re-called. By default it is taken from the
context tree at index \code{i}}

\item{i}{Index of the function call in the context tree}

\item{id}{As an alternative to specifying the index \code{i} of the call in
the call tree you can specify it by its ID (as shown by when calling
\code{\link{printContext}}.}

\item{...}{argument = value pairs overriding the argument setting of the
stored function call.}
}
\description{
Recall a function of which the call is stored in the context tree. You may
specify argument settings that override the argument settings of the original
call by passing \code{key = value} pairs to this function.
}
\examples{
\dontrun{

# Load the required libraries
library(kwb.context)
library(kwb.default) # for setDefault()

# Set the default context number to 2 (required until now!)
funNames <- c(paste0(c("init", "print", "get"), "Context"), "getFunctionCall")
for (funName in funNames) {
  setDefault(funName, number = 2)
}

# Initialise the context tree (currently it's a global list called "CONTEXT1")
initContext()

# Call a function that contains a call of logcall() or that calls other
# functions that contain calls of logcall(). The logcall()-calls have the
# effect that they save the calling context in the global context tree
oldpar <- par(mfrow = c(1, 3), no.readonly = TRUE)
example_three_plots()

# Print the context tree that has been recorded
printContext()

# Change the order of the original plots
recall(i = 8)
recall(i = 5)
recall(i = 2)

# Reset the graphical parameters
par(oldpar)

# Replot the second plot, now on its own page, but with a different colour,
# plot symbol and size
recall(i = 5, col = "red", pch = 16, cex = 2)
}
}

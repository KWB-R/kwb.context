#
# Variant 1: in the first expression of your function body, call logcall()
#

# example_three_plots ----------------------------------------------------------
#' Example function calling example_one_plot three times
#'
#' @export
example_three_plots <- function()
{
  logcall("example_three_plots", match.call())

  example_one_plot(1:10, main = "first plot", col = "red")
  example_one_plot(1:5, main = "second plot", col = "blue")
  example_one_plot(1:5, 5:1, main = "third plot", lwd = 3)
}

# example_one_plot -------------------------------------------------------------
#' Example function calling example_crossline twice
#'
#' @param ... arguments passed to \code{plot}
#' @param h position of horizontal line
#' @param v position of vertical line
#' @export
example_one_plot <- function(..., h = 5, v  = 5)
{
  logcall("example_one_plot", match.call())

  plot(...)

  example_crossline(h = h)
  example_crossline(v = v)
}

# example_crossline ------------------------------------------------------------
#' Example function calling abline
#'
#' @param  ... arguments passed to \code{abline}
#'
#' @export
example_crossline <- function(...)
{
  logcall("example_crossline", match.call())

  abline(...)
}

#
# Variant 2: call functions that you want to be able to recall with mycall()
#
f1 <- function(a, b = 1)
{
  p <- a * b
  cat(sprintf("%d * %d = %d\n", a, b, p))
  p
}

f2 <- function()
{
  p1 <- mycall("f1", list(1, 2)) 
  p2 <- mycall("f1", list(3, 4))
  p3 <- mycall("f1", list(a = 3))
  s <- p1 + p2
  cat(sprintf("p1 + p2 = %d + %d = %d\n", p1, p2, s))
  s
}

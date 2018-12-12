# initContext ------------------------------------------------------------------
#' Initialise the variable storing the full function call context
#'
#' @param number Number of the context. You may use different contexts that are
#'   numbered. The default context number is 1.
#' @export
initContext <- function(number = getDefault("initContext", "number"))
{
  setContext(list(), number = number)
}

# setContext -------------------------------------------------------------------
#' @importFrom kwb.utils assignGlobally
setContext <- function(x, number = getDefault("setContext", "number"))
{
  assignGlobally(contextName(number), x)
}

# contextName ------------------------------------------------------------------
contextName <- function(number = getDefault("contextName", "number"))
{
  paste0("CONTEXT", number)
}

# getContext -------------------------------------------------------------------
#' Get the context tree (currently from a global variable "CONTEXT\code{n}")
#'
#' @param number Context number (see \code{\link{initContext}})
#'
#' @return a list of function calls
#'
#' @export
#'
#' @importFrom kwb.utils getGlobally
getContext <- function(number = getDefault("getContext", "number"))
{
  getGlobally(contextName(number), list())
}

# printContext -----------------------------------------------------------------
#' Print the context of a function call
#'
#' @param number Number of the context to print (see \code{\link{initContext}})
#' @param indent string used to indent nested function calls in the output
#' @importFrom kwb.utils selectElements
#' @importFrom kwb.utils arglist
#' @export
printContext <- function
(
  number = getDefault("printContext", "number"),
  indent = "  "
)
{
  context <- getContext(number)

  names.context <- names(context)

  nchar.i <- nchar(length(context))
  nchar.id <- nchar.max(names.context)

  #i <- 1
  for (i in seq_along(context)) {

    element <- context[[i]]
    depth <- selectElements(element, "depth")
    funName <- selectElements(element, "funName")

    if (number == 1) {

      argumentList <- as.character(selectElements(element, "arglist"))
      cat(sprintf("%d: callWith(%s, ARGS$%s)\n", i, funName, argumentList))
    }
    else {

      argumentList <- as.list(selectElements(element, "funCall"))[-1]

      cat(paste0(
        "i=", toLength(i, nchar.i),
        ",id=", toLength(names.context[i], nchar.id, "left"),
        ":", # indentation(depth, indent),
        funName, "(", listToString(argumentList), ")\n"
      ))
    }
  }
}

# nchar.max --------------------------------------------------------------------
nchar.max <- function(x)
{
  max(sapply(x, nchar))
}

# toLength ---------------------------------------------------------------------
toLength <- function(x, n = nchar(x), justify = c("left", "right")[2])
{
  chars <- strsplit(as.character(x), "")[[1]]

  out <- substr(x, 1, n)

  gapstring <- rep(" ", n - nchar(out))

  if (justify == "right") {
    paste0(c(gapstring, out), collapse = "")
  }
  else if (justify == "left") {
    paste0(c(out, gapstring), collapse = "")
  }
  else {
    stop("Invalid value for 'justify': '", justify, "'",
         " (only 'left' or 'right' allowed.)")
  }
}

# indentation ------------------------------------------------------------------
indentation <- function(depth = 1, indent = "  ")
{
  paste0(rep(indent, depth), collapse = "")
}

# listToString -----------------------------------------------------------------
#' @importFrom kwb.utils defaultIfNULL
listToString <- function(x)
{
  stopifnot(is.list(x))

  emptyChars <- character(length(x))

  names.x <- defaultIfNULL(names(x), emptyChars)

  equalSign <- emptyChars

  equalSign[names.x != ""] <- " = "

  paste0(names.x, equalSign, as.character(x), collapse = ", ")
}

# test_context_functions -------------------------------------------------------
test_context_functions <- function()
{
  initContext()

  stopifnot(identical(getContext(), list()))

  c1 <- list("call1")
  c2 <- list("call2")

  setContext(c1)

  stopifnot(identical(getContext(), c1))

  setContext(c2, number = 2)
  stopifnot(identical(getContext(2), c2))

  rm(list = contextName(1:2), envir = .GlobalEnv)
}

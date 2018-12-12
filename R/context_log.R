# Example script ---------------------------------------------------------------
if (FALSE)
{
  # Load the required libraries
  library(kwb.utils)
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
  recall(i = 5, main = "Neue Ueberschrift", col = "red", pch = 16, cex = 3)
  recall(i = 2)

  # Replot the second plot, but with a different colour, plot symbol and size
  par(oldpar)
  recall(i = 5, col = "red", pch = 16, cex = 2)

  recall(id = 'example_crossline__2', v = 3:5)

  context <- lapply(getContext(), "[[", "funCall")
  str(context)
  traceback(context)

  #x$parent_frame_1

  #test_context_functions()
}

# getFunctionCall --------------------------------------------------------------
#' Get a function call from the context tree
#'
#' @param i Index of the function call as it is stored in the context
#' @param number Number of the context (see \code{\link{initContext}})
#' @export
#'
#' @importFrom kwb.default getDefault
#' @importFrom kwb.utils selectElements
getFunctionCall <- function(i, number = getDefault("getFunctionCall", "number"))
{
  selectElements(getContext(number)[[i]], "funCall")
}

# mycall -----------------------------------------------------------------------
mycall <- function(FUN, args = list(), dbg = FALSE)
{
  if (! is.function(FUN)) {
    stop("FUN must be a function!")
  }

  funName <- as.character(substitute(FUN))

  # Get global context list
  context <- getContext()

  id <- getNewId(funName, existingIDs = names(context))

  element <- list(
    FUN = FUN,
    funName = funName,
    arglist = id,
    matchcall = match.call(FUN, as.call(c(as.symbol(funName), args))),
    call = sys.call(),
    calls = sys.calls(),
    frame = sys.frame(),
    frames = sys.frames(),
    function.this = sys.function(0),
    function.caller = sys.function(-1),
    nframe = sys.nframe(),
    parent_1 = sys.parent(1),
    parent_frame_1 = parent.frame(1)
  )

  context[[id]] <- element

  # Save global context list
  setContext(context)

  do.call(FUN, args)
}

# getNewId ---------------------------------------------------------------------
#' @importFrom kwb.utils printIf
getNewId <- function(funName, existingIDs = NULL, dbg = FALSE)
{
  format.id <- "%s__%d"
  pattern.id <- "^(.*)__\\d+$"

  if (length(existingIDs)) {

    printIf(dbg, existingIDs)

    funNames <- gsub(pattern.id, "\\1", existingIDs)

    printIf(dbg, funNames)

    n.existing <- sum(funNames == funName)

  } else {
    n.existing <- 0
  }

  sprintf(format.id, funName, n.existing + 1)
}

# logcall ----------------------------------------------------------------------
logcall <- function(funName, funCall)
{
  context <- getContext(2)

  element <- list(
    funName = funName,
    funCall = funCall,
    depth = length(context)
  )

  context[[getNewId(funName, names(context))]] <- element

  setContext(context, number = 2)
}

# recall ----------------------------------------------------------------------
#' Recall a function call that is stored in the context tree
#'
#' Recall a function of which the call is stored in the context tree. You may
#' specify argument settings that override the argument settings of the original
#' call by passing \code{key = value} pairs to this function.
#'
#' @param funCall Function call to be re-called. By default it is taken from the
#'   context tree at index \code{i}
#' @param i Index of the function call in the context tree
#' @param id As an alternative to specifying the index \code{i} of the call in
#'   the call tree you can specify it by its ID (as shown by when calling
#'   \code{\link{printContext}}.
#' @param ... argument = value pairs overriding the argument setting of the
#'   stored function call.
#'
#' @export
#'
#' @importFrom kwb.utils arglist
#'
#' @examples
#' \dontrun{
#'
#' # Load the required libraries
#' library(kwb.context)
#' library(kwb.default) # for setDefault()
#'
#' # Set the default context number to 2 (required until now!)
#' funNames <- c(paste0(c("init", "print", "get"), "Context"), "getFunctionCall")
#' for (funName in funNames) {
#'   setDefault(funName, number = 2)
#' }
#'
#' # Initialise the context tree (currently it's a global list called "CONTEXT1")
#' initContext()
#'
#' # Call a function that contains a call of logcall() or that calls other
#' # functions that contain calls of logcall(). The logcall()-calls have the
#' # effect that they save the calling context in the global context tree
#' oldpar <- par(mfrow = c(1, 3), no.readonly = TRUE)
#' example_three_plots()
#'
#' # Print the context tree that has been recorded
#' printContext()
#'
#' # Change the order of the original plots
#' recall(i = 8)
#' recall(i = 5)
#' recall(i = 2)
#'
#' # Reset the graphical parameters
#' par(oldpar)
#'
#' # Replot the second plot, now on its own page, but with a different colour,
#' # plot symbol and size
#' recall(i = 5, col = "red", pch = 16, cex = 2)
#' }
recall <- function(funCall = getFunctionCall(i), i = toIndex(id), id = "", ...)
{
  funName <- as.character(funCall[[1]]) # attr(funCall, "funName")
  args <- arglist(as.list(funCall)[-1], ...)
  #args <- arglist(as.list(funCall)[-1], a=2)

  do.call(funName, args)
}

# toIndex ----------------------------------------------------------------------
toIndex <- function(id)
{
  ids <- names(getContext())

  if (! is.character(id) || ! id %in% ids) {
    stop("id (you gave '", id, "') must be one of these possible ID ",
         "strings:\n  ", paste0("'", ids, "'", collapes = ",\n  "))
  }

  which(id == ids)
}

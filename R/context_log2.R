if (FALSE)
{
  library(kwb.utils)
  
  call("f2")
  
  match.call(get, call("get", "abc", i = FALSE, p = 3))
  ## -> get(x = "abc", pos = 3, inherits = FALSE)
  fun <- function(x, lower = 0, upper = 1) {
    structure((x - lower) / (upper - lower), CALL = match.call())
  }
  fun(4 * atan(1), u = pi)
  
  # M A I N ----------------------------------------------------------------------
  if (FALSE)
  {
    clearContext()
    
    mycall(f2)
    
    call1 <- as.call(c(as.symbol("f2"), ARGS$args__f2__1))
    call2 <- as.call(c(as.symbol("f1"), ARGS$args__f1__1))
    call3 <- as.call(c(as.symbol("f1"), ARGS$args__f1__2))
    call4 <- as.call(c(as.symbol("f1"), ARGS$args__f1__3))
    
    call1
    match.call(f2, call1)
    
    call2
    match.call(f1, call2)
    
    call3
    match.call(f1, call3)
    
    call4
    match.call(f1, call4)
    
    
    call()
    L <- list(args_f1__1=1,args_f1__2=2)
    
    
    
    x <- CONTEXT[[1]]
    
    x$parent_frame_1
    
    printContext()
  }
  
  # printContext -----------------------------------------------------------------
  printContext <- function(context = getGlobally("CONTEXT"))
  {
    for (i in seq_along(context)) {
      call <- context[[i]]
      cat(sprintf("%d: callWith(%s, ARGS$%s)\n", 
                  i, call$FUN, as.character(call$arglist)))
    }
  }
  
  # clearContext -----------------------------------------------------------------
  clearContext <- function()
  {
    assignGlobally("CONTEXT", list())
    assignGlobally("ARGS", list())
  }
  
  # mycall -----------------------------------------------------------------------
  mycall <- function(FUN, args = list(), dbg = FALSE)
  {
    if (is.function(FUN)) {
      funName <- as.character(substitute(FUN))
    }
    else if (is.character(FUN)) {
      funName <- FUN
      FUN <- getAnywhere(FUN)
      stopifnot(is.function(FUN))
    }
    else {
      stop("FUN must be a function or a character string")
    }
    
    # Get global context list and global list of argument lists
    context <- getGlobally("CONTEXT", list())
    argslist <- getGlobally("ARGS", list())
    
    ids <- names(argslist)
    
    format.id <- "args__%s__%d"
    pattern.id <- "^args__(.*)__\\d+$"
    
    funNames <- gsub(pattern.id, "\\1", ids)
    
    printIf(dbg, ids)
    printIf(dbg, funNames)
    
    id <- sprintf(format.id, funName, sum(funNames == funName) + 1)
    
    argslist[[id]] <- args
    
    cat("funName:\n")
    str(funName)
    
    cat("FUN:\n")
    str(FUN)
    
    
    context[[length(context) + 1]] <- list(
      FUN = FUN, 
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
    
    # Save global context list and global list of argument lists
    assignGlobally("CONTEXT", context)
    assignGlobally("ARGS", argslist)
    
    do.call(FUN, args)
  }
  
}

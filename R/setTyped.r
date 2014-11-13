#' @title
#' Set Typed Object Value (S3)
#'
#' @description 
#' Creates an implicitly typed object.
#' 
#' @details
#' The type (class) of \code{value} is remembered and stored in an invisible
#' object part curtesy of \code{\link[base]{makeActiveBinding}}. For any 
#' subsequent assignment operations on the object, the type (class) of 
#' \code{value} is checked against the originally stored type (class). 
#' Type (class) mismatches trigger an error, a warning or are silently 
#' ignored depending on the value of \code{strict}.
#'  
#' @param id \code{\link{character}}.
#'    Name/ID of the typed object to create.
#' @param value \code{\link{ANY}}.
#'    Object value.
#' @param where \code{\link{environment}}.
#'    Environment in which to create the object.
#' @param inherit \code{\link{logical}}.
#' 		\code{TRUE}: visible typed value inherits from informal S3 
#' 		class \code{TypedObject};
#' 		\code{FALSE}: class table not altered.
#' 		Default: \code{FALSE} to provide maximum amount of compatibality with 
#' 		S3 method dispatch.
#' @param numint \code{\link{logical}}.
#' 		\code{TRUE}: do not distinguish between types (classes) \code{numeric}
#' 		and \code{integer};
#' 		\code{FALSE}: threat them as two different types (classes).
#' 		Default: \code{TRUE} as this seems to make most sense in practical 
#' 		applications.
#' @param from_null \code{\link{logical}}.
#' 		\code{TRUE}: any type (class) is valid to overwrite an initial \code{NULL}
#' 		value.
#' 		\code{FALSE}: this would be regarded as a type (class) mismatch.
#' 		Default: \code{TRUE} as this seems to make most sense in practical 
#' 		applications.
#' @param to_null \code{\link{logical}}.
#' 		\code{TRUE}: value of \code{NULL} is always valid type (class) regardless
#' 		of the type (class) that was stored at the initial assignment operation.
#' 		\code{FALSE}: this would be regarded as a type (class) mismatch.
#' 		Default: \code{TRUE} as this seems to make most sense in practical 
#' 		applications.
#' @param strict \code{\link{numeric}}.
#'    Relevant if assigning an explicit value to an object with reactive 
#'    dependency on other objects.
#'    reactive relationship.
#'    \itemize{
#'      \item{\code{0}: } {ignore without warning}
#'      \item{\code{1}: } {ignore with Warning}
#'      \item{\code{2}: } {stop with error}
#'    }
#' @param ... Further arguments to be passed to subsequent functions/methods.
#'    In particular, all environments of references that you are referring to
#'    in the body of the binding function. 
#'    See section \emph{Referenced environments}.
#' @example inst/examples/setTyped.r
#' @seealso \code{
#'     \link[reactr]{setReactive}
#' }
#' @template author
#' @template references
#' @import conditionr
#' @import digest
#' @export 
setTyped <- function(
    id,
    value = NULL,
    where = parent.frame(),
    numint = TRUE,
    from_null = TRUE,
    to_null = TRUE,
    inherit = FALSE,
    strict = c(2, 1, 0),
    ...
  ) {
#print(where)
  where
  ## Argument checks //
  strict <- as.numeric(match.arg(as.character(strict), 
    as.character(c(2, 1, 0))))

  inv <- structure(new.env(parent = emptyenv()), 
    class = c("InvisibleObject", "environment"))
  inv$.id <- id
  inv$.uid <- digest::digest(list(id = id, where = capture.output(where)))
  inv$.class <- class(value)
  inv$.where <- where
#  inv$.value <- value
  vis <- if (!inherit) {
    value
  } else {
    structure(value, class = c("TypedObject", inv$.class))
  }
  inv$.value <- vis
  inv$.validateType <- validateType

  ## Handle already-in-place regular bindings //
  has_binding <- try(bindingIsActive(id, where), silent = TRUE)
  if (inherits(has_binding, "try-error")){
    has_binding <- FALSE
  }
  if (exists(id, envir = where, inherits = FALSE) && has_binding) {
    rm(list = id, envir = where, inherits = FALSE)
  }

  ## Call to 'makeActiveBinding' //
  makeActiveBinding(id, env = where, 
    fun = function(v) {
      if (missing(v)) {
        inv$.value
      } else {
        if (inv$.validateType(self = inv, value = v, numint = numint, 
            from_null = from_null, to_null = to_null, strict = strict)) {
          inv$.value <- if (!inherit) {
            v
          } else {
            structure(v, class = c("TypedObject", inv$.class))
          }
        }
        inv$.value
      }
    }
  )

  invisible(vis)  
}


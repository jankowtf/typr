#' @title
#' Validate Type (S3)
#'
#' @description 
#' Validates type (class) of an assignment value for a typed object value.
#' 
#' @details
#' The type (class) of the object value as stored at the initial assignment
#' operation via \code{\link{setTyped}} is checked against the type (class)
#' of \code{value}. Type (class) mismatches trigger an error or a warning 
#' depending on the value of \code{strict}.
#'  
#' @param self \code{\link{environment}}.
#'    Invisible object part.
#' @param value \code{\link{ANY}}.
#'    New assignment value.
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
#' 		How to handle type (class) mismatches:
#'    \itemize{
#'      \item{\code{0}: } {ignore without warning}
#'      \item{\code{1}: } {ignore with Warning}
#'      \item{\code{2}: } {stop with error}
#'    }
#' 		Default: \code{2}.
#' @template threedots
#' @example inst/examples/validateType.r
#' @seealso \code{
#'     \link[typr]{setTyped}
#' }
#' @template author
#' @template references
#' @import conditionr
#' @export 
validateType <- function(
  self, 
  value, 
  numint = TRUE,
  from_null = TRUE,
  to_null = TRUE,
  strict = c(2, 1, 0),
  ...
) {
  
  out <- TRUE
  .class_0 <- self$.class
  .class_1 <- class(value)

  if (!inherits(value, .class_0)) {
    ## Early exit if `from_null` is valid //
    if (.class_0 == "NULL" && from_null) {
      return(TRUE)
    } 
    num_clss <- c("integer", "numeric")
    if (any(.class_0 %in% num_clss) && 
        any(.class_1 %in% num_clss) && 
        numint
    ) {
      return(TRUE)
    } else {
      ## Early exit if `to_null` is valid //
      if (any(.class_1 == "NULL") && to_null) {
        return(TRUE)
      }   
      if (strict == 0) {
        out <- FALSE
      } else if (strict == 1) {
        conditionr::signalCondition(
          call = substitute(
            assign(x= ID, value = VALUE, envir = WHERE, inherits = FALSE),
            list(ID = self$.id, VALUE = value, WHERE = self$.where)
          ),
          condition = "AbortedWithClassCheckWarning",
          msg = c(
            Reason = "class of assignment value does not inherit from initial class",
            ID = self$.id,
            UID = self$.uid,
            Location = capture.output(self$.where),
            "Type/class expected" = paste(.class_0, collapse = " | "),
            "Type/class provided" = paste(.class_1, collapse = " | ")
          ),
          ns = "typr",
          type = "warning"
        )    
        out <- FALSE
      } else if (strict == 2) {
        conditionr::signalCondition(
          call = substitute(
            assign(x= ID, value = VALUE, envir = WHERE, inherits = FALSE),
            list(ID = self$.id, VALUE = value, WHERE = self$.where)
          ),
          condition = "AbortedWithClassCheckError",
          msg = c(
            Reason = "class of assignment value does not inherit from initial class",
            ID = self$.id,
            UID = self$.uid,
            Location = capture.output(self$.where),
            "Type/class expected" = paste(.class_0, collapse = " | "),
            "Type/class provided" = paste(.class_1, collapse = " | ")
          ),
          ns = "typr",
          type = "error"
        )
      }
    }
  }
  out
  
}


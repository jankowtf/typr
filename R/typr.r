#' @title
#' Implicitly typed objects
#'
#' @description
#' The package allows to create implicitly typed objects.
#' 
#' @section Core function(s):
#' 
#'  \itemize{
#'    \item{\code{\link[typr]{setTyped}}: }{
#'
#'      Creates an implicitly typed object.
#'      
#'      The type (class) of \code{value} is remembered and stored in an invisible
#' object part curtesy of \code{\link[base]{makeActiveBinding}}. For any 
#' subsequent assignment operations on the object, the type (class) of 
#' \code{value} is checked against the originally stored type (class). 
#' Type (class) mismatches trigger an error, a warning or are silently 
#' ignored depending on the value of \code{strict}.
#'    }
#' }
#'
#' @template author
#' @template references
#' @docType package
#' @name typr
NULL

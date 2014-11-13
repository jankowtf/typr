typr
======

Implicitly typed objects

## Installation

```
require("devtools")
devtools::install_github("Rappster/conditionr")
devtools::install_github("Rappster/typr")
require("typr")
```
## Purpose

The package allows to create implicitly typed objects.

## Vignettes

None so far

----------

## Quick Example

```
(setTyped(id = "x_1", value = 10))
x_1
try(x_1 <- "hello world!")
## --> ignored with error
x_1 <- 20
## --> overwritten
```

## Levels of strictness 

```
## Strict = 2 //
(setTyped(id = "x_1", value = 10))
x_1
try(x_1 <- "hello world!")
## --> ignored with error; default of `strict` is `2`
x_1

## Strict = 1 //
setTyped(id = "x_1", value = 10, strict = 1)
try(x_1 <- "hello world!")
## --> ignored with warning
x_1

## Strict = 0 //
setTyped(id = "x_1", value = 10, strict = 0)
x_1 <- "hello world!"
x_1
## --> simply ignored
```

## Handling `NULL` values 

```
## Change from NULL //
(setTyped(id = "x_1"))
x_1
x_1 <- "hello world!"
x_1
## --> overwritten

setTyped(id = "x_1", from_null = FALSE)
try(x_1 <- "hello world!")
## --> ignored with error

setTyped(id = "x_1", from_null = FALSE, strict = 1)
try(x_1 <- "hello world!")
## --> ignored with warning

setTyped(id = "x_1", from_null = FALSE, strict = 0)
x_1 <- "hello world!"
x_1
## --> simply ignored

## Change to NULL //
setTyped(id = "x_1", value = 10)
x_1 <- NULL
x_1
## --> overwritten

setTyped(id = "x_1", value = 10, to_null = FALSE)
try(x_1 <- NULL)
## --> ignored with error

setTyped(id = "x_1", value = 10, to_null = FALSE, strict = 1)
try(x_1 <- NULL)
## --> ignored with warning

setTyped(id = "x_1", value = 10, to_null = FALSE, strict = 0)
x_1 <- NULL
x_1
## --> simply ignored
```

## Handling numerical values 

```
## Change from `numeric` to `integer` //
setTyped(id = "x_1", 10)
class(x_1)
## --> numeric

(x_1 <- as.integer(20))
class(x_1)
## --> overwritten

setTyped(id = "x_1", 10, numint = FALSE)
try(x_1 <- as.integer(20))
## --> ignored with error

setTyped(id = "x_1", 10, numint = FALSE, strict = 1)
try(x_1 <- as.integer(20))
## --> ignored with warning

setTyped(id = "x_1", 10, numint = FALSE, strict = 0)
x_1 <- as.integer(20)
x_1
class(x_1)
## --> simply ignored

## Change from `integer` to `numeric` //
(setTyped(id = "x_1", as.integer(10)))
class(x_1)
## --> integer

x_1 <- 20
x_1
class(x_1)
## --> overwritten

setTyped("x_1", as.integer(10), numint = FALSE)
try(x_1 <- 20)
## --> ignored with error

setTyped("x_1", as.integer(10), numint = FALSE)
try(x_1 <- 20)
## --> ignored with warning

setTyped("x_1", as.integer(10), numint = FALSE, strict = 0)
x_1 <- 20
x_1
class(x_1)
## --> simply ignored
```

## Handling inheritance

```
value <- structure(10, class = c("MyNumeric", "numeric"))

setTyped(id = "x_1", value)
x_1
inherits(x_1, "MyNumeric")
inherits(x_1, "numeric")

x_1 <- as.integer(20)
x_1
## --> overwritten

setTyped(id = "x_1", value, numint = FALSE)
try(x_1 <- as.integer(10))
## --> ignored with error
## --> note the information that any of {`MyNumeric`, `numeric`} would be 
## a valid type (class)
x_1
```

## Return invisible object 

```
## Return once only //
(res <- setTyped(id = "x_1", 10, return_invis = 1))
## --> return value is `InvisibleObject`
x_1
## --> but `x_1` has value `10`
res$.value
ls(res, all.names = TRUE)
exists(".id", envir = res, inherits = FALSE)
exists(".uid", envir = res, inherits = FALSE)
exists(".class", envir = res, inherits = FALSE)
exists(".where", envir = res, inherits = FALSE)
exists(".validateType", envir = res, inherits = FALSE)

## Return always //
(res <- setTyped(id = "x_1", 10, return_invis = 2))
identical(x_1, res)
## --> invisible object is now also assigned to `x_1`

exists(".id", envir = x_1, inherits = FALSE)
exists(".uid", envir = x_1, inherits = FALSE)
exists(".class", envir = x_1, inherits = FALSE)
exists(".where", envir = x_1, inherits = FALSE)
exists(".validateType", envir = x_1, inherits = FALSE)
```

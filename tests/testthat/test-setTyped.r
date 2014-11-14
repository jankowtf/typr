##------------------------------------------------------------------------------
context("setTyped/strictness")
##------------------------------------------------------------------------------

test_that("setTyped/strict = 2", {

  expect_equal(res <- setTyped(id = "x_1", value = 10), 10)
  expect_error(x_1 <- "hello world!")
  expect_equal(x_1, 10)
  rm("x_1")
  
})

test_that("setTyped/strict = 1", {
  
  expect_equal(setTyped(id = "x_1", value = 10, strict = 1), 10)
  expect_equal(x_1, 10)
  expect_warning(expect_equal(x_1 <- "hello world!", "hello world!"))
  expect_equal(x_1, 10)
  rm("x_1")
  
})

test_that("setTyped/strict = 0", {

  expect_equivalent(res <- setTyped(id = "x_1", value = 10, strict = 0), 10)
  expect_equal(x_1, 10)
  expect_equal(x_1 <- "hello world!", "hello world!")
  expect_equal(x_1, 10)
  rm("x_1")
  
})

##------------------------------------------------------------------------------
context("setTyped/null")
##------------------------------------------------------------------------------

test_that("setTyped/change from null", {

  expect_equivalent(setTyped(id = "x_1"), NULL)
  expect_equal(x_1, NULL)
  expect_equal(x_1 <- "hello world!", "hello world!")
  expect_equal(x_1, "hello world!")
  
  expect_equivalent(setTyped(id = "x_1", from_null = FALSE), NULL)
  expect_equal(x_1, NULL)
  expect_error(x_1 <- "hello world!")
  expect_equal(x_1, NULL)
  rm("x_1")
  
})

test_that("setTyped/change to null", {

  expect_equivalent(setTyped(id = "x_1", value = 10), 10)
  expect_equal(x_1, 10)
  expect_equal(x_1 <- NULL, NULL)
  expect_equal(x_1, NULL)
  
  expect_equivalent(setTyped(id = "x_1", value = 10, to_null = FALSE), 10)
  expect_equal(x_1, 10)
  expect_error(x_1 <- NULL)
  expect_equal(x_1, 10)
  rm("x_1")
  
})

##------------------------------------------------------------------------------
context("setTyped/numerical")
##------------------------------------------------------------------------------

test_that("setTyped/numerical", {

  expect_equivalent(setTyped(id = "x_1", 10), 10)
  expect_is(x_1, "numeric")
  expect_equal(x_1 <- as.integer(20), as.integer(20))
  expect_is(x_1, "integer")
  
  expect_equivalent(setTyped(id = "x_1", 10, numint = FALSE), 10)
  expect_equal(x_1, 10)
  expect_error(x_1 <- as.integer(10))
  expect_equal(x_1, 10)
  rm("x_1")
  
})

##------------------------------------------------------------------------------
context("setTyped/inheritance")
##------------------------------------------------------------------------------

test_that("setTyped/inheritance", {

  value <- structure(10, class = c("MyNumeric", "numeric"))
  expect_is(setTyped(id = "x_1", value), "MyNumeric")
  expect_is(x_1, "MyNumeric")
  expect_is(x_1, "numeric")
  expect_equal(x_1 <- as.integer(20), as.integer(20))
  expect_is(x_1, "integer")
  
  expect_is(setTyped(id = "x_1", value, numint = FALSE), "numeric")
  expect_error(x_1 <- as.integer(10))
  expect_false(identical(x_1, 10))
  
})

##------------------------------------------------------------------------------
context("setTyped/invisible")
##------------------------------------------------------------------------------

test_that("setTyped/invisible/once", {

  expect_is(res <- setTyped(id = "x_1", 10, return_invis = 1), 
    "InvisibleObject")
  expect_equal(res$.value, 10)
  expect_true(exists(".id", envir = res, inherits = FALSE))
  expect_true(exists(".uid", envir = res, inherits = FALSE))
  expect_true(exists(".class", envir = res, inherits = FALSE))
  expect_true(exists(".where", envir = res, inherits = FALSE))
  expect_true(exists(".validateType", envir = res, inherits = FALSE))
  
})

test_that("setTyped/invisible/always", {

  expect_is(res <- setTyped(id = "x_1", 10, return_invis = 2), 
    "InvisibleObject")
  expect_is(x_1, "InvisibleObject")
  expect_equal(x_1, res)
  expect_true(exists(".id", envir = x_1, inherits = FALSE))
  expect_true(exists(".uid", envir = x_1, inherits = FALSE))
  expect_true(exists(".class", envir = x_1, inherits = FALSE))
  expect_true(exists(".where", envir = x_1, inherits = FALSE))
  expect_true(exists(".validateType", envir = x_1, inherits = FALSE))
  
})

##------------------------------------------------------------------------------
context("setTyped/already regular binding")
##------------------------------------------------------------------------------

test_that("setTyped/already regular binding", {

  a <- 10
  expect_equal(setTyped(id = "a", value = 10), 10)
  
})

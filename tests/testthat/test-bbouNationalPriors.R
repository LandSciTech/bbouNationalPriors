test_that("from table", {
  expect_type(bbouNationalPriors(10, 5), "list")

  # nimble shouldn't be attached unless the model is run
  if(!interactive()){
    expect_false(any(grepl("nimble", search())))
  }
})

test_that("force works and return is the same", {
  tbl_res <- bbouNationalPriors(20, 30)

  mod_res <- bbouNationalPriors(20, 30, force_run_model = TRUE)

  expect_equal(tbl_res, mod_res, tolerance = 0.1)
})

test_that("use model when no match works", {
  expect_warning(bbouNationalPriors(20.5, 30))
})

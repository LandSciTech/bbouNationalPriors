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

test_that("bbouNationalPriors works", {
  expect_error(bbouNationalPriors(Anthro = 1:6, fire_excl_anthro = 1:6*5/10))
  lowA <- bbouNationalPriors(Anthro = 1, fire_excl_anthro = 1)
  highA <- bbouNationalPriors(Anthro = 95, fire_excl_anthro = 1)

  # survival is lower when anthro is high
  expect_gt(lowA$priors_survival["b0_mu"], highA$priors_survival["b0_mu"])

  # annual survival is lower than monthly
  annual <- bbouNationalPriors(Anthro = 1, fire_excl_anthro = 1, month = FALSE)

  expect_gt(lowA$priors_survival["b0_mu"], annual$priors_survival["b0_mu"])

  both <- bbouNationalPriors(Anthro = 1, fire_excl_anthro = 1, month = "both")
})

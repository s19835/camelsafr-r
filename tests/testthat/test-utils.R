test_that("validate_level accepts valid levels", {
  expect_invisible(validate_level("L1"))
  expect_invisible(validate_level("L4"))
})

test_that("validate_level rejects invalid level", {
  expect_error(validate_level("L99"), 'level must be one of')
  expect_error(validate_level("l1"),  'level must be one of')
})

test_that("validate_freq accepts valid freqs", {
  expect_invisible(validate_freq("daily"))
  expect_invisible(validate_freq("annual"))
})

test_that("validate_freq rejects invalid freq", {
  expect_error(validate_freq("decadal"), 'freq must be one of')
})

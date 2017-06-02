context("CLD2")

test_that("language detection works", {
  expect_true(detect_language("To be or not to be") == "ENGLISH")
  expect_true(detect_language("Ce n'est pas grave.") == "FRENCH")
  expect_true(detect_language("Nou breekt mijn klomp!") == "DUTCH")
})

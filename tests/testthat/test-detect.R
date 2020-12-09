context("CLD2")

test_that("vectorised input works", {
  skip_on_cran()
  skip_if_not(require(readtext))
  DATA_DIR <- system.file("extdata", "pdf", "UDHR", package = "readtext")
  rt7 <- readtext::readtext(sort(list.files(DATA_DIR, full.names = TRUE, pattern = "\\.pdf$")),
                   docvarsfrom = "filenames",
                   docvarnames = c("document", "language"))
  langs <- c("CHINESE", "CZECH", "DANISH", "ENGLISH", "FRENCH",
        "GREEK", "HUNGARIAN", "IRISH", "JAPANESE", "RUSSIAN", NA)
  codes <- c("zh", "cs", "da", "en", "fr", "el", "hu", "ga", "ja", "ru", NA)
  expect_equal(detect_language(rt7, lang_code = FALSE), langs)
  expect_equal(detect_language(rt7, lang_code = TRUE), codes)
  expect_equal(detect_language(rt7$text, lang_code = FALSE), langs)
  expect_equal(detect_language(rt7$text, lang_code = TRUE), codes)
})

test_that("language detection is accurate", {
  # Doesn't work on sparc
  skip_on_cran()
  skip_if_not(.Platform$endian == "little")
  expect_equal(detect_language("To be or not to be"), "en")
  expect_equal(detect_language("Ce n'est pas grave."), "fr")
  expect_equal(detect_language("Nou breekt mijn klomp!"),"nl")
})

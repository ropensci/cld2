context("CLD2")

test_that("vectorised input works", {
  skip_on_os("solaris")
  DATA_DIR <- system.file("extdata", "pdf", "UDHR", package = "readtext")
  rt7 <- readtext::readtext(sort(list.files(DATA_DIR, full.names = TRUE, pattern = "\\.pdf$")),
                   docvarsfrom = "filenames",
                   docvarnames = c("document", "language"))
  langs <- c("CHINESE", "CZECH", "DANISH", "ENGLISH", "FRENCH",
        "GREEK", "HUNGARIAN", "IRISH", "JAPANESE", "RUSSIAN", NA)
  codes <- c("zh", "cs", "da", "en", "fr", "el", "hu", "ga", "ja", "ru", NA)
  expect_equal(detect_language(rt7), langs)
  expect_equal(detect_language(rt7, lang_code = TRUE), codes)
  expect_equal(detect_language(rt7$text), langs)
  expect_equal(detect_language(rt7$text, lang_code = TRUE), codes)
})

test_that("language detection is accurate", {
  skip_on_os("solaris")
  expect_equal(detect_language("To be or not to be"), "ENGLISH")
  expect_equal(detect_language("Ce n'est pas grave."), "FRENCH")
  expect_equal(detect_language("Nou breekt mijn klomp!"),"DUTCH")
})

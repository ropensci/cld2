#' Compact Language Detector 2
#'
#' The function [detect_language()] guesses the language of `text` or returns `NA`
#' if the language could not reliably be determined. The function [detect_language_multi()]
#' shows the top 3 guessed languages including a relative probability score, and also shows
#' the total number of text bytes that was reliably classified into either language.
#'
#' @importFrom Rcpp sourceCpp
#' @useDynLib cld2
#' @export
#' @rdname cld2
#' @param text a string with text to guess.
#' @param plain_text if `FALSE` then code skips HTML tags and expands HTML entities
detect_language <- function(text, plain_text = TRUE){
  text <- paste(text, collapse = "\n")
  detect_language_cc(text, plain_text)
}

#' @export
#' @rdname cld2
detect_language_multi <- function(text, plain_text = TRUE){
  text <- paste(text, collapse = "\n")
  detect_language_multi_cc(text, plain_text)
}

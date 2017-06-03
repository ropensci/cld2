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
#' @examples # Read text
#' detect_language("To be or not to be")
#' detect_language("Ce n'est pas grave.")
#' detect_language("Nou breekt mijn klomp!")
#'
#' # Read HTML
#' detect_language(url('http://www.un.org/ar/universal-declaration-human-rights/'), plain_text = FALSE)
detect_language <- function(text, plain_text = TRUE){
  detect_language_cc(as_string(text), plain_text)
}

#' @export
#' @rdname cld2
detect_language_multi <- function(text, plain_text = TRUE){
  detect_language_multi_cc(as_string(text), plain_text)
}

as_string <- function(text){
  if(inherits(text, "connection")){
    con <- text
    if(!isOpen(con)){
      open(con, "rt")
      on.exit(close(con))
    }
    text <- readLines(con, warn = FALSE)
  }
  if(!is.character(text) || !length(text))
    stop("Parameter 'text' must be a connection or character vector")
  paste(text, collapse = "\n")
}

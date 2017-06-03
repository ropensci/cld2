#' Compact Language Detector 2
#'
#' The function [detect_language()] guesses the language of `text` or returns `NA`
#' if the language could not reliably be determined. The function [detect_language_multi()]
#' shows the top 3 guessed languages including a relative probability score, and also shows
#' the total number of text bytes that was reliably classified.
#'
#' @importFrom Rcpp sourceCpp
#' @useDynLib cld2
#' @name cld2
#' @aliases cld2
#' @export
#' @rdname cld2
#' @param text a string with text to classify or a connection to read from
#' @param plain_text if `FALSE` then code skips HTML tags and expands HTML entities
#' @examples # Read text
#' detect_language("To be or not to be")
#' detect_language("Ce n'est pas grave.")
#' detect_language("Nou breekt mijn klomp!")
#'
#' \dontrun{
#' # Read HTML from connection
#' detect_language(url('http://www.un.org/ar/universal-declaration-human-rights/'), plain_text = FALSE)
#'
#' # More detailed classification output
#' detect_language_multi(
#'   url('http://www.un.org/fr/universal-declaration-human-rights/'), plain_text = FALSE)
#'
#' detect_language_multi(
#'   url('http://www.un.org/zh/universal-declaration-human-rights/'), plain_text = FALSE)
#' }
detect_language <- function(text, plain_text = TRUE){
  toupper(detect_language_cc(as_string(text), plain_text))
}

#' @export
#' @rdname cld2
detect_language_multi <- function(text, plain_text = TRUE){
  out <- detect_language_multi_cc(as_string(text), plain_text)
  out$classificaton$language <- toupper(out$classificaton$language)
  out
}

as_string <- function(text){
  if(inherits(text, "connection")){
    con <- text
    if(!isOpen(con)){
      on.exit(try(close(con), silent = TRUE))
      open(con)
    }
    text <- readLines(con, warn = FALSE)
  }
  if(!is.character(text) || !length(text))
    stop("Parameter 'text' must be a connection or character vector")
  paste(text, collapse = "\n")
}

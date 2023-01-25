#' Compact Language Detector 2
#'
#' The function [detect_language()] is vectorised and guesses the the language of each string
#' in `text` or returns `NA` if the language could not reliably be determined. The function
#' [detect_language_mixed()] is not vectorised and analyses the entire character vector as a
#' whole. The output includes the top 3 detected languages including the relative proportion
#' and the total number of text bytes that was reliably classified.
#'
#' @importFrom Rcpp sourceCpp
#' @useDynLib cld2
#' @name cld2
#' @aliases cld2
#' @export
#' @rdname cld2
#' @param text a string with text to classify or a connection to read from
#' @param plain_text if `FALSE` then code skips HTML tags and expands HTML entities
#' @param lang_code return a language code instead of name
#' @examples # Vectorized function
#' text <- c("To be or not to be?", "Ce n'est pas grave.", "Nou breekt mijn klomp!")
#' detect_language(text)
#'
#' \dontrun{
#' # Read HTML from connection
#' detect_language(url('http://www.un.org/ar/universal-declaration-human-rights/'), plain_text = FALSE)
#'
#' # More detailed classification output
#' detect_language_mixed(
#'   url('http://www.un.org/fr/universal-declaration-human-rights/'), plain_text = FALSE)
#'
#' detect_language_mixed(
#'   url('http://www.un.org/zh/universal-declaration-human-rights/'), plain_text = FALSE)
#' }
detect_language <- function(text, plain_text = TRUE, lang_code = TRUE){
  if(is.data.frame(text)){
    text <- text$text
    if(!length(text))
      stop("Argument 'text' does not contain a 'text' column.")
  }
  out <- detect_language_cc(as_string(text), plain_text, lang_code)
  if(!isTRUE(lang_code))
    out <- toupper(out)
  out
}

#' @export
#' @aliases detect_language_multi
#' @rdname cld2
detect_language_mixed <- function(text, plain_text = TRUE){
  out <- detect_language_multi_cc(as_string(text, vectorize = FALSE), plain_text)
  out$classification$language <- toupper(out$classification$language)
  out
}

# Old name
detect_language_multi <- detect_language_mixed

as_string <- function(text, vectorize = TRUE){
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
  paste(enc2utf8(text), collapse = if(!vectorize) "\n")
}

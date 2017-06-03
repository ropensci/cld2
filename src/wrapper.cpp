#define STRICT_R_HEADERS
#define R_NO_REMAP

#include <Rcpp.h>
#include "libcld2/public/compact_lang_det.h"

/* Super simple api, returns language as string if pretty certain, otherwise NA */

// [[Rcpp::export]]
Rcpp::CharacterVector detect_language_cc(Rcpp::String input, bool plain_text = true){
  input.set_encoding(CE_UTF8);
  std::string buf(input);
  bool is_reliable;
  CLD2::Language lang = CLD2::DetectLanguage(buf.c_str(), buf.length(), plain_text, &is_reliable);
  if(!is_reliable)
    return NA_STRING;
  Rcpp::CharacterVector out(LanguageName(lang));
  out.attr("code") = Rcpp::String(LanguageCode(lang));
  return out;
}

/* Pro API: return all data */

// [[Rcpp::export]]
Rcpp::List detect_language_multi_cc(Rcpp::String input, bool plain_text = true){
  input.set_encoding(CE_UTF8);
  std::string buf(input);
  bool is_reliable;
  CLD2::Language lang[3];
  int percent[3];
  int text_bytes;
  CLD2::DetectLanguageSummary(buf.c_str(), buf.length(), plain_text, lang, percent, &text_bytes, &is_reliable);
  Rcpp::CharacterVector langs;
  Rcpp::CharacterVector codes;
  Rcpp::LogicalVector latin;
  Rcpp::NumericVector pct;
  for(int i = 0; i < 3; i++){
    langs.push_back(LanguageName(lang[i]));
    codes.push_back(LanguageCode(lang[i]));
    latin.push_back(IsLatnLanguage(lang[i]));
    pct.push_back(percent[i]);
  }
  Rcpp::DataFrame guesses = Rcpp::DataFrame::create(
    Rcpp::Named("language") = langs,
    Rcpp::Named("code") = codes,
    Rcpp::Named("latin") = latin,
    Rcpp::Named("proportion") = pct / 100
  );
  return Rcpp::List::create(
    Rcpp::Named("classificaton") = guesses,
    Rcpp::Named("bytes") = text_bytes,
    Rcpp::Named("reliabale") = is_reliable
  );
}

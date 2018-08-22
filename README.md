# cld2

##### *R Wrapper for Google's Compact Language Detector 2*

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/ropensci/cld2.svg?branch=master)](https://travis-ci.org/ropensci/cld2)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropensci/cld2?branch=master&svg=true)](https://ci.appveyor.com/project/jeroen/cld2)
[![Coverage Status](https://codecov.io/github/ropensci/cld2/coverage.svg?branch=master)](https://codecov.io/github/ropensci/cld2?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/cld2)](https://cran.r-project.org/package=cld2)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/cld2)](https://cran.r-project.org/package=cld2)
[![Github Stars](https://img.shields.io/github/stars/ropensci/cld2.svg?style=social&label=Github)](https://github.com/ropensci/cld2)

> CLD2 probabilistically detects over 80 languages in Unicode UTF-8 text, either 
  plain text or HTML/XML. For mixed-language input, CLD2 returns the top three languages found
  and their approximate percentages of the total text bytes (e.g. 80% English and 20% French 
  out of 1000 bytes)

## Installation

This package includes a bundled version of libcld2:

```r
devtools::install_github("ropensci/cld2")
```

## Guess a Language

The function `detect_language()` returns the best guess or NA if the language could not reliablity be determined. 

```r
cld2::detect_language("To be or not to be")
# [1] "ENGLISH"

cld2::detect_language("Ce n'est pas grave.")
# [1] "FRENCH"

cld2::detect_language("Nou breekt mijn klomp!")
# [1] "DUTCH"
```

Set `plain_text = FALSE` if your input contains HTML:

```r
cld2::detect_language(url('http://www.un.org/ar/universal-declaration-human-rights/'), plain_text = FALSE)
# [1] "ARABIC"

cld2::detect_language(url('http://www.un.org/zh/universal-declaration-human-rights/'), plain_text = FALSE)
# [1] "CHINESE"
```

Use `detect_language_multi()` to get detailed classification output.

```r
detect_language_multi(url('http://www.un.org/fr/universal-declaration-human-rights/'), plain_text = FALSE)
# $classification
#   language code latin proportion
# 1   FRENCH   fr  TRUE       0.96
# 2  ENGLISH   en  TRUE       0.03
# 3   ARABIC   ar FALSE       0.00
# 
# $bytes
# [1] 17008
# 
# $reliabale
# [1] TRUE
```
This shows the top 3 language guesses and the proportion of text that was classified as this language.
The `bytes` attribute shows the total number of text bytes that was classified, and `reliable` is a 
complex calculation on if the #1 language is some amount more probable then the second-best Language.
 
[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)

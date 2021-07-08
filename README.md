[![R-CMD-check](https://github.com/KWB-R/kwb.context/workflows/R-CMD-check/badge.svg)](https://github.com/KWB-R/kwb.context/actions?query=workflow%3AR-CMD-check)
[![pkgdown](https://github.com/KWB-R/kwb.context/workflows/pkgdown/badge.svg)](https://github.com/KWB-R/kwb.context/actions?query=workflow%3Apkgdown)
[![codecov](https://codecov.io/github/KWB-R/kwb.context/branch/main/graphs/badge.svg)](https://codecov.io/github/KWB-R/kwb.context)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/kwb.context)]()

# kwb.context

This package contains functions to get the full tree of
function calls that is evaluated when calling a function. The idea is
to reuse some of these calls with modified arguments, e.g. to replot a
specific plot that was created by an inner plot function that was
called from an outer function.

## Installation

For details on how to install KWB-R packages checkout our [installation tutorial](https://kwb-r.github.io/kwb.pkgbuild/articles/install.html).

```r
### Optionally: specify GitHub Personal Access Token (GITHUB_PAT)
### See here why this might be important for you:
### https://kwb-r.github.io/kwb.pkgbuild/articles/install.html#set-your-github_pat

# Sys.setenv(GITHUB_PAT = "mysecret_access_token")

# Install package "remotes" from CRAN
if (! require("remotes")) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# Install KWB package 'kwb.context' from GitHub
remotes::install_github("KWB-R/kwb.context")
```

## Documentation

Release: [https://kwb-r.github.io/kwb.context](https://kwb-r.github.io/kwb.context)

Development: [https://kwb-r.github.io/kwb.context/dev](https://kwb-r.github.io/kwb.context/dev)

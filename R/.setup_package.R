### How to build an R package from scratch
remotes::install_github("kwb-r/kwb.pkgbuild")

usethis::create_package(".")
fs::file_delete(path = "DESCRIPTION")


author <- list(name = "Hauke Sonnenberg",
               orcid = "0000-0001-9134-2871",
               url = "https://github.com/hsonne")

pkg <- list(name = "kwb.context",
            title = "Get the function call context and work with it",
            desc  = paste("This package contains functions to get the",
                          "full tree of function calls that is evaluated when",
                          "calling a function. The idea is to reuse some of",
                          "these calls with modified arguments, e.g.",
                          "to replot a specific plot that was created",
                          "by an inner plot function that was called from an",
                          "outer function."))


kwb.pkgbuild::use_pkg(author,
                      pkg,
                      version = "0.1.0",
                      stage = "experimental")


usethis::use_vignette("tutorial")

### R functions
if(FALSE) {
  ## add your dependencies (-> updates: DESCRIPTION)
  pkg_dependencies <- c('kwb.default', 'kwb.utils')

  sapply(pkg_dependencies, usethis::use_package)

  desc::desc_add_remotes("github::kwb-r/kwb.default",normalize = TRUE)
  desc::desc_add_remotes("github::kwb-r/kwb.utils",normalize = TRUE)
}

kwb.pkgbuild::create_empty_branch_ghpages(pkg$name)

# Set up R project with renv
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

renv::restore()
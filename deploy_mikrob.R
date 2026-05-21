# Deploy Shiny Mikrob to shinyapps.io

library(rsconnect)


rsconnect::setAccountInfo(
  name = "ikmb",
  token = "88548E134DA6AE0E5CFE520EBB2EC018",
  secret = "KN07IW8jL+jD22MfNoHRT30to3R5z/M/+e2C49yt"
)

app_dir <- "/Users/obrovkina/Documents/Projects/mikrob"
app_name <- "shiny-mikrob"

# Required app files
required_files <- c(
  "mikrob.rmd",
  "bip_logo.png"
)

# Optional bundled example input files
optional_files <- c(
  "input/ASV_table.tsv",
  "input/taxonomy_table.tsv",
  "input/metadata.csv"
)

required_exists <- file.exists(file.path(app_dir, required_files))
if (!all(required_exists)) {
  stop(
    "Missing required deploy files: ",
    paste(required_files[!required_exists], collapse = ", ")
  )
}

optional_exists <- file.exists(file.path(app_dir, optional_files))
app_files <- c(required_files, optional_files[optional_exists])

cat("Including optional input files:",
    if (any(optional_exists)) paste(optional_files[optional_exists], collapse = ", ") else "none",
    "\n")

# Stage files into a temporary deployment directory to avoid renv lockfile parsing
stage_dir <- file.path(tempdir(), paste0("mikrob_deploy_", as.integer(Sys.time())))
dir.create(stage_dir, recursive = TRUE, showWarnings = FALSE)

for (f in app_files) {
  src <- file.path(app_dir, f)
  dst <- file.path(stage_dir, f)
  dir.create(dirname(dst), recursive = TRUE, showWarnings = FALSE)
  file.copy(src, dst, overwrite = TRUE)
}

cat("Deploying from staged directory:", stage_dir, "\n")

rsconnect::deployApp(
  appDir = stage_dir,
  appName = app_name,
  appTitle = "Shiny Mikrob - Microbiome Explorer",
  account = "ikmb",
  appPrimaryDoc = "mikrob.rmd",
  appFiles = app_files,
  launch.browser = FALSE,
  forceUpdate = TRUE
)

cat("\n\n=== Checking application logs ===\n")
rsconnect::showLogs(appName = app_name, account = "ikmb")

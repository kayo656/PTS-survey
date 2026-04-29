# 00_setup.R
# Script to verify environment readiness before analysis
# Gate 0A execution for chatgpt_diagnostic_study

# 1. Project path configuration
repo_root <- here::here()
project_name <- "chatgpt_diagnostic_study"
project_root <- file.path(repo_root, "projects", project_name)

cat("\n============================================\n")
cat("Environment Setup Record: ", project_name, "\n")
cat("============================================\n")
cat("Repository root: ", repo_root, "\n")
cat("Project root:    ", project_root, "\n\n")

# 2. System and Environment Info
cat("System Information:\n")
cat("- R version: ", R.version.string, "\n")
cat("- Platform:  ", sessionInfo()$platform, "\n")
cat("- Timezone:  ", Sys.timezone(), "\n\n")

# 3. renv check
renv_path <- .libPaths()[1]
is_renv <- grepl("renv", renv_path)
cat("renv status:\n")
cat("- Active: ", is_renv, "\n")
cat("- Library: ", renv_path, "\n\n")

# 4. Mandatory package check
cat("Checking mandatory packages:\n")
required_packages <- c(
  "tidyverse", "ggplot2", "dplyr", "readr",
  "gtsummary", "WeightIt", "here"
)

missing_packages <- c()
for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(paste0("  [\u2713] ", pkg, "\n"))
  } else {
    cat(paste0("  [\u2717] ", pkg, "\n"))
    missing_packages <- c(missing_packages, pkg)
  }
}

if (length(missing_packages) > 0) {
  stop("The following packages are missing: ", paste(missing_packages, collapse = ", "), 
       ". Please run renv::restore() at the repository root.")
} else {
  cat("\nAll required packages are available.\n")
  cat("Gate 0A environment check passed. Ready to proceed to Gate 0B.\n")
}

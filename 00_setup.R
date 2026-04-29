# 00_setup.R: Environment Verification Script
# This script verifies the R environment for the Clinical Epidemiology project.

cat("--- Environment Verification Report ---\n")
cat("Generated at:", as.character(Sys.time()), "\n\n")

# 1. System Information
cat("[1] System Information\n")
cat("R version: ", R.version.string, "\n")
cat("Platform:  ", R.version$platform, "\n")
cat("Timezone:  ", Sys.timezone(), "\n\n")

# 2. renv Status
cat("[2] renv Status\n")
if (requireNamespace("renv", quietly = TRUE)) {
  project_path <- renv::project()
  if (!is.null(project_path)) {
    cat("✓ renv is active in project:", project_path, "\n")
    # renv::status() # Uncomment if full status check is needed
  } else {
    cat("! renv is NOT active in this project.\n")
  }
} else {
  cat("✗ renv package is NOT installed.\n")
}
cat("\n")

# 3. Package Availability
cat("[3] Package Availability Check\n")
pkgs <- c("tidyverse", "gtsummary", "WeightIt", "survival", "pROC", "mice", "here")
installed_pkgs <- installed.packages()[, "Package"]

for (pkg in pkgs) {
  if (pkg %in% installed_pkgs) {
    version <- packageVersion(pkg)
    cat(sprintf("✓ %-12s: Version %s\n", pkg, version))
  } else {
    cat(sprintf("✗ %-12s: NOT INSTALLED\n", pkg))
  }
}

cat("\n--- End of Report ---\n")
cat("Please share this output with Antigravity to complete Gate 0A.\n")

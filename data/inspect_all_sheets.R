# encoding: UTF-8
library(readxl)

path <- "C:/Users/lotta/OneDrive/Desktop/\u7814\u7a76/T\u8a18\u8ff0\u7d71\u8a08_\u307e\u3068\u3081 (1).xlsx"
sheets <- excel_sheets(path)

for (s in sheets) {
  cat("\n========== シート:", s, "==========\n")
  df <- tryCatch(read_excel(path, sheet = s), error = function(e) NULL)
  if (!is.null(df)) {
    cat("行数:", nrow(df), "/ 列数:", ncol(df), "\n")
    cat("列名:", paste(colnames(df), collapse = " | "), "\n")
    print(head(df, 8))
  }
}

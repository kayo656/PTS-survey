# encoding: UTF-8
tryCatch({
  if (!requireNamespace("readxl", quietly = TRUE)) {
    install.packages("readxl", repos = "https://cran.rstudio.com/")
  }
  library(readxl)

  path <- "C:/Users/lotta/OneDrive/Desktop/\u7814\u7a76/T\u8a18\u8ff0\u7d71\u8a08_\u307e\u3068\u3081 (1).xlsx"
  cat("ファイル存在確認:", file.exists(path), "\n")

  sheets <- excel_sheets(path)
  cat("シート一覧:\n")
  print(sheets)

  df <- read_excel(path, sheet = 1)
  cat("\n--- 先頭10行 ---\n")
  print(head(df, 10))
  cat("\n行数:", nrow(df), "/ 列数:", ncol(df), "\n")
  cat("列名:\n")
  print(colnames(df))
}, error = function(e) {
  cat("エラー:", conditionMessage(e), "\n")
})

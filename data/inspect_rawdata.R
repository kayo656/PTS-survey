# encoding: UTF-8
library(readxl)

path <- "C:/Users/lotta/OneDrive/Desktop/\u7814\u7a76/\u751f\u30c7\u30fc\u30bf\u3000\u990a\u6210\u6821\u5225\u4eba\u6570/\u56de\u7b54\u751f\u30c7\u30fc\u30bf.xlsx"
cat("ファイル存在確認:", file.exists(path), "\n")

sheets <- excel_sheets(path)
cat("シート一覧:\n")
print(sheets)

for (s in sheets) {
  cat("\n========== シート:", s, "==========\n")
  df <- tryCatch(read_excel(path, sheet = s), error = function(e) { cat("エラー:", conditionMessage(e), "\n"); NULL })
  if (!is.null(df)) {
    cat("行数:", nrow(df), "/ 列数:", ncol(df), "\n")
    cat("列名:\n")
    print(colnames(df))
    cat("先頭5行:\n")
    print(head(df, 5))
  }
}

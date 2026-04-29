# encoding: UTF-8
library(readxl)

path <- "C:/Users/lotta/OneDrive/Desktop/\u7814\u7a76/\u751f\u30c7\u30fc\u30bf\u3000\u990a\u6210\u6821\u5225\u4eba\u6570/\u56de\u7b54\u751f\u30c7\u30fc\u30bf.xlsx"
df <- read_excel(path, sheet = 1)

# 重要度列（Q3〜Q9）の値を確認
imp_cols <- colnames(df)[6:12]
cat("=== 重要度列のユニーク値 ===\n")
for (col in imp_cols) {
  cat(col, ":\n  ", paste(sort(unique(df[[col]])), collapse=", "), "\n")
}

cat("\n=== 利用度列のユニーク値 ===\n")
use_cols <- colnames(df)[13:19]
for (col in use_cols) {
  cat(col, ":\n  ", paste(sort(unique(df[[col]])), collapse=", "), "\n")
}

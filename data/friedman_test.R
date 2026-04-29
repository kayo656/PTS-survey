# ============================================================
# 統計解析スクリプト（解析計画書１に基づく）
# 解析：就職情報源の重要度（主要）および利用度（副次）
# 手法：Friedman検定 + Nemenyi事後検定
# ============================================================

library(readxl)
library(writexl)
library(PMCMRplus)

# --- 0. パス設定 ---
path_raw  <- "C:/Users/lotta/OneDrive/Desktop/\u7814\u7a76/\u751f\u30c7\u30fc\u30bf\u3000\u990a\u6210\u6821\u5225\u4eba\u6570/\u56de\u7b54\u751f\u30c7\u30fc\u30bf.xlsx"
out_dir   <- "C:/Users/lotta/OneDrive/Desktop/\u7814\u7a76"
out_xlsx  <- file.path(out_dir, "final_analysis_results.xlsx")

# --- 1. データ読み込みとクリーニング ---
df_raw <- read_excel(path_raw, sheet = 1)

# 計画書 2. 解析対象集団：同意あり、欠損なし
# 同意カラム（2列目）、重要度（6-12列）、利用度（13-19列）
df_cleaned <- df_raw[df_raw[[2]] == "\u540c\u610f\u3059\u308b", ]

# スコア列を数値に変換（先頭1文字）
to_numeric <- function(x) as.numeric(substr(trimws(x), 1, 1))
df_cleaned[, 6:19] <- lapply(df_cleaned[, 6:19], to_numeric)

# 欠損値除外（計画書 8. 欠損値は除外）
df_cleaned <- na.omit(df_cleaned[, c(3, 5, 6:19)])
colnames(df_cleaned)[1:2] <- c("Gender", "SNS_Time")

labels_sources <- c(
  "\u5b66\u6821\u30fb\u6559\u54e1",
  "\u81e8\u5e8a\u5b9f\u7fd2",
  "\u4eba\u7684NW",
  "\u516c\u5f0fHP",
  "\u5c31\u8077\u60c5\u5831\u30b5\u30a4\u30c8",
  "\u5c31\u8077\u8aac\u660e\u4f1a",
  "SNS"
)
colnames(df_cleaned)[3:9]  <- paste0("Imp_", labels_sources)
colnames(df_cleaned)[10:16] <- paste0("Use_", labels_sources)

n_final <- nrow(df_cleaned)
cat("Final Sample Size (N):", n_final, "\n\n")

# --- 2. 記述統計：属性（カテゴリカル） ---
calc_freq <- function(vec, var_name) {
  tbl <- table(vec)
  df <- as.data.frame(tbl)
  colnames(df) <- c("\u30ab\u30c6\u30b4\u30ea", "n")
  df$"\u5272\u5408(%)" <- round(df$n / sum(df$n) * 100, 1)
  df$"\u5909\u6570" <- var_name
  df[, c(4, 1, 2, 3)]
}

desc_gender <- calc_freq(df_cleaned$Gender, "\u6027\u5225")
desc_sns    <- calc_freq(df_cleaned$SNS_Time, "SNS\u5229\u7528\u6642\u9593")
desc_cat    <- rbind(desc_gender, desc_sns)

# --- 3. 記述統計：重要度・利用度（順序尺度） ---
make_desc_ordinal <- function(df, cols, labels, outcome_name) {
  do.call(rbind, lapply(seq_along(cols), function(i) {
    x <- df[[cols[i]]]
    data.frame(
      "\u30a2\u30a6\u30c8\u30ab\u30e0" = outcome_name,
      "\u60c5\u5831\u6e90"             = labels[i],
      "Md"                            = median(x),
      "IQR"                           = IQR(x),
      "Min"                           = min(x),
      "Max"                           = max(x),
      check.names = FALSE
    )
  }))
}

desc_imp <- make_desc_ordinal(df_cleaned, 3:9,  labels_sources, "\u91cd\u8981\u5ea6")
desc_use <- make_desc_ordinal(df_cleaned, 10:16, labels_sources, "\u5229\u7528\u5ea6")
desc_ord <- rbind(desc_imp, desc_use)

# --- 4. 統計解析：Friedman検定 ---
res_imp <- friedman.test(as.matrix(df_cleaned[, 3:9]))
res_use <- friedman.test(as.matrix(df_cleaned[, 10:16]))

friedman_tbl <- data.frame(
  "\u30a2\u30a6\u30c8\u30ab\u30e0" = c("\u91cd\u8981\u5ea6", "\u5229\u7528\u5ea6"),
  "chi2"                           = round(c(res_imp$statistic, res_use$statistic), 2),
  "df"                             = c(res_imp$parameter, res_use$parameter),
  "p"                              = c(res_imp$p.value, res_use$p.value),
  "\u5224\u5b9a"                    = ifelse(c(res_imp$p.value, res_use$p.value) < 0.05, "*", "ns")
)

# --- 5. 統計解析：Nemenyi事後検定 ---
run_nemenyi <- function(mat, labels, outcome_name) {
  n <- nrow(mat)
  k <- ncol(mat)
  y <- as.vector(mat)
  groups <- factor(rep(labels, each = n), levels = labels)
  blocks <- factor(rep(1:n, times = k))
  
  res <- frdAllPairsNemenyiTest(y = y, groups = groups, blocks = blocks)
  pmat <- res$p.value
  
  idx <- which(lower.tri(pmat, diag = FALSE), arr.ind = TRUE)
  data.frame(
    "\u30a2\u30a6\u30c8\u30ab\u30e0" = outcome_name,
    "\u6bd4\u8f03A"                  = labels[idx[, 2]],
    "\u6bd4\u8f03B"                  = labels[idx[, 1]],
    "p_Nemenyi"                      = pmat[idx],
    "\u5224\u5b9a"                   = ifelse(pmat[idx] < 0.05, "*", "ns"),
    check.names = FALSE
  )
}

post_imp <- run_nemenyi(as.matrix(df_cleaned[, 3:9]),  labels_sources, "\u91cd\u8981\u5ea6")
post_use <- run_nemenyi(as.matrix(df_cleaned[, 10:16]), labels_sources, "\u5229\u7528\u5ea6")
post_all <- rbind(post_imp, post_use)

# --- 6. 結果の保存 ---
write_xlsx(list(
  "\u5c5e\u6027\u8a18\u8ff0"     = desc_cat,
  "\u30b9\u30b3\u30a2\u8a18\u8ff0" = desc_ord,
  "Friedman\u691c\u5b9a"      = friedman_tbl,
  "Nemenyi\u4e8b\u5f8c\u691c\u5b9a" = post_all
), path = out_xlsx)

cat("Analysis complete. Results saved to:", out_xlsx, "\n")

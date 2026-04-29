# 01_data_cleaning.R
library(tidyverse)
library(readxl)

cat("--- Processing Data ---\n")
raw_data_path <- "../../../回答生データ.xlsx"
df_raw <- read_excel(raw_data_path, sheet = 1)

# 数値化関数の強化
to_num <- function(x) {
  case_when(
    str_detect(x, "とても|非常に|非常") ~ 6,
    str_detect(x, "重要$|利用した$") ~ 5,
    str_detect(x, "どちらかといえば|やや") ~ 4,
    str_detect(x, "あまり") ~ 3,
    str_detect(x, "ほとんど|ではない") ~ 2,
    str_detect(x, "まったく|全く") ~ 1,
    TRUE ~ as.numeric(NA)
  )
}

# 列を番号で指定
df_analyzed <- df_raw %>%
  mutate(across(everything(), str_trim)) %>%
  mutate(
    imp_school  = to_num(.[[3]]),  imp_cl_prac = to_num(.[[4]]),
    imp_friends = to_num(.[[5]]),  imp_hp      = to_num(.[[6]]),
    imp_site    = to_num(.[[7]]),  imp_event   = to_num(.[[8]]),
    imp_sns     = to_num(.[[9]]),
    use_school  = to_num(.[[10]]), use_cl_prac = to_num(.[[11]]),
    use_friends = to_num(.[[12]]), use_hp      = to_num(.[[13]]),
    use_site    = to_num(.[[14]]), use_event   = to_num(.[[15]]),
    use_sns     = to_num(.[[16]])
  )

dir.create("../data/processed", recursive = TRUE, showWarnings = FALSE)
saveRDS(df_analyzed, "../data/processed/cleaned_data.rds")
cat("Success: n =", nrow(df_analyzed), "\n")

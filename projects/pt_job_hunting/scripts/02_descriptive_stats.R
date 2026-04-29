# 02_descriptive_stats.R
if (!require(openxlsx)) install.packages("openxlsx")
library(tidyverse)
library(openxlsx)

df <- readRDS("../data/processed/cleaned_data.rds")

# 集計
summarize_scores <- function(data, prefix, cat_name) {
  data %>%
    select(starts_with(prefix)) %>%
    pivot_longer(everything()) %>%
    group_by(name) %>%
    summarise(Median = median(value, na.rm = TRUE),
              Q1 = quantile(value, 0.25, na.rm = TRUE),
              Q3 = quantile(value, 0.75, na.rm = TRUE)) %>%
    mutate(Category = cat_name)
}

res <- bind_rows(
  summarize_scores(df, "imp_", "Importance"),
  summarize_scores(df, "use_", "Usage")
)

# 保存先
dir.create("../output/tables", recursive = TRUE, showWarnings = FALSE)
write.xlsx(res, "../output/tables/summary_results.xlsx")

# グラフ
p <- res %>%
  filter(Category == "Importance") %>%
  mutate(source_label = case_when(
    str_detect(name, "school") ~ "School",
    str_detect(name, "cl_prac") ~ "Practice",
    str_detect(name, "friends") ~ "Network",
    str_detect(name, "hp") ~ "HP",
    str_detect(name, "site") ~ "JobSite",
    str_detect(name, "event") ~ "Event",
    str_detect(name, "sns") ~ "SNS",
    TRUE ~ name
  )) %>%
  ggplot(aes(x = reorder(source_label, Median), y = Median)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_errorbar(aes(ymin = Q1, ymax = Q3), width = 0.2) +
  coord_flip() + labs(title = "Importance of Information Sources") + theme_minimal()

dir.create("../output/figures", recursive = TRUE, showWarnings = FALSE)
ggsave("../output/figures/importance_plot.png", p, width = 8, height = 5)

cat("\n--- All Done! Please check summary_results.xlsx ---\n")

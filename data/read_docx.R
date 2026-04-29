if (!requireNamespace("officer", quietly = TRUE)) {
  install.packages("officer", repos = "https://cran.rstudio.com/")
}
library(officer)

doc <- read_docx("C:/Users/lotta/OneDrive/Desktop/\u7814\u7a76/\u89e3\u6790\u8a08\u753b\u66f8\uff11_copy.docx")
txt <- docx_summary(doc)
cat(paste(txt$text, collapse = "\n"))

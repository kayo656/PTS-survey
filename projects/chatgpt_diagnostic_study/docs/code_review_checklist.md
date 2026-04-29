# Code Review Checklist

**Project**: ChatGPT Diagnostic Accuracy Study  
**SAP Version**: 2.0  
**Date**: 2026-04-12

## Pre-Implementation Review

- [ ] SAP承認済み（ユーザー署名・日付）
- [ ] 全データファイルの行数・列数がSAP Section 4と一致
- [ ] 使用パッケージが環境にインストール済み (`tidyverse`, `pROC`, `irr` or `psych`)
- [ ] `renv` で依存関係がロック済み

## Data Import and Processing (Section 7)

- [ ] `chatgpt_cases_cleaned.csv` → 150行
- [ ] `diagnostic_accuracy_600.csv` → 600行
- [ ] `all_reviews.csv` → 300行
- [ ] 型変換が仕様通り（factor levels, ordered factor）
- [ ] 欠損値なし を確認（or 除外ケース数をログ記録）
- [ ] データ整合性チェック全項目 PASS

## Primary Analysis (Section 10)

- [ ] Case Accuracy = 74/150 (49.3%) ±1% と一致
- [ ] Figure 1: 棒グラフが正答/誤答を正しく表示

## Secondary Analyses (Section 11)

### Diagnostic Accuracy (11.1)

- [ ] 混同行列: TP=73, FP=77, TN=373, FN=77 と一致（±許容範囲内）
- [ ] Overall Accuracy = 74%
- [ ] Precision = 48.67%
- [ ] Sensitivity = 48.67%
- [ ] Specificity = 82.89%
- [ ] Figure 2: ヒートマップが2×2を正しく表示

### ROC / AUC (11.2)

- [ ] AUC = 0.66 ±0.02
- [ ] 95% CI が算出されている
- [ ] Figure 3: ROC曲線にchance lineとAUC値が表示

### Descriptive (11.4, 11.5)

- [ ] 認知負荷の度数: Low ≈77–78, Moderate=61, High=11
- [ ] 医学情報品質の度数: Complete/Relevant=78, Incomplete/Relevant=64, Incomplete/Irrelevant=8, Complete/Irrelevant=0
- [ ] Figure 4 & 5: 棒グラフが正しいカテゴリ・度数を表示

### Inter-rater Reliability (11.6)

- [ ] Kappa (Diagnostic Accuracy) ≈ 0.78 ±0.05
- [ ] Kappa (Cognitive Load) ≈ 0.64 ±0.05
- [ ] Kappa (Quality) ≈ 1.0

## Reproducibility (Section 14)

- [ ] スクリプトが番号順に `scripts/` に配置
- [ ] Figure出力: PNG (300 dpi) + PDF の両方が `output/figures/` に存在
- [ ] Table出力が `output/tables/` に存在
- [ ] `output/session_info.txt` が生成されている
- [ ] `run_all.R` が全スクリプトを順次実行可能

## Verification (code-review-companion)

- [ ] Stage A: `back_translation.md` 生成済み
- [ ] Stage A: `traceability_matrix.md` 生成済み
- [ ] Stage B: `verification_config.yml` が Appendix A のターゲット値と整合
- [ ] Stage B: `qa_inputs.json` が正しく出力される
- [ ] Stage B: `qa_report.md` の全項目が PASS
- [ ] Stage B: `sample_verification_report.md` が生成済み

## Final Sign-off

- [ ] 全チェック項目が完了
- [ ] Decision Log に未解決項目なし (D-6 含む)
- [ ] レビュアー署名・日付

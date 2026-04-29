# Statistical Analysis Plan

**Project**: ChatGPT Diagnostic Accuracy Study — Reproduction Analysis  
**Version**: 2.0  
**Original Paper**: Hadi A, Tran E, Nagarajan B, Kirpalani A. Evaluation of ChatGPT as a diagnostic tool for medical learners and clinicians. *PLOS ONE*. 2024;19(7):e0307383. DOI: [10.1371/journal.pone.0307383](https://doi.org/10.1371/journal.pone.0307383)

---

## 1. Document Control

| 項目 | 内容 |
|------|------|
| Status | Draft — レビュー待ち |
| Version | 2.0 |
| Date | 2026-04-12 |
| Author | AI Assistant (Antigravity) |
| Approved by | *(ユーザー承認欄)* |
| Approval date | *(未定)* |

### 変更履歴

| Version | Date | Description |
|---------|------|-------------|
| 1.0 | 2026-04-10 | 初版（簡易版） |
| 2.0 | 2026-04-12 | 論文精読に基づく全面改訂。全16セクション記載。Inter-rater reliability 分析追加。定量的ターゲット値・計算式を明記 |

---

## 2. Background

ChatGPT (GPT-3.5) は400億語超のテキストで訓練された大規模言語モデル (LLM) であり、臨床教育の補助ツールとしての可能性が注目されている。本研究はChatGPTの診断精度を、Medscape Case Challenges（2021年9月〜2023年1月公開、150ケース）を用いて系統的に評価した横断研究の再現解析である。

元論文では3名の医学研修生 (A.H, B.N, E.T) が独立評価者として各ケースを評価し、Staff Physician (A.K) が全コンテンツをレビューした。本SAPでは、論文が報告した主要結果を、提供済み加工データを用いてRで再計算し、元論文の報告値と照合することを目的とする。

### 本再現解析の範囲

- **含む**: 記述統計、診断精度指標（Accuracy, Precision, Sensitivity, Specificity）、ROC/AUC、認知負荷・医学情報品質の度数分布、Inter-rater reliability（Cohen's Kappa）、主要な可視化（Figure 1–5に対応）
- **含まない**: 質的内容分析（Qualitative Content Analysis）、原文Table 2–3のテーマ分類（本データセットに含まれないため）

---

## 3. Objectives and Hypotheses

### Primary Objective

ChatGPT (GPT-3.5) の150ケースに対する**ケースレベル正答率 (Case Accuracy)** を算出し、元論文の報告値 49.3% (74/150) と照合する。

### Secondary Objectives

1. **選択肢レベルの診断精度指標**を算出する
   - Overall Accuracy, Precision, Sensitivity, Specificity
   - ROC曲線の描画とAUCの算出
2. **認知負荷 (Cognitive Load)** の分布を記述する
3. **医学情報の品質 (Quality of Medical Information)** の分布を記述する
4. **Inter-rater reliability** を Cohen's Kappa で評価する（`all_reviews.csv` を使用）

### Hypotheses

本研究は再現解析であり、特定の帰無仮説の検定を目的としない。元論文の報告値に対する一致・不一致を記述的に評価する。

---

## 4. Study Design and Data Source

### Study Design

横断的診断精度研究 (Cross-sectional diagnostic accuracy study)。ChatGPT (GPT-3.5) に対してMedscape Case Challengesのテキストをプロンプトとして入力し、4択から1つの回答を求めた。

### Data Source

元論文の報告値に基づいて生成された**合成データ（実習用データ）**を使用する。実データの精確なレコードレベル再現ではなく、論文が報告した集計レベルの結果を再現することが目標である。

### データファイル一覧

| ファイル | 行数 | 単位 | 用途 |
|---------|------|------|------|
| `data/processed/chatgpt_cases_cleaned.csv` | 150行 | 1行 = 1ケース | Primary outcome, 認知負荷, 医学情報品質 |
| `data/processed/diagnostic_accuracy_600.csv` | 600行 | 1行 = 1選択肢 (150ケース × 4選択肢) | 混同行列、診断精度指標、ROC/AUC |
| `data/processed/all_reviews.csv` | 300行 | 1行 = 1レビュー (150ケース × 2レビュアー) | Inter-rater reliability (Cohen's Kappa) |

---

## 5. Study Population

- **対象**: 150件のMedscape Case Challenges（2021年9月〜2023年1月公開分）
- **除外基準**: 画像資産（臨床画像、写真、グラフ）を含むケースは元論文で除外済み
- **特記**: ヒト被験者を対象としない。倫理審査は不要（元論文にもその旨記載あり）

---

## 6. Variables

### 6.1 Primary Outcome

| 変数名 | 列名 | 型 | 定義 | 出典ファイル |
|--------|------|----|------|-------------|
| ケースレベル正答 | `answer_correct_bool` | logical (TRUE/FALSE) | ChatGPTがそのケースで正しい選択肢を選んだか | `chatgpt_cases_cleaned.csv` |

### 6.2 Secondary Outcomes

#### 6.2.1 選択肢レベル診断結果

| 変数名 | 列名 | 型 | カテゴリ | 出典ファイル |
|--------|------|----|---------|-------------|
| 診断結果 | `diagnostic_result` | character | True Positive / False Positive / True Negative / False Negative | `diagnostic_accuracy_600.csv` |

#### 6.2.2 認知負荷

| 変数名 | 列名 | 型 | カテゴリ (順序) | 出典ファイル |
|--------|------|----|----------------|-------------|
| 認知負荷 | `cognitive_load_std` | character → ordered factor | Low < Moderate < High | `chatgpt_cases_cleaned.csv` |

#### 6.2.3 医学情報の品質

| 変数名 | 列名 | 型 | カテゴリ | 出典ファイル |
|--------|------|----|---------|-------------|
| 医学情報品質 | `quality_answer_std` | character | Complete Relevant / Incomplete Relevant / Incomplete Irrelevant / Complete Irrelevant | `chatgpt_cases_cleaned.csv` |

#### 6.2.4 Inter-rater Reliability

| 変数名 | 列名 | 型 | 用途 | 出典ファイル |
|--------|------|----|------|-------------|
| レビュアーID | `reviewer` | character (R1/R2) | Kappa算出のための評価者識別 | `all_reviews.csv` |
| 正答判定 | `answer_correct` | character (yes/no) | Kappa (diagnostic accuracy) | `all_reviews.csv` |
| 認知負荷 | `cognitive_load` | character | Kappa (cognitive load) | `all_reviews.csv` |
| 医学情報品質 | `quality_answer` | character | Kappa (quality) | `all_reviews.csv` |
| 診断精度 | `diagnostic_accuracy` | character | レビュアーごとの判定 | `all_reviews.csv` |

### 6.3 その他の変数

| 変数名 | 列名 | 型 | 定義 | 出典ファイル |
|--------|------|----|------|-------------|
| ケースID | `case_id` | integer (1–150) | ケース識別子 | 全ファイル共通 |
| ケース名 | `case_name` | character | ケースの記述名 | `chatgpt_cases_cleaned.csv` |
| 選択肢番号 | `option` | integer (1–4) | 多択選択肢の番号 | `diagnostic_accuracy_600.csv` |
| レスポンスID | `response_id` | integer (1–600) | 各選択肢応答の一意ID | `diagnostic_accuracy_600.csv` |
| レビュアー数 | `n_reviewers` | integer | 各ケースの評価者数 | `chatgpt_cases_cleaned.csv` |

---

## 7. Data Processing Plan

### 7.1 データ読み込み

- `readr::read_csv()` でUTF-8として読み込む
- 全カラムの型と欠損率を `dplyr::glimpse()` と欠損チェックで確認する

### 7.2 型変換

| 変数 | 変換内容 |
|------|---------|
| `cognitive_load_std` | `factor(..., levels = c("Low", "Moderate", "High"), ordered = TRUE)` |
| `quality_answer_std` | `factor(...)` として水準を明示設定 |
| `diagnostic_result` | `factor(...)` として TP/FP/TN/FN の4水準を設定 |

### 7.3 欠損値処理

合成データのため欠損は発生しない想定。万一発見された場合は各分析で**完全ケース分析 (complete case analysis)** を適用し、除外ケース数をログに記録する。

### 7.4 データ整合性チェック

- `chatgpt_cases_cleaned.csv` が正確に **150行** であること
- `diagnostic_accuracy_600.csv` が正確に **600行** (150 × 4) であること
- `all_reviews.csv` が正確に **300行** (150 × 2) であること
- `diagnostic_accuracy_600.csv` の各 `case_id` に対して **4つの選択肢** が存在すること
- 各ケースにおいて、TP + FN = 1（正答は1つ）、FP + TN = 3（誤答は3つ）であること（ケースが正答の場合）

---

## 8. Statistical Principles

### 8.1 解析方法の性質

本研究は主に**記述統計**による再現解析である。推測統計は使用しない（仮説検定なし）。

### 8.2 報告形式

- カテゴリ変数: 度数 n と割合 % を報告（小数点以下2桁、%）
- 連続値: AUC等は小数点以下2桁で報告
- 信頼区間: AUCに対して95% CIを報告（可能な場合）
- 結果には元論文の報告値を併記し、一致を確認する

### 8.3 ソフトウェア

| 項目 | 仕様 |
|------|------|
| 言語 | R (version ≥ 4.5) |
| 主要パッケージ | `tidyverse`, `ggplot2`, `pROC`, `irr` |
| パイプスタイル | `|>` (base pipe) で統一 |
| 乱数シード | `set.seed(123)` (ROC CI等で必要な場合) |

### 8.4 ガードレール（`analysis-guardrails` 準拠）

- 結果の捏造・計算出力なしの有意性主張を行わない
- データからカテゴリを確認してからコーディングする
- 確認的・感度・探索的の区別を明確にする

---

## 9. Descriptive and Exploratory Analyses

### 9.1 ケースレベル概要

- `chatgpt_cases_cleaned.csv` の全変数について基本統計量を算出
- 正答 vs 誤答のケース数を集計

### 9.2 認知負荷の分布

- Low / Moderate / High の度数 (n) と割合 (%) を表で報告
- **ターゲット値**: Low 77 (51%), Moderate 61 (41%), High 11 (7%)

> [!NOTE]
> 論文本文中の認知負荷の報告値に軽微な不一致がある（Abstract: Low 77 (51%), Results: Low 78 (52%)）。結果セクションの値（78/150）を優先ターゲットとする。データの実測値がいずれとも異なる場合はDecision Logに記録する。

### 9.3 医学情報の品質分布

- Complete/Relevant, Incomplete/Relevant, Incomplete/Irrelevant, Complete/Irrelevant の度数 (n) と割合 (%) を表で報告
- **ターゲット値**: Complete/Relevant 78 (52%), Complete/Irrelevant 0 (0%), Incomplete/Relevant 64 (43%), Incomplete/Irrelevant 8 (5%)

---

## 10. Primary Analysis

### 10.1 ケースレベル正答率 (Case Accuracy)

**定義**:

$$
\text{Case Accuracy} = \frac{\sum \text{answer\_correct\_bool} = \text{TRUE}}{N_{\text{cases}}}
$$

**計算手順**:
1. `chatgpt_cases_cleaned.csv` を読み込む
2. `answer_correct_bool == TRUE` のケース数をカウントする
3. 総ケース数 (N = 150) で割って割合を算出する

**ターゲット値**: 74/150 = 49.3%

**補足指標**: 
- Medscapeユーザー多数派と一致したケースの割合: 92/150 = 61%（データに列がある場合のみ）

### 10.2 可視化 (Figure 1対応)

**棒グラフ**: 正答 vs 誤答の割合を示す棒グラフ
- x軸: 結果カテゴリ（Correct / Incorrect）
- y軸: 割合 (%)
- ラベル: n と % を棒上に表示

---

## 11. Secondary Analyses

### 11.1 選択肢レベル混同行列と診断精度指標

**データソース**: `diagnostic_accuracy_600.csv`

**手順**:
1. `diagnostic_result` の度数を集計し、混同行列を構築する
2. 以下の指標を算出する

| 指標 | 計算式 | ターゲット値 |
|------|--------|-------------|
| True Positive (TP) | `sum(diagnostic_result == "True Positive")` | 73/600 (12%) |
| False Positive (FP) | `sum(diagnostic_result == "False Positive")` | 77/600 (13%) |
| True Negative (TN) | `sum(diagnostic_result == "True Negative")` | 373/600 (62%) |
| False Negative (FN) | `sum(diagnostic_result == "False Negative")` | 77/600 (13%) |
| Overall Accuracy | (TP + TN) / Total | 74% (446/600) |
| Precision | TP / (TP + FP) | 48.67% |
| Sensitivity | TP / (TP + FN) | 48.67% |
| Specificity | TN / (TN + FP) | 82.89% |

> [!NOTE]
> 論文Discussion (p.10) ではTP=73, Results (p.9) ではTP=73と記載。ただしPrecision=48.67%, Sensitivity=48.67%の報告値からは TP=FN が成り立つ（73=73 or 77=77）。データの実測値で確定し、Logに記録する。

### 11.2 ROC曲線 / AUC (Figure 3対応)

**手順**:
1. `diagnostic_accuracy_600.csv` から各選択肢の二値化ラベルを作成
   - 正例 (Positive) = TP or FN → その選択肢が正答
   - ChatGPT予測 (Predicted Positive) = TP or FP → ChatGPTがその選択肢を支持
2. `pROC::roc()` でROC曲線を計算
3. `pROC::auc()` でAUCを算出
4. 95% CIをブートストラップ法で算出（`set.seed(123)` 使用）

**ターゲット値**: AUC = 0.66

**可視化**: ROC曲線をプロットし、対角線（chance line）、AUC値、95% CIを注記

> [!IMPORTANT]
> ROC/AUCの算出には、二値化した真のラベル（actual）とChatGPTの予測スコア/ラベル（predicted）が必要。`diagnostic_accuracy_600.csv` の `diagnostic_result` からこれらを導出する方法を実装時に確定する。

### 11.3 混同行列の可視化 (Figure 2対応)

**ヒートマップ**: `ggplot2::geom_tile()` による2×2混同行列
- 軸: Predicted (Positive/Negative) × Actual (Positive/Negative)
- セル値: 度数と割合

### 11.4 認知負荷の可視化 (Figure 4対応)

**棒グラフ**: Low / Moderate / High の度数分布
- x軸: Cognitive Load カテゴリ
- y軸: 度数 (n) と割合 (%)

### 11.5 医学情報品質の可視化 (Figure 5対応)

**棒グラフ**: 4カテゴリの度数分布
- x軸: Quality カテゴリ
- y軸: 度数 (n) と割合 (%)

### 11.6 Inter-rater Reliability (Cohen's Kappa)

**データソース**: `all_reviews.csv` (300行 = 150ケース × 2レビュアー)

**手順**:
1. `all_reviews.csv` を読み込む
2. ワイド形式に変換（case_name をキー、reviewer R1 / R2 を列に展開）
3. 以下の3アウトカムについてCohen's Kappaを算出:

| アウトカム | 変数 | ターゲット Kappa |
|-----------|------|-----------------|
| Diagnostic Accuracy | `answer_correct` or `diagnostic_accuracy` | 0.78 (substantial) |
| Cognitive Load | `cognitive_load` | 0.64 (substantial) |
| Quality of Medical Information | `quality_answer` | 1.0 (perfect) |

**使用関数**: `irr::kappa2()` または `psych::cohen.kappa()`

**Kappa解釈基準 (Landis & Koch)**:

| Kappa | Agreement |
|-------|-----------|
| < 0.20 | Poor |
| 0.21–0.40 | Fair |
| 0.41–0.60 | Moderate |
| 0.61–0.80 | Substantial |
| 0.81–1.00 | Almost perfect / Perfect |

---

## 12. Subgroup Analyses

元論文ではサブグループ解析は実施していない。本再現解析でも計画しない。

---

## 13. Sensitivity Analyses

元論文では明示的な感度分析は報告していない。本再現解析でも計画しない。

### 探索的分析の可能性（オプション）

以下は計画時点では確定しないが、主要解析完了後にユーザーの判断で実施可能とする:

- 認知負荷レベル別の正答率のクロス集計
- 医学情報品質カテゴリ別の正答率のクロス集計

> [!NOTE]
> これらを実施する場合、探索的分析として明確にラベルし、主要結果とは区別する。

---

## 14. Reproducibility and Code Operations

### 14.1 プロジェクト構造 (`reproducibility-standards` 準拠)

```
projects/chatgpt_diagnostic_study/
├── docs/
│   ├── statistical_analysis_plan.md   ← 本文書
│   ├── paper.txt                      ← 参照論文テキスト
│   └── code_review_checklist.md
├── data/
│   └── processed/
│       ├── chatgpt_cases_cleaned.csv
│       ├── diagnostic_accuracy_600.csv
│       └── all_reviews.csv
├── scripts/
│   ├── _project_config.R             ← パス定義のみ
│   ├── 00_setup.R                    ← パッケージ読込
│   ├── 01_import_data.R              ← データ読込・型変換・整合性チェック
│   ├── 02_primary_analysis.R         ← ケースレベル正答率
│   ├── 03_diagnostic_accuracy.R      ← 混同行列・精度指標
│   ├── 04_roc_auc.R                  ← ROC曲線・AUC
│   ├── 05_descriptive_analysis.R     ← 認知負荷・品質分布
│   ├── 06_interrater_reliability.R   ← Cohen's Kappa
│   ├── 07_create_figures.R           ← 全Figureの出力
│   ├── 08_create_tables.R            ← 全Tableの出力
│   ├── run_all.R                     ← 一括実行 + qa_inputs.json 出力
│   └── 99_verify_data.R              ← 検証スクリプト
├── output/
│   ├── figures/                      ← PNG (300 dpi) + PDF
│   ├── tables/                       ← CSV / Markdown
│   ├── session_info.txt
│   └── verification/
│       ├── back_translation.md       ← Stage A
│       ├── traceability_matrix.md    ← Stage A
│       ├── qa_inputs.json            ← Stage B
│       ├── qa_report.md              ← Stage B
│       └── sample_verification_report.md ← Stage B
├── verification_config.yml
└── README.md
```

### 14.2 スクリプト命名規約

- `[NN]_<verb>_data.R` — データ処理
- `[NN]_<analysis>_analysis.R` — 分析
- `[NN]_create_<target>.R` — 可視化・表
- `utils_<module>.R` — ユーティリティ関数

### 14.3 Figure出力

- PNG (300 dpi) および PDF の両方を `output/figures/` に保存
- `ggsave()` を使用し、幅・高さを統一設定

### 14.4 セッション情報

- `output/session_info.txt` に R version、platform、package versions を記録
- `run_all.R` 末尾の `sessionInfo()` 出力で生成

### 14.5 コードスタイル (`reproducibility-standards` 準拠)

- snake_case 命名
- `|>` base pipe統一
- 日本語コメントは「ロジックが自明でない箇所」に限定
- `set.seed(123)` を乱数使用箇所に設定

### 14.6 検証ワークフロー (`code-review-companion` 準拠)

- **Stage A (静的)**: スクリプト出力時に `back_translation.md` と `traceability_matrix.md` を生成
- **Stage B (実行後)**: `run_all.R` が `qa_inputs.json` を書き出し、`99_verify_data.R` が QA レポート・検証レポートを生成

### 14.7 データプライバシー (`data-privacy-handling` 準拠)

- 本プロジェクトの合成データは機密性なし（Medscape公開ケースに基づく）
- 個人情報は含まれない
- `.gitignore` に `data/private/` を含めるが、本プロジェクトでは使用しない

---

## 15. References

1. Hadi A, Tran E, Nagarajan B, Kirpalani A. Evaluation of ChatGPT as a diagnostic tool for medical learners and clinicians. *PLOS ONE*. 2024;19(7):e0307383. https://doi.org/10.1371/journal.pone.0307383
2. Deeks JJ, Altman DG, Gatsonis C. Cochrane handbook for systematic reviews of diagnostic test accuracy. *Cochrane Books*. 2004.
3. Paas F, van Merriënboer JJ. Cognitive-load theory: Methods to manage working memory load in the learning of complex tasks. *Current Directions in Psychological Science*. 2020;29(4):394–8.
4. Demner-Fushman D, Lin J. Answering clinical questions with knowledge-based and statistical techniques. *Computational Linguistics*. 2007;33(1):63–103.
5. Landis JR, Koch GG. The measurement of observer agreement for categorical data. *Biometrics*. 1977;33(1):159–74.

---

## 16. Decision Log

| # | Date | Decision | Rationale | Status |
|---|------|----------|-----------|--------|
| D-1 | 2026-04-12 | 質的内容分析 (Content Analysis) を再現範囲から除外 | 元論文Table 2–3のテーマ論的分析はテキストデータの質的評価であり、加工済データにコード化されていない | Settled |
| D-2 | 2026-04-12 | Inter-rater reliability (Cohen's Kappa) を再現範囲に**含める** | `all_reviews.csv` (300行) にR1/R2のレビューデータが含まれており算出可能。元論文Fig 5で報告。v1.0では除外していたが修正 | Settled |
| D-3 | 2026-04-12 | 認知負荷の報告値不一致への対応 | AbstractではLow=77(51%), ResultsではLow=78(52%)と記載に揺れがある。データ実測値を採用し、元論文との差異をログに記録する | Settled |
| D-4 | 2026-04-12 | ROC/AUCの実装方法 | `diagnostic_result` から二値ラベル (actual/predicted) を導出。actual = (TP or FN → 1, otherwise 0), predicted = (TP or FP → 1, otherwise 0) として `pROC::roc()` に渡す | Settled |
| D-5 | 2026-04-12 | Sensitivity / Subgroup analyses は「計画しない」と明記 | 元論文でも未実施。探索的分析はオプションとして記載のみ | Settled |
| D-6 | 2026-04-12 | Cohen's Kappa算出パッケージの選択 | `irr::kappa2()` を第一候補とする。インストール困難な場合は `psych::cohen.kappa()` を代替とする | **Pending** — 環境確認後に確定 |

---

## Appendix A: ターゲット値一覧（検証用）

本SAPで照合する元論文の報告値をまとめる。`verification_config.yml` 作成時の参照表。

| Analysis | Metric | Target Value | Tolerance | Source |
|----------|--------|-------------|-----------|--------|
| Primary | case_accuracy_pct | 49.3% (74/150) | ±1% | Abstract, Results |
| Secondary | n_tp | 73 | 0 | Results |
| Secondary | n_fp | 77 | 0 | Results |
| Secondary | n_tn | 373 | 0 | Results |
| Secondary | n_fn | 77 | 0 | Results |
| Secondary | overall_accuracy_pct | 74% | ±1% | Results, Discussion |
| Secondary | precision_pct | 48.67% | ±1% | Discussion |
| Secondary | sensitivity_pct | 48.67% | ±1% | Discussion |
| Secondary | specificity_pct | 82.89% | ±1% | Discussion |
| Secondary | auc | 0.66 | ±0.02 | Results, Discussion |
| Descriptive | cognitive_load_low_n | 77 or 78 | ±1 | Abstract vs Results |
| Descriptive | cognitive_load_moderate_n | 61 | 0 | Results |
| Descriptive | cognitive_load_high_n | 11 | 0 | Results |
| Descriptive | quality_complete_relevant_n | 78 | 0 | Results |
| Descriptive | quality_incomplete_relevant_n | 64 | 0 | Results |
| Descriptive | quality_incomplete_irrelevant_n | 8 | 0 | Results |
| Descriptive | quality_complete_irrelevant_n | 0 | 0 | Results |
| Inter-rater | kappa_diagnostic_accuracy | 0.78 | ±0.05 | Results |
| Inter-rater | kappa_cognitive_load | 0.64 | ±0.05 | Results |
| Inter-rater | kappa_quality | 1.0 | 0 | Results |

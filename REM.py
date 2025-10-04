import pandas as pd
import numpy as np
from pathlib import Path
from google.colab import drive
import matplotlib.pyplot as plt

drive.mount('/content/drive')

FILE_PATH = "/content/drive/MyDrive/Colab Notebooks/PaySim.csv"

# 데이터 전처리
df = pd.read_csv(FILE_PATH, low_memory=False)
df.columns = [c.lower() for c in df.columns]

# 스냅샷: 관측 종료 시점 다음 시간
snapshot_step = df["step"].max() + 1

# 고객별 R/F/M 집계
base = (df.groupby("nameorig", as_index=False)
          .agg(last_step=("step","max"),
               frequency=("step","count"),
               monetary=("amount","sum")))

# Recency: 최근 활동 경과시간(시간/일)
base["recency_hours"] = snapshot_step - base["last_step"]
base["recency_days"]  = base["recency_hours"] / 24.0


# 분위수 스코어링 보조 함수 (동일값·소표본 안전)
def safe_qcut(series, q=5, labels=None):
    uniq = series.dropna().unique()
    bins = min(q, len(uniq)) if len(uniq) > 0 else 1
    if bins < 2:
        if labels is None:
            return pd.Series(np.repeat(3, len(series)), index=series.index)
        middle = labels[(len(labels)-1)//2]
        return pd.Series(np.repeat(middle, len(series)), index=series.index)
    return pd.qcut(series, bins, labels=labels, duplicates="drop")

# R(작을수록 좋음): 5~1, F/M(클수록 좋음): 1~5
base["R_score"] = safe_qcut(base["recency_hours"], q=5, labels=[5,4,3,2,1]).astype(int)
base["F_score"] = safe_qcut(base["frequency"].rank(method="first"), q=5, labels=[1,2,3,4,5]).astype(int)
base["M_score"] = safe_qcut(base["monetary"].rank(method="first"),  q=5, labels=[1,2,3,4,5]).astype(int)

base["RFM"] = base["R_score"].astype(str) + base["F_score"].astype(str) + base["M_score"].astype(str)

# 결과 정리
rfm = (base.rename(columns={"nameorig":"customer_id"})
            [["customer_id","recency_days","frequency","monetary",
              "R_score","F_score","M_score","RFM"]]
            .sort_values(["R_score","F_score","M_score","monetary"],
                         ascending=[False,False,False,False]))

# 간략화
rem = (rfm[['customer_id','recency_days','frequency','monetary']]
       .rename(columns={'recency_days':'R','frequency':'E','monetary':'M'}))

# 시각화

plt.figure(figsize=(7,5))
plt.hist(rem["R"].dropna(), bins=50)
plt.xlabel("R (Recency, days)")
plt.ylabel("Count")
plt.title("R Distribution (Histogram)")
plt.grid(True)
plt.tight_layout()
plt.show()

plt.figure(figsize=(7,5))
plt.hist(rem["E"].dropna(), bins="auto")
plt.xscale("log")  # 빈도는 한쪽으로 치우치므로 로그축이 해석 쉬움
plt.xlabel("E (Frequency, log-scale)")
plt.ylabel("Count")
plt.title("E Distribution (Histogram)")
plt.grid(True)
plt.tight_layout()
plt.show()

plt.figure(figsize=(6,4))
plt.boxplot(np.log10(rem['M'].clip(lower=1)).dropna(), vert=True, showfliers=False)
plt.title("M Boxplot (log10 scaled)"); plt.ylabel("log10(M)")
plt.tight_layout(); plt.show()

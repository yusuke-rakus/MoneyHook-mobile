# MoneyHooks-mobile

Flutter を用いた家計簿アプリケーションです。

## 概要

毎月自由に使っても良いお金と、家賃や食費などの固定費を分けて一覧で見れたら便利だなと思い開発に入りました

## 目的

「家計簿機能」、「したつもり貯金機能」を利用できる。家計の貸借対照表や損益計算書などの財務分析が行える。

## 機能について

### ホーム画面

カテゴリ毎にまとまったデータを確認できる。また、カテゴリ毎に合計金額をグラフに表示し、支出割合を確認する画面

![Home](https://user-images.githubusercontent.com/93502995/235337363-b97647f2-9c74-4ad4-a809-4907f510a564.png)

### タイムライン画面

日付順にソートされた収支データを確認できる。また、月別の合計支出を棒グラフで表示し、毎月の支出総額の比較を確認できる画面

![Timeline](https://user-images.githubusercontent.com/93502995/235337378-ab6531c5-42dd-4807-9320-94490f6f8652.png)

### 入力画面

収支データの入力を行う。「固定費として計算する」ボタン押下で固定支出/変動支出の振り分けを行う

![TransactionInput](https://user-images.githubusercontent.com/93502995/235337395-f7b79dc4-bc09-4196-9ba7-352482912c6b.png)

### 変動費分析画面

固定費として計算しないデータを対象に集計を行う。カテゴリ・サブカテゴリ毎に集計を行い、データの確認を行う画面

![MonthlyVariable](https://user-images.githubusercontent.com/93502995/235337408-61594758-5436-4602-a968-c86191cc8d8a.png)

### 固定費画面

収入から固定費として計算するデータを差し引き、自由に使える金額の確認が可能

![MonthlyFixed](https://user-images.githubusercontent.com/93502995/235337449-a5983744-94c5-4995-abb3-ed664bf3d9a8.png)

### 貯金一覧画面

「一駅歩いた」「無駄遣いを我慢した」「安いプランを探して節約できた」など、浮いたお金を集計できる機能

![SavingList](https://user-images.githubusercontent.com/93502995/235337430-737604b9-0cbc-431a-85d3-6a87b8524fea.png)

### 貯金総額画面

累計の貯金額が確認できる画面。また、貯金目標の登録・貯金目標への積立も可能

![TotalSaving](https://user-images.githubusercontent.com/93502995/235337435-494efde9-9117-492a-b956-90a64d7c35dc.png)

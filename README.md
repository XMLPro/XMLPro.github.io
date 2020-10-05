# 記事の作成からデプロイまでの流れ

## リポジトリのクローン(初回のみ)
```bash
git clone https://github.com/XMLPro/XMLPro.github.io
```

##  hugoのインストール

公式のドキュメントを参考にローカルにhugoをインストールしてください
(https://gohugo.io/getting-started/installing/)[https://gohugo.io/getting-started/installing/]


## ブランチの用意

### 初回

ブランチを切ってそこで作業をしてmasterにPRを出しましょう。ブランチ名は任意ですが、わかりやすいものを書きましょう

```bash
git checkout -b 任意のブランチ名
```

## 2回目以降

作業用ブランチにいることを確認してください。

```bash
git pull origin master
```

## 記事の作成

ブログ記事、XMLProに関するニュース、その他投稿の3種類の記事をマークダウンで書くことが出来ます。`new.sh`を実行することでファイルを作成し、そこに記事を書いてください。

### ブログ

```bash
./new.sh blogs  
```

### XMLProに関するニュース

```bash
./new.sh news
```

### その他の投稿

```bash
./new.sh posts
```

### 書いた記事のローカルでの確認

`hugo server -D`で[localhost:1313](localhost:1313)にローカルサーバーがたつのでそこで表示を確認してください。

## デプロイ

記事を書いたら、記事のfront matterのdraftという項目がfalseになっていることを確認して、以下のコマンドを叩いてください。

```bash
git push origin 自分のブランチ名
```

あとはmasterブランチに向けてPRをだし、誰かにレビューをしてもらいましょう。

masterブランチにマージすると、[https://xmlpro.github.io](https://xmlpro.github.io)が更新されます。
---
title: "新1年生への挑戦状の解答・解説" # タイトル
date: "2021-04-07" # 2020-10-23 のようなフォーマットで設定してください
description: "2021年新入生歓迎会の問題の解答・解説です" # ページの説明
categories:
  - "新入生歓迎会2021"
tags:
  - "CTF"
  - "Crypto"

thumbnail: "" # サムネイルのurl staticからの相対パスを指定してください
lead: "2021年新入生歓迎会の問題の解答・解説です" # リード文
comments: true
authorbox: false
pager: true
toc: true
mathjax: true
sidebar: "right"
widgets:
  - "search"
  - "recent"
  - "taglist"
draft: false
---

# 新1年生への挑戦状の解答・解説

みなさんこの度は2021年新入生歓迎会にご参加いただきありがとうございました！
新1年生への挑戦状と題して、CTFの問題をホストしておりました。以下から解けます。
https://xmlpro.github.io/news/2021-04-01-2322/

今日はその解答、解説をしようと思います。

### Forensics

zipファイルにはコメントが付けられます。zipinfoやzipnoteコマンドを使うことで閲覧できます。

![](./answer1.png)

したがって`We1c0me_t0_CTFW0r1d`が答えとなります。

### crypto

zipファイルを解凍して出てくるテキストはbase64というエンコード方式でエンコードされた文字列です。
したがって、base64でデコードしてやればいいです。
ちなみに合計14回base64でエンコードされています。ひたすらデコードします。
cyberchefというオンラインで使える便利なツールがあるので自分はそれを利用しています。
https://gchq.github.io/CyberChef/

14回base64すると以下のような文字列が出てきます。

```
Pbatenghyngvbaf!!!
Gur synt vf kzyceb{kzyce0_4j3f0z3_uNpx3e}

ようこそKZYCebへ！
KZYCebは技術好きが集まるサークルです。オンラインで集まって競技プログラミングをしたりしています。
「プログラミングおもしろそう！」「Unpxreになりたい！」
そんな人とぜひとも活動したいなと思っています！
あなたの今のスキルは問いません。熱い気持ちだけお持ちになっていらしてください！

詳細は以下のサイトから
KZYCeb: uggcf://kzyceb.tvguho.vb

ご連絡は以下から
GjvggreのQZ、もしくはQvfpbeqの招待リンクからサーバーに入り、管理者もしくは在学生ロールがついているユーザーにお声がけください
Gjvggre: uggcf://gjvggre.pbz/kzyceb_ghg
Qvfpbeq: uggcf://qvfpbeq.tt/weW3mJceg2
```

ここまで来ればあともう1歩です。上の文は英字だけ判読不能になっています。これはシーザー暗号というアルファベットを13字進めるという暗号方式です。したがってアルファベットを13字進めるだけでもとに戻せます。戻したものが以下になります。

```
Congratulations!!!
The flag is xmlpro{xmlpr0_4w3s0m3_hAck3r}

ようこそXMLProへ！
XMLProは技術好きが集まるサークルです。オンラインで集まって競技プログラミングをしたりしています。
「プログラミングおもしろそう！」「Hackerになりたい！」
そんな人とぜひとも活動したいなと思っています！
あなたの今のスキルは問いません。熱い気持ちだけお持ちになっていらしてください！

詳細は以下のサイトから
XMLPro: https://xmlpro.github.io

ご連絡は以下から
TwitterのDM、もしくはDiscordの招待リンクからサーバーに入り、管理者もしくは在学生ロールがついているユーザーにお声がけください
Twitter: https://twitter.com/xmlpro_tut
Discord: https://discord.gg/jrJ3zWprt2
```

したがってフラグは`xmlpr0_4w3s0m3_hAck3r`です。

### 最後に

改めまして参加とご解答ありがとうございました。
XMLProではCTFを活動の一環として行っています。もっといろんな問題に触れてみたいという人はぜひともXMLProにいらしてください！
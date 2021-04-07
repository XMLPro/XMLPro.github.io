---
title: "新1年生への挑戦状" # タイトル
date: "2021-04-1" # 2020-10-23 のようなフォーマットで設定してください
description: "2021年度新入生歓迎会特設ページです" # ページの説明
categories:
  - "新入生歓迎会2021"
tags:
  - "CTF"
  - "Crypto"

thumbnail: "images/2021-04-01-2322/thumbnail.png" # サムネイルのurl staticからの相対パスを指定してください
lead: "新入生歓迎会用の特設サイトです" # リード文
comments: true
authorbox: false
pager: true
toc: true
mathjax: true
sidebar: "right"
widgets: # サイドバーの表示項目
  - "search"
  - "recent"
  - "taglist"
draft: false # 記事を公開する場合falseに設定してください
---
# 新入生歓迎会用特設サイト

新入生のみなさんこんにちは！XMLProに興味を持っていただきありがとうございます。

私たちのサークルに興味を持つような、将来の凄腕エンジニアの皆さんに楽しんでいただくために問題をご用意しました。ぜひともダウンロードして、解いてみてください。
全部で2か所に隠されていますよ？
解答は`xmlpro{~~~}`という形式で得られます。見つけた解答は、`xmlpro{~~~}`あるいは`~~~`の部分を以下のGoogleフォームに提出してください。

解いたからといって特になにか特典があるというわけではございません。
んー。じゃあ、ICPCの時にモンスターでもおごります。

奮ってご参加ください！みなさんのご解答を楽しみにしております！

[ファイルダウンロード](./ctf.zip)

[解答提出フォーム](https://docs.google.com/forms/d/e/1FAIpQLScuwfWfUawpbp-2O3XZslW1CwPj8Xbi3RekqZeE6fdIxsIc5A/viewform)

解答・解説は新入生歓迎会から五日後の4/7(水)にこのWebサイト上へ公開します。
その際はTwitterでも告知しますので、ぜひともフォローお願いします！

Twitter: https://twitter.com/xmlpro_tut
Discord: https://discord.gg/jrJ3zWprt2

# CTF問題のヒント
以下は問題のヒントです。
ヒントなんかいらねえ！！自力で解けるやい！！！って方は閲覧しない方がいいです。

<style>
.acd-check{
    display: none;
}
.acd-label{
    background: #333;
    color: #fff;
    display: block;
    margin-bottom: 1px;
    padding: 10px;
}
.acd-content{
    border: 1px solid #333;
    height: 0;
    opacity: 0;
    padding: 0 10px;
    transition: .5s;
    visibility: hidden;
}
.acd-check:checked + .acd-label + .acd-content{
    height: 40px;
    opacity: 1;
    padding: 10px;
    visibility: visible;
}
</style>
<input id="acd-check1" class="acd-check" type="checkbox">
<label class="acd-label" for="acd-check1">Forensicsのヒント</label>
<div class="acd-content">
    <p>zipファイルのどこかに隠されているみたいですよ？</p>
</div>
<input id="acd-check2" class="acd-check" type="checkbox">
<label class="acd-label" for="acd-check2">Cryptographyのヒント</label>
<div class="acd-content">
    <p>解凍した先のテキストファイルの最後の文字に`=`が見えますね...？</p>
</div>

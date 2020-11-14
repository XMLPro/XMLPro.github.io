---
title: "GitHub の Security keys に色々追加した" # タイトル
date: "2020-11-13" # 2020-10-23 のようなフォーマットで設定してください
description: "Yubikey 買って放置してたので軽く触った話と +α" # ページの説明
categories:
  - "紅華祭2020アドベントカレンダー"
  - "GitHub"
tags:
  - "Security"
  - "Yubikey"

thumbnail: "" # サムネイルのurl staticからの相対パスを指定してください
lead: "Windows の PIN, Macbook の Touch ID, Yubikey の 3 つを追加します." # リード文
comments: true
authorbox: true
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

どっかのサークル (ここではない) で部長やっている F0rell ([@F0rell](https://twitter.com/f0rell)) です.

いつもと名義が違うって？気にしないでください (は？). 気になる人はサークル内で k から始まるユーザで探してください, おそらくその人です.

紅華祭2020アドベントカレンダーというアドベントしてないカレンダーの記事です.

# 背景
今年の始めぐらいに Yubikey を買ったけれども, 特に使わず半年ぐらい経過してしまったので, 記事作成用のネタとして使うために GitHub の Security keys に追加した.
Security keys 項目は Settings > Account security の赤枠部分です.

{{< figure src="img1.png" class="center" title="Security keys の場所" width="640" >}}

Security keys には自宅の Windows 機, Macbook Pro 用, Yubikey 用の 3 つを登録しているので, 3 security keys と出てます.

# Yubikey とは
Yubico 社が開発した認証デバイスです. 超小型ながら FIDO U2F や OTP 生成機能などのたくさんの機能があるとともに, 耐久性もすごいらしいです (公式が言ってた).
Yubikey それ自体はキーボードデバイスとして認識されます. そのため, すべての OS で利用可能らしいです.
FIDO U2F とは大雑把に言うと, 2 段階認証の別実装っぽい何かです.
ちなみに, 生体認証 (指紋認証など) は FIDO UAF と言うらしい.

参考: [https://fidoalliance.org/仕様概要/?lang=ja](https://fidoalliance.org/%E4%BB%95%E6%A7%98%E6%A6%82%E8%A6%81/?lang=ja)

# 登録する
さて, 登録しようとなるのですが, Windows の場合, Windows Hello の PIN 認証が優先されてしまうため, Yubikey の登録ができません.
なので, Ubuntu を入れたラップトップから追加しました.
ついでに, Macbook Pro の Touch ID も追加しました.
一度, Yubikey を登録すると, ログイン時の二要素認証で, Yubikey を使って認証を通すことができます.

{{< figure src="img2.png" class="center" title="ここでセキュリティ キーを選択" width="640" >}}

{{< figure src="img3.png" class="center" title="認証画面" width="640" >}}

ここで, USB に挿した Yubikey をタッチすると, 認証が成功します.

# まとめ
以上が Yubikey を使ったりして, GitHub の Secirity keys を登録する話です.
WebAuthn による認証に対応してるサイト, 例えば [1password](https://1password.com/jp/) といったサイトが今回の FIDO U2F 認証方式が使えます.
必ずしも全部の使えるわけではないので, 対応してるかはそれぞれサイトを見てください.

Yubikey は FIDO U2F 以外に色々機能あるのでそこらへん今度は触りたいですね.

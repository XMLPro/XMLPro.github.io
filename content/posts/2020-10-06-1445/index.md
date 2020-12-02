---
title: "(Neo)Vimでできるゲームの紹介" # タイトル
date: "2020-12-01" # 2020-10-23 のようなフォーマットで設定してください
description: "(Neo)Vimでゲームしよう．" # ページの説明
categories:
  - "紅華祭2020アドベントカレンダー"
tags:
  - "Vim"
  - "Neovim"

thumbnail: "" # サムネイルのurl staticからの相対パスを指定してください
lead: "" # リード文
comments: true
authorbox: true
pager: true
toc: false
mathjax: true
sidebar: "right"
widgets: # サイドバーの表示項目
  - "search"
  - "recent"
  - "taglist"
draft: true # 記事を公開する場合trueに設定してください
---

こんにちは，B4の[Inazuma110](https://twitter.com/Inazuma_110)です．
この記事ではVimやNeoVimでできるゲームを紹介します．
講義で扱っただけのVimやそれを拡張するソフトウェアについて，「是非興味を持ってほしい」という気持ちで記事を書いてみました．


## Vimとは
最も有名と言っても過言ではない**テキストエディタ**です．
テキストエディタというのは文字通り，一般には「テキストファイルの編集」に使われるソフトウェアです．
もちろん，ゲームをプレイするためのソフトウェアではありません．

 ~~(とは言え，Google ChromeというブラウザをOSにする企業や，emacsをOSと主張する人々がこの世にはいるのでVimをゲームプラットフォームとして扱うことはそれほど不自然では無いでしょう．)~~

ちなみに，近年の東京工科大学では，1年生の「情報リテラシー演習」や2年生の「プロジェクト演習テーマB」でVimの使い方を学習するようです．
2018年度まで，東京工科大学の講義ではemacsを扱うことが多かったです．[^1]
Vimを講義で使っただけの方に，Vimの魅力が少しでも伝われば幸いです．
[^1]: 期末テストでemacsのキーバインドが出題されたほどです．

## 先行研究
[vim-jp.orgの記事](https://vim-jp.org/blog/2011/09/20/games.html)にて，すでに様々なゲームがまとめられています．
本記事ではここにはないゲームを紹介していきます．

## プラグインについて
Vimでゲームをするプログラムは，多くの場合「Vimのプラグイン」という形で公開されています．
Vimのプラグインというのは，Vimを拡張するソフトウェアのことです．

### プラグインの導入
プラグインマネージャーと呼ばれるプラグイン管理専用のプラグインを使います．
本記事では，私が普段から使っている[dein.vim](https://github.com/Shougo/dein.vim)を用いますが，他にも[vim-plug](https://github.com/junegunn/vim-plug)などが有名です．
好きなものを利用してください．

プラグインの具体的な導入方法については，各プラグインマネージャーのREADMEを読んでください．
これらは英語で書かれていることが多いですが，Google翻訳や[deepl](https://www.deepl.com/translator)を用いることで比較的簡単に翻訳できると思います．

## ゲーム
以下のゲームはNeovim v0.4.3(一部Vim8.2.2077)で動作確認をしています．

### [vim-game-code-break](https://github.com/johngrib/vim-game-code-break)
Vimで開いたソースコードでブロック崩しを遊ぶことができます．
`:VimGameCodeBreak`で現在開いてるファイルの文字をブロックに見立ててブロック崩しを始めます．

![image](https://user-images.githubusercontent.com/1855714/27774457-7e001646-5fcd-11e7-9e90-c37eafefad9c.gif)

とても斬新な発想で面白いです．
破壊したソースコードの内容が消えてしまうということはないので，安心してプレイできます．
クソコードへのストレスをこのゲームで消し飛ばしましょう!!

詳しい操作などや設定などは[リポジトリ](https://github.com/johngrib/vim-game-code-break)のREADMEなどを参照してください．

### [vim-mario](https://github.com/rbtnn/vim-mario)
`:Mario`でマリオが始まります(?)

![image](https://camo.githubusercontent.com/ec99e0fdf7ae339ea6eae266066f37e24b4123ec/68747470733a2f2f7261772e6769746875622e636f6d2f7262746e6e2f6d6172696f2e76696d2f6d61737465722f6d6172696f2e676966)

**このプラグインは，[vim-game_engine](https://github.com/rbtnn/vim-game_engine)に依存しているので，こちらのプラグインも忘れずに導入するようにしてください．**

また，起動時にVimにゲーム画面が入り切らないことがあるので，文字の大きさは適宜調節してください．
多くのターミナルはCtrl--(コントロールとハイフンの同時押し)で文字を小さくできると思います．)

### [vim-puyo](https://github.com/rbtnn/vim-puyo)
`:Puyo`でぷよぷよができます(?)
こちらもvim-marioと同じくvim-game_engineに依存しているので，忘れず導入してください．

![image](https://camo.githubusercontent.com/6c130d8f952f386e6dd206a01194d13cb8b9df30/68747470733a2f2f7261772e6769746875622e636f6d2f7262746e6e2f7075796f2e76696d2f6d61737465722f7075796f2e676966)

#### **注意!!: 以降のゲームはNeovimでは動きません!!**
動作確認はVim8.2.2077で行いました．

### [Killersheep](https://github.com/vim/killersheep)
Vim8.2で音声を再生する機能が実装されたと話題になっていました．
と同時に，その機能を利用したゲームが突如公開され同じく話題になっていました．
`:KillKillKill`でゲームが始まります．

実際にプレイした動画をキャプチャしてみました．ゲームの音声がとてもユニークなのでよかったら音も聞いてみてください．
(完全なキャプチャができていませんがお許しください)

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">Vimでゲームをしました (ブログへの動画埋め込み用) <a href="https://t.co/B4ANfzC2Cd">pic.twitter.com/B4ANfzC2Cd</a></p>&mdash; Inazuma110 (@Inazuma_110) <a href="https://twitter.com/Inazuma_110/status/1333989025196122112?ref_src=twsrc%5Etfw">December 2, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

このゲームは結構やりこんでいたことがあって，全ステージをクリアしました．
そんなに難易度が高いわけではないので，よかったらクリアを目指してみてください．

また，こちらNeovimでは動かないので注意してください．

## 最後に
マリオやぷよぷよはゲーム機で遊んだほうがいいです．

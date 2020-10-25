---
title: "FlutterのHybrid Compositionを使った話" # タイトル
date: "2017-08-21" # 2020-10-23 のようなフォーマットで設定してください
description: "東京工科大学紅華祭アドベントカレンダー" # ページの説明
categories:
  - "紅華祭2020アドベントカレンダー"
tags:
  - "Flutter"

thumbnail: "" # サムネイルのurl staticからの相対パスを指定してください
lead: "Flutter組み込みのWidgetで済むならそれが一番いいと思う" # リード文
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

### はじめに

[^1]: 2020年度XMLPro部長
[^2]: 東京工科大学紅華祭アドベントカレンダーということで記事を書いています
[^3]: 部員のだれが何日目をやるとか決めてないのでアドベントカレンダーとは呼べませんが

สวัสดีตอนเช้า🙏。みんなだいすき部長[^1]の箱守由ですっ☆。今日はみんなと一緒にブログを書いていくよ！[^2] みんなが何日目をやるとか決めてないからアドベントカレンダーと呼べないの…🥺ぴえん[^3]

今回はFlutterのhybrid-compositionに触れることがあったのでそれについて記事を書こうと思います。調べても情報もデモとなるソースコードもあまり見当たらなかったのでだれかの参考になれば幸いです。

### そもそもなんでネイティブのビューが必要になったの？

個人的にはFlutterはかなり使い勝手がよくほとんどFlutter組み込みのWidgetで問題ないと思っています。ただ、どうしても気に入らないのがテキストフィールドの日本語入力の挙動です。下の画像を見てください。

{{< figure src="./flutter-textfield.png" class="center" title="Flutter組み込みのTextField" width="320" >}}

「ぶんかつへんかん」と入力した後、左へ移動キーを押してカーソルを移動させると変換範囲とFlutter上で表示される変換範囲が一致しなくなります。これはあまり直感的とは言えません。

いろいろとFlutterのTextFieldのプロパティを見てみたのですが、ちょうどいい解決策が見つからず、**EditText**というAndroidネイティブのViewを使えば解決するのではないかと思いました。

### Hybrid Compositionとは

Hybrid Compositionとはandroid.view.ViewをFlutterのウィジットツリーに追加することでAndroidのネイティブビューを表示するためのしくみです。ウィジットツリーに組み込まれているので、キーボードハンドリングなどがうまく動いてくれます。

Androidのネイティブビューを表示するためのものとしてAndroidViewというFlutterのウィジットを利用したバーチャルディスプレイというものがありますが、これはAndroidネイティブのビューの表示結果をFlutterのウィジットに貼り付けるイメージだと思います。ビューを貼り付けているだけなので、キーボードハンドリングがうまく動かないことが多いです。私もはじめはHybrid CompositionではなくAndroidViewを使ってネイティブキーボードを実装していたのですが、テキストフィールドをタッチしてもソフトウェアキーボードが出てくれなくて呆然としておりました。

参考：[Flutter公式](https://flutter.dev/docs/development/platform-integration/platform-views)

### 使い方

上の参考リンクにのっているソースコードの解説をしていこうかなと思います。

#### Flutterサイド

まず、Flutter側から始めます。

以下をインポートして

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
```

Widgetのbuild()では以下を返します。

```dart
Widget build(BuildContext context) {
  // This is used in the platform side to register the view.
  final String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  return PlatformViewLink(
    viewType: viewType,
    surfaceFactory:
        (BuildContext context, PlatformViewController controller) {
      return AndroidViewSurface(
        controller: controller,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      );
    },
    onCreatePlatformView: (PlatformViewCreationParams params) {
      return PlatformViewsService.initSurfaceAndroidView(
        id: params.id,
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: StandardMessageCodec(),
      )
        ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
        ..create();
    },
  );
}
```

では、上のソースコードの解説をしていきます。

viewTypeというのはネイティブのビューを識別するための文字列です。任意の名前が使用可能です。

PlatformViewLink()がFlutterに統合されたAndroidネイティブのビューを作成してくれているっぽいです。

surfaceFactoryはFlutterのレイヤーツリーに組み込まれるレイヤを返す関数を設定してあげます。今回はAndroidネイティブのレイヤをツリーに追加したいので、AndroidViewSurfaceを利用しているってことっぽいです。gestureRecognizersはGestureRecognizerのFactoryのリストを渡してやります。ここに渡したGestureRecognizerのGestureの種類がAndroidネイティブのビューにも通知されるっぽいです。hitTestBehaviorはタッチ範囲に関する設定で、どういう使い方なのかは[こちら](https://qiita.com/najeira/items/54e3cfff16c82318103d)が分かりやすいかもです。

onCreatePlatformViewにはPlatformViewCreationParamsクラスを受け取ってPlatformViewControllerを返す関数を指定します。この関数で作られたControllerがsurfaceFactoryに渡されて、レイヤの作成に利用される。PlatformViewsService.initSurfaceAndroidViewがSurfaceAndroidViewControllerというPlatformViewControllerを継承したクラスを返しています。

params.idにはこれから作られるAndroidネイティブビューのidが入っています。
textDirectionはテキストの向きを決定し、creationPramsCodecはAndroidサイドにcreationParamsを送る前にエンコードするためのコーデックだそうです（調べてないのでよくわからん）。creationParamsは作成するネイティブビューに渡されて自由に使えます。（後のkotlinコードを参照）

addOnPlatformViewCreatedListenerにparams.onPlatformViewCreatedが渡されていますが、このonPlatformViewCreatedは、PlatformViewLinkのsetStateを呼ぶだけの関数っぽいです。(実装は[ここ](https://github.com/flutter/flutter/blob/720dff6a94bd054e82ec4bf84b5cb802bbc52ddd/packages/flutter/lib/src/widgets/platform_view.dart#L890)) setStateで_platformViewCreatedをtrueにしています。これがtrueになると、build()で返るウィジットがSizedBox.expand()から、Androidネイティブのレイヤが入ったFocusウィジットが返されるようになります。

create()を呼ぶとSystemChannelを通してAndroidのビューが作成されて(_sendCreateMessage() [実装はここ](https://github.com/flutter/flutter/blob/720dff6a94bd054e82ec4bf84b5cb802bbc52ddd/packages/flutter/lib/src/services/platform_views.dart#L1019))、リスナーとして登録された関数を呼び出します。([ここ](https://github.com/flutter/flutter/blob/720dff6a94bd054e82ec4bf84b5cb802bbc52ddd/packages/flutter/lib/src/services/platform_views.dart#L740)が該当)


長くなったので簡単にまとめ直すと、

1. PlatformViewLinkを作ってやる
2. PlatformViewLinkを作成すると、onCreatePlatformViewに設定した関数が呼ばれる。
3. その呼ばれた関数ではAndroidネイティブのViewを作成し、作成が終わったらaddOnPlatformViewCreatedListener()で登録された関数を呼び出して(setStateを呼び出して)、PlatformViewLinkのbuild()の処理の流れを変える
4. PlatformViewLinkのbuild()内で、surfaceFactoryを呼び出した際に返されるAndroidViewSurfaceをchildに持つFocusウィジットが作成され、それが表示される。

こういう流れになります。うーん。これ、Flutter利用者に書かせるコードじゃないだろ....

#### ネイティブサイド

次にネイティブサイドのコードを載せます。これらのファイル置き場ですが、android/app/src/main/kotlin以下を探していくとMainActivity.ktというファイルが見つかると思います。そこに置いてください。

NativeView.kt
```kotlin:NativeView.kt
package dev.flutter.example

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import io.flutter.plugin.platform.PlatformView

internal class NativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val textView: TextView

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        textView = TextView(context)
        textView.textSize = 72f
        textView.setBackgroundColor(Color.rgb(255, 255, 255))
        textView.text = "Rendered on a native Android view (id: $id)"
    }
}

```

```kotlin:NativeViewFactory.kt
package dev.flutter.example

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class NativeViewFactory(private val messenger: BinaryMessenger, private val containerView: View) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return NativeView(context, id, creationParams)
    }
}
```

```kotlin:MainActivity.kt
package dev.flutter.example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("<platform-view-type>", NativeViewFactory())
    }
}
```

ネイティブの方のコードはFlutterサイドに比べれば読みやすい気がしますね。FlutterサイドからviewTypeのビューを利用できるようにするには3つの手順を踏みます。

1. PlatformViewクラスを継承したネイティブビューを作成する
   init等でAndroidネイティブのビューを作成し、getViewでそれを返すように設定する
2. NativeViewを作成するFactoryを作成する
3. MainActivityのconfigureFlutterEngine内でregisterViewFactoryを呼び出して、viewType（今回の例だと"\<platform-view-type\>"）とネイティブビューを紐づける。

NativeViewFactoryにcreationParamsが渡ってきていますが、これがFlutterサイドで渡したcreationParamsです。NativeViewにこれを渡すことでネイティブビューでも利用ができます。

### 本題

なんとなく流れが分かったので、実際に上のコードを使って変換範囲がきれいなネイティブのテキストフィールドを作成していきます。サンプルプロジェクトは(ここ)[https://github.com/hakomori64/hybrid-composition-textfield]に置いておきます。

最初にDart側のコードです。

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TextField Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TextFieldDemo(title: 'Flutter Text Field Demo'),
    );
  }
}

class TextFieldDemo extends StatefulWidget {
  TextFieldDemo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {

  final String viewType = "edit-text";
  Map<String, dynamic> creationParams = <String, dynamic>{};
  static const EventChannel _eventChannel = const EventChannel("events/edit-text");
  StreamSubscription _streamSubscription;
  String text = "";

  void onTextChanged(String t) {
    print("setState Called");
    setState(() {text = t;});
  }

  void _enableEventReceiver() {
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        print("Received Event: $event");
        setState(() {
          text = event;
        });
      },
      onError: (dynamic error) {
        print("Received Error: ${error.message}");
      },
      cancelOnError: true
    );
  }

  void _disableEventReceiver() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _enableEventReceiver();
  }

  @override
  void dispose() {
    super.dispose();
    _disableEventReceiver();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: PlatformViewLink(
            viewType: viewType,
            surfaceFactory: (BuildContext context, PlatformViewController controller) {
              return AndroidViewSurface(
                controller: controller,
                gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              );
            },
            onCreatePlatformView: (PlatformViewCreationParams params) {
              return PlatformViewsService.initSurfaceAndroidView(
                id: params.id,
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: StandardMessageCodec(),
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
            },
          ),
        )
      ),
    );
  }
}
```

Hybrid Compositionの部分はほぼほぼ公式の通りです。今回は**"edit-text"**という名前でandroidネイティブのEditTextを返すPlatformViewを登録しています。上のコードではネイティブとのデータの受け渡しにEventChannelを使っています。EventChannelを通してEditTextのonTextChangedから入力されたテキストを受け取り_TextFieldDemoStateのtextに保存します。EventChannelの使い方に関しては(こちら)[https://qiita.com/kurun_pan/items/6d63ebf1e894d3620b20]を参考にさせていただきました。ありがとうございます。

次にネイティブのコードです。

MainActivity.kt
```kotlin
package com.example.textfield_demo

import android.os.Handler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine)

    flutterEngine
        .platformViewsController
        .registry
        .registerViewFactory("edit-text", EditTextFactory(flutterEngine.dartExecutor.binaryMessenger))

    var channel: EventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "events/edit-text")
    channel.setStreamHandler(
      object: StreamHandler {
        override fun onListen(arguments: Any?, events: EventSink) {
          FlutterEditText.eventSink = events
          Handler().postDelayed({
            events.success("Android")
          }, 500)
        }
        override fun onCancel(arguments: Any?) {}
      }
    )
  }
}
```

EditTextFactory.kt
```kotlin
package com.example.textfield_demo

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class EditTextFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return FlutterEditText(context, id, creationParams)
    }
}

```

FlutterEditText.kt
```kotlin
package com.example.textfield_demo

import android.content.Context
import android.graphics.Color
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.text.TextWatcher
import android.text.Editable
import io.flutter.plugin.common.EventChannel.EventSink
import androidx.annotation.Nullable
import io.flutter.plugin.platform.PlatformView

interface CustomTextWatcher: TextWatcher{
  override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
  override fun afterTextChanged(p0: Editable?) {}
}

internal class FlutterEditText(context: Context, id: Int, @Nullable creationParams: Map<String?, Any?>?) : PlatformView {

    companion object {
      var eventSink: EventSink? = null
    }

    private val editTextLayout: ViewGroup
    private var lastText: String = ""

    override fun getView(): View {
        return editTextLayout
    }

    override fun dispose() {}

    init {
      editTextLayout = (View.inflate(context, R.layout.flutter_edit_text, null) as ViewGroup)
      var editText: EditText = editTextLayout.getChildAt(0) as EditText
      editText.addTextChangedListener(object: CustomTextWatcher{
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
          if (!s.toString().equals(lastText)) {
            eventSink?.success(s.toString())
            lastText = s.toString()

          }
        }
      })
    }
}
```

Hybrid Compositionの部分についてはほとんど公式の通りですが、説明しなければいけない点がいくつかあります。

一つ目がEventChannelの登録です。これはMainActivity内でdartサイドのイベントチャンネルと同じ名前で登録して、onListenが呼ばれるタイミングでFlutterEditTextに渡してあげます。

二つ目がlayout機能の利用です。`View.inflate`を使うと、android/app/src/main/res/layout以下にあるxmlファイル内の記述からビューの作成がされます。該当ディレクトリにflutter_edit_text.xmlというファイルを作り、下のように記述してやります。

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".MainActivity"
    tools:showIn="@layout/flutter_edit_text">

    <EditText
        android:id="@+id/flutter_edit_text"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textIsSelectable="true"
        android:inputType="textMultiLine"
        android:focusable="true"
        android:focusableInTouchMode="true"
        android:minLines="6"
        android:gravity="top"
        android:hint="Enter Something"
    />

</androidx.constraintlayout.widget.ConstraintLayout>
```

showInのところで名前を決め、R.layout.flutter_edit_textでビューを作成できるようにします。これで、inflateを使ってこのConstraintLayoutが取得できるようになるので、FlutterEditTextではその子供にあたるEditTextを取得して設定を追加で行っています。

最後が、EditTextにlistenerを登録してあげているところです。具体的にはこの辺ですね。

```kotlin
      editText.addTextChangedListener(object: CustomTextWatcher{
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
          if (!s.toString().equals(lastText)) {
            eventSink?.success(s.toString())
            lastText = s.toString()


          }
        }
      })
```

onTextChangedをオーバーライドして、変更後のテキストをEventChannelを通じて、Flutter側に通知しています。


長くなりましたが、最終的にこうなります。

{{< figure src="./native-text-field.gif" class="center" title="AndroidネイティブのEditText" width="320" >}}


やったぜ

### 感想とか、注意とか

creationParamsを使えばFlutter側からMap形式で情報を情報を送れるので、必要なら利用してください。ただ、文字列とか整数値とかしか送れなかった気がします。Dartで書いたcallback関数とか送れないかなーと思って試してみたんですがダメでした。

EditTextのメソッド（setTextとか）を呼び出したい！って場合はMethodChannel, EditTextでイベントが発生したらDartの処理を実行したいって時はEventChannelを使うのがいいような気がしました。なんかもっといい方法を知っている方がいらしたら教えていただきたいです。

Hybrid Compositionはまだまだ新しい機能で情報も少ないのでかなり苦労しました。Flutterの組み込みWidgetで解決できるならそれが一番楽でいいなと思いました。
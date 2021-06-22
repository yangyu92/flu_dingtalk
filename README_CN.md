# flu_dingtalk

![pub package](https://img.shields.io/pub/v/flu_dingtalk.svg)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](./LICENSE)

## 什么是flu_dingtalk

`flu_dingtalk` 是一个[钉钉SDK](https://developers.dingtalk.com/document/mobile-app-guide)插件，它允许开发者调用
[钉钉原生SDK](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Resource_Center_Homepage.html).

## 安装

在`pubspec.yaml` 文件中添加`flu_dingtalk`依赖:

```yaml
dependencies:
  flu_dingtalk: ^1.0.0
```

## android

```groovy
buildscript {
    dependencies {
        // Android 11兼容，需升级Gradle到3.5.4/3.6.4/4.x.y
        classpath 'com.android.tools.build:gradle:4.1.0'
    }
}
```

## ios

``` xml
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
tencent: identifier=tencent schemes=appId
```

``` xml
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>dingtalk</string>
  <string>dingtalk-open</string>
  <string>dingtalk-sso</string>
</array>
```

## flutter

``` text
Flutter 2.2.2 • channel stable nullsafety
Framework • revision d79295af24 (9 days ago) • 2021-06-11 08:56:01 -0700
Engine • revision 91c9fc8fe0
Tools • Dart 2.13.3
```

## 能力

- 分享图片，文本，音乐，视频等。
- 钉钉登录.
- 打开钉钉.

## 准备

`flu_dingtalk` 可以做很多工作但不是所有. 在集成之前，最好读一下[官方文档](https://developers.dingtalk.com/document/mobile-app-guide).  
 然后你才知道怎么生成签名，怎么使用universal link以及怎么添加URL schema等.

## 注册钉钉

通过 `flu_dingtalk` 注册钉钉SDK.

```dart
FluDingtalk.registerApp("dingu6xwfjbghhqtwwzu");
```

对于Android, 可以查看[本文](https://developers.dingtalk.com/document/mobile-app-guide/sdk-download?spm=ding_open_doc.document.0.0.350710afk92z1R#section-gz5-iof-0ni)以便了解怎么获取app签名.
然后你需要知道release和debug时，app签名有什么区别。如果签名不对，你会得一个错误 `errCode = -1`.

## 能力文档

- [登录](./doc/AUTH_CN.md)
- [分享](./doc/SHARE_CN.md)

对于更多功能，可以查看源码。

## QA

[这些问题可能对你有帮助](./doc/QA_CN.md)

## 捐助

开源不易，请作者喝杯咖啡。

## 关注公众号

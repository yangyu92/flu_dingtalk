import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/flu_dingtalk_plugin_api.dart',
  dartTestOut: 'test/test_api.dart',
  swiftOut: 'ios/Classes/FluDingtalk.swift',
  kotlinOut: 'android/src/main/kotlin/cn/yymm/flu_dingtalk/FluDingtalk.kt',
  kotlinOptions: KotlinOptions(
    package: 'cn.yymm.flu_dingtalk',
  ),
))
@HostApi(dartHostTestHandler: 'TestHostDingTalkFlutterApi')
abstract class FluDingtalkPluginApi {
  String openAPIVersion();
  @async
  bool openDDApp();
  bool isDingDingInstalled();
  bool registerApp(String appId, String iosBundleId);
  bool isDingTalkSupportSSO();
  @async
  bool sendAuth(DTAuthReq authReq);

  /// 分享文本
  /// [text] 文本内容. @note 长度不超过 1K.
  @async
  bool sendTextMessage(String text);

  /// 分享网页链接
  /// [url] Web页面的URL. @note 长度不能超过 10K.
  /// [title] 标题. @note 长度不超过 512Byte.
  /// [content] 描述内容. @note 长度不超过 1K.
  /// [thumbUrl] 缩略图URL. @note 长度不超过 10K.
  @async
  bool sendWebPageMessage(
    String url, {
    required String title,
    required String content,
    required String thumbUrl,
  });

  /// [picUrl] is necessary on IOS
  /// 分享图片（IOS端必传picUrl）
  /// [picUrl] 图片URL. @note 长度不能超过 10K.
  @async
  bool sendImageMessage({String? picUrl, String? picPath});
}

@FlutterApi()
abstract class FluDingTalkEventApi {
  void onAuthResponse(FluDTAuthorizeResp authResp);
  void onShareResponse(FluDTShareResp shareResp);
  void onBaseResponse(DTBaseResponse response);
}

class DTAuthReq {
  String? redirectURI;
  String? state;
}

// 原本想使用继承处理返回对象, 然而pigeon不支持对象的继承
class DTBaseResponse {
  late String errorCode;
  late String errorMessage;
}

// errorCode = 0 成功
// errorCode = -1 通用错误
// errUserCancel = -2 用户取消
// errSentFailed = -3 发送失败
// errAuthDenied = -4 授权失败
// errUnsupport = -5 DingTalk不支持
class FluDTAuthorizeResp {
  late String errorCode;
  late String errorMessage;
  late String accessCode;
  String? state;
}

class FluDTShareResp {
  late String errorCode;
  late String errorMessage;
  late bool shareResult;
}

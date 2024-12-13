import 'dart:async';

import 'package:flu_dingtalk/flu_dingtalk_plugin_api.dart';
import 'response/dingtalk_response.dart';

class FluDingtalk implements FluDingTalkEventApi {
  FluDingtalk._();
  static final FluDingtalk _instance = FluDingtalk._();
  static FluDingtalk get instance => _instance;

  static final FluDingtalkPluginApi _pluginApi = FluDingtalkPluginApi();

  /// 回调响应事件控制器
  static final StreamController<BaseDDResponse>
      _ddResponseEventHandlerController =
      StreamController<BaseDDResponse>.broadcast();

  /// 钉钉授权等回调信息
  static Stream<BaseDDResponse> get ddResponseEventHandler =>
      _ddResponseEventHandlerController.stream;

  /// 初始化，注册回调事件
  static void init() {
    FluDingTalkEventApi.setUp(instance);
  }

  /// 销毁控制器，避免内存泄漏
  static void dispose() {
    if (!_ddResponseEventHandlerController.isClosed) {
      _ddResponseEventHandlerController.close();
    }
  }

  static Future<bool> registerApp(String appId, String iosBundleId) {
    init();
    return _pluginApi.registerApp(appId, iosBundleId);
  }

  static Future<String> openAPIVersion() => _pluginApi.openAPIVersion();

  static Future<bool> openDDApp() => _pluginApi.openDDApp();

  static Future<bool> isDingDingInstalled() => _pluginApi.isDingDingInstalled();

  static Future<bool> isDingTalkSupportSSO() =>
      _pluginApi.isDingTalkSupportSSO();

  static Future<bool> sendAuth(DTAuthReq authReq) =>
      _pluginApi.sendAuth(authReq);

  static Future<bool> sendTextMessage(String text) =>
      _pluginApi.sendTextMessage(text);

  /// 分享网页链接
  /// [url] Web页面的URL. @note 长度不能超过 10K.
  /// [title] 标题. @note 长度不超过 512Byte.
  /// [content] 描述内容. @note 长度不超过 1K.
  /// [thumbUrl] 缩略图URL. @note 长度不超过 10K.

  static Future<bool> sendWebPageMessage(
    String url, {
    required String title,
    required String content,
    required String thumbUrl,
  }) =>
      _pluginApi.sendWebPageMessage(url,
          title: title, content: content, thumbUrl: thumbUrl);

  /// [picUrl] is necessary on IOS
  /// 分享图片（IOS端必传picUrl）
  /// [picUrl] 图片URL. @note 长度不能超过 10K.

  static Future<bool> sendImageMessage({String? picUrl, String? picPath}) =>
      _pluginApi.sendImageMessage(picUrl: picUrl, picPath: picPath);

  /// 回调方法示例
  @override
  void onAuthResponse(FluDTAuthorizeResp authResp) {
    if (!_ddResponseEventHandlerController.isClosed) {
      _ddResponseEventHandlerController
          .add(DDAuthResponse.fromDTBaseResponse(authResp));
    }
  }

  @override
  void onShareResponse(FluDTShareResp shareResp) {
    if (!_ddResponseEventHandlerController.isClosed) {
      _ddResponseEventHandlerController
          .add(DDShareResponse.fromDTBaseResponse(shareResp));
    }
  }

  @override
  void onBaseResponse(DTBaseResponse response) {
    if (!_ddResponseEventHandlerController.isClosed) {
      _ddResponseEventHandlerController
          .add(BaseDDResponse.fromDTBaseResponse(response));
    }
  }
}

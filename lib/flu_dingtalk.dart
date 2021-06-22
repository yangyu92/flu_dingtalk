import 'dart:async';

import 'package:flutter/services.dart';
import 'response/dingtalk_response.dart';

class FluDingtalk {
  static MethodChannel _channel = const MethodChannel('flu_dingtalk')
    ..setMethodCallHandler(_handler);

  ///回调响应SteamController
  static StreamController<BaseDDShareResponse>
      _ddResponseEventHandlerController = new StreamController.broadcast();

  /// DingTalk api response callback Steam
  /// 钉钉授权等回调信息.
  static Stream<BaseDDShareResponse> get ddResponseEventHandler =>
      _ddResponseEventHandlerController.stream;

  static Future<String> get openAPIVersion async {
    final String version = await _channel.invokeMethod('openAPIVersion');
    return version;
  }

  /// [iosBundleId] is necessary on IOS
  /// 注册钉钉,IOS端必传buindleId
  static Future<bool> registerApp(String appId, String iosBundleId) async {
    return await _channel
        .invokeMethod('registerApp', {"appId": appId, "bundleId": iosBundleId});
  }

  /// true if DingTalk installed,otherwise false.
  /// 是否安装了钉钉
  static Future<bool> isDingDingInstalled() async {
    bool result = false;
    try {
      result = await _channel.invokeMethod('isDingDingInstalled');
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// DingTalk Support SSO
  static Future<bool> get isDingTalkSupportSSO async {
    bool result = false;
    try {
      result = await _channel.invokeMethod('isDingTalkSupportSSO');
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// open DingTalk
  static Future<bool> get openDingTalk async {
    bool result = false;
    try {
      result = await _channel.invokeMethod('openDingTalk');
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// The DingTalk-Login is under Auth-2.0
  /// This method login with native DingTalk app.
  /// This method only supports getting AuthCode,this is first step to login with DingTalk
  /// Once AuthCode got, you need to request Access_Token
  /// For more information please visit：
  /// * https://ding-doc.dingtalk.com/doc#/native/ddvlch
  /// 钉钉登录授权
  static Future<bool> sendAuth(String state) async {
    bool result = false;
    try {
      result = await _channel.invokeMethod('sendAuth', {"state": "$state"});
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// 分享文本
  static Future<bool> sendTextMessage(String text,
      {bool isSendDing = false}) async {
    bool result = false;
    try {
      result = await _channel.invokeMethod(
          'sendTextMessage', {"text": "$text", "isSendDing": isSendDing});
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// 分享网页链接
  static Future<bool> sendWebPageMessage(String url,
      {bool isSendDing = false,
      required String title,
      required String content,
      required String thumbUrl}) async {
    bool result = false;
    try {
      result = await _channel.invokeMethod('sendWebPageMessage', {
        "url": url,
        "isSendDing": isSendDing,
        'title': title,
        'content': content,
        'thumbUrl': thumbUrl
      });
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// [picUrl] is necessary on IOS
  /// 分享图片（IOS端必传picUrl）
  static Future<bool> sendImageMessage(
      {bool isSendDing = false, String? picUrl, String? picPath}) async {
    //必传一个
    if (picUrl == null && picPath == null) {
      return false;
    }
    bool result = false;
    try {
      result = await _channel.invokeMethod('sendImageMessage', {
        "picUrl": picUrl,
        "isSendDing": isSendDing,
        'picPath': picPath,
      });
    } catch (e) {
      print(e);
    }
    return result;
  }

  ///DingTalk response method handler
  ///响应处理
  static Future<dynamic> _handler(MethodCall methodCall) {
    print('_handler_handler_handler_handler_handler---');
    var response =
        BaseDDShareResponse.create(methodCall.method, methodCall.arguments);
    _ddResponseEventHandlerController.add(response);
    return Future.value(true);
  }
}

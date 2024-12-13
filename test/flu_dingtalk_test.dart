import 'package:flu_dingtalk/flu_dingtalk_plugin_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_api.dart';

class _ApiLogger implements TestHostDingTalkFlutterApi {
  final List<String> log = <String>[];

  @override
  bool isDingDingInstalled() {
    log.add('isDingDingInstalled');
    return true;
  }

  @override
  bool isDingTalkSupportSSO() {
    log.add('isDingTalkSupportSSO');
    return true;
  }

  @override
  String openAPIVersion() {
    log.add('openAPIVersion');
    return '1.0.0';
  }

  @override
  Future<bool> openDDApp() {
    log.add('openDDApp');
    return Future.value(true);
  }

  @override
  bool registerApp(String appId, String iosBundleId) {
    log.add('registerApp');
    return true;
  }

  @override
  Future<bool> sendAuth(DTAuthReq authReq) {
    log.add('sendAuth');
    return Future.value(true);
  }

  @override
  Future<bool> sendImageMessage({String? picUrl, String? picPath}) {
    log.add('sendImageMessage');
    return Future.value(true);
  }

  @override
  Future<bool> sendTextMessage(String text) {
    log.add('sendTextMessage');
    return Future.value(true);
  }

  @override
  Future<bool> sendWebPageMessage(
    String url, {
    required String title,
    required String content,
    required String thumbUrl,
  }) {
    log.add('sendWebPageMessage');
    return Future.value(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('registration', () async {
    // VerifyblocFlutter.registerWith();
    // expect(VerifyblocFlutterPlatform.instance, isA<VerifyblocFlutter>());
  });

  group('dingTalk', () {
    final FluDingtalkPluginApi instance = FluDingtalkPluginApi();
    late _ApiLogger log;

    setUp(() {
      log = _ApiLogger();
      TestHostDingTalkFlutterApi.setUp(log);
    });

    test('getPlatformVersion', () async {
      bool installed = await instance.isDingDingInstalled();
      expect(installed, isA<bool>());
      expect(log.log.last, 'getPlatformVersion');
      // expect(installed, isA<Version>());
      // expect(log.log.last, 'getPlatformVersion');
    });
  });
}

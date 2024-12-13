import 'package:flu_dingtalk/flu_dingtalk.dart';
import 'package:flu_dingtalk/flu_dingtalk_plugin_api.dart';
import 'package:flu_dingtalk/response/dingtalk_response.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String _platformVersion = 'Unknown';
  String _registerApp = 'Unknown';

  @override
  void initState() {
    super.initState();

    initPlatformState();

    FluDingtalk.ddResponseEventHandler.listen(dingtalkResponseEvent);
  }

  @override
  void dispose() {
    super.dispose();
    FluDingtalk.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool registerApp = await FluDingtalk.registerApp(
        'dingcxbptovsyu1lmth0', 'com.example.flu_dingtalk_example');

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await FluDingtalk.openAPIVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _registerApp = 'registerApp: $registerApp';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('version: $_platformVersion'),
          Text(_registerApp),
          TextButton(
            onPressed: () {
              FluDingtalk.isDingDingInstalled().then((value) {
                _showDialog("是否安装了钉钉: $value");
              });
            },
            child: const Text('isDingDingInstalled'),
          ),
          TextButton(
            onPressed: () {
              FluDingtalk.isDingTalkSupportSSO().then((value) {
                _showDialog("是否支持登录: $value");
              });
            },
            child: const Text('isDingTalkSupportSSO'),
          ),
          TextButton(
            onPressed: () {
              FluDingtalk.openDDApp().then((value) {
                _showDialog("打开钉钉App: $value");
              });
            },
            child: const Text('openDingTalk'),
          ),
          TextButton(
            onPressed: () {
              FluDingtalk.sendAuth(
                DTAuthReq(redirectURI: "https://www.yymimang.cn"),
              ).then((value) {
                // _showDialog("打开钉钉登录: $value");
              }).catchError((error) {
                _showDialog(error.toString());
              });
            },
            child: const Text('sendAuthDingTalk'),
          ),
          TextButton(
            onPressed: () {
              FluDingtalk.sendTextMessage('分享文本');
            },
            child: const Text('shareText'),
          ),
          TextButton(
            onPressed: () {
              FluDingtalk.sendImageMessage(
                  picUrl:
                      'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png');
            },
            child: const Text('shareImage'),
          ),
          TextButton(
            onPressed: () {
              FluDingtalk.sendWebPageMessage(
                'https://www.baidu.com/',
                title: '标题',
                content: '描述2333',
                thumbUrl:
                    'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png',
              );
            },
            child: const Text('shareWebPage'),
          ),
        ],
      ),
    );
  }

  void _showDialog(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDialog(msg);
      },
    );
  }

  Widget _buildDialog(String content) {
    return AlertDialog(
      content: Row(
        children: [
          Expanded(
            child: Text(content),
          ),
          const CloseButton(),
        ],
      ),
    );
  }

  // 钉钉回调监听
  void dingtalkResponseEvent(BaseDDResponse response) {
    if (response is DDShareResponse) {
      _showDialog("DDShareResponse: ${response.shareResult}");
    } else if (response is DDAuthResponse) {
      _showDialog("DDAuthResponse: ${response.accessCode}");
    } else {
      _showDialog("BaseDDResponse: ${response.mErrCode} - ${response.mErrStr}");
    }
  }
}

import 'package:flu_dingtalk/response/dingtalk_response.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flu_dingtalk/flu_dingtalk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _dingtalkVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    FluDingtalk.ddResponseEventHandler.listen(dingtalkResponseEvent);
  }

  Future<void> initPlatformState() async {
    String dingtalkVersion;
    try {
      dingtalkVersion = await FluDingtalk.openAPIVersion;
      print("钉钉SDK: ===> versionSDK: $dingtalkVersion");
      bool isSupport = await FluDingtalk.registerApp(
          "dingcxbptovsyu1lmth0", "com.example.flu_dingtalk_example");
      print("注册成功: $isSupport");
    } on PlatformException {
      dingtalkVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _dingtalkVersion = dingtalkVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dingtalk SDK Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('dingtalkVersion: $_dingtalkVersion\n'),
              TextButton(
                onPressed: () {
                  FluDingtalk.isDingDingInstalled().then((value) {
                    print("是否安装了钉钉: $value");
                  });
                },
                child: Text('isDingDingInstalled'),
              ),
              TextButton(
                onPressed: () {
                  FluDingtalk.isDingTalkSupportSSO.then((value) {
                    print("是否支持登录: $value");
                  });
                },
                child: Text('isDingTalkSupportSSO'),
              ),
              TextButton(
                onPressed: () {
                  FluDingtalk.openDingTalk
                      .then((value) => print("打开钉钉App: $value"));
                },
                child: Text('openDingTalk'),
              ),
              TextButton(
                onPressed: () {
                  FluDingtalk.sendAuth("Auth").then(
                    (value) => print("打开钉钉登录: $value"),
                  );
                },
                child: Text('sendAuthDingTalk'),
              ),
              TextButton(
                onPressed: () {
                  FluDingtalk.sendTextMessage('分享文本');
                },
                child: Text('shareText'),
              ),
              TextButton(
                onPressed: () {
                  FluDingtalk.sendImageMessage(
                      picUrl:
                          'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png');
                },
                child: Text('shareImage'),
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
                child: Text('shareWebPage'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 钉钉回调监听
  void dingtalkResponseEvent(event) {
    if (event is DDShareAuthResponse) {
      var response = event;
      if (response.code.isNotEmpty) {
        print("OAuthCode: ${response.code}");
      } else {
        print(response.mErrStr);
      }
    }
  }
}

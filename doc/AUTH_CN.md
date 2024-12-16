## 登录

监听登录,分享回调
FluDingtalk.ddResponseEventHandler.listen(dingtalkResponseEvent);

``` dart
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
```

import 'package:flu_dingtalk/flu_dingtalk_plugin_api.dart';

///Base DingTalk Response callback;
///基础响应
class BaseDDResponse {
  final String mErrCode;
  final String mErrStr;

  bool get isSuccessful => mErrCode == "0";

  BaseDDResponse(this.mErrCode, this.mErrStr);
  factory BaseDDResponse.fromDTBaseResponse(DTBaseResponse resp) =>
      BaseDDResponse(resp.errorCode, resp.errorMessage);
}

///DingTalk share message response
///钉钉分享响应
class DDShareResponse extends BaseDDResponse {
  final bool shareResult;
  DDShareResponse(super.mErrCode, super.mErrStr, this.shareResult);
  factory DDShareResponse.fromDTBaseResponse(FluDTShareResp resp) =>
      DDShareResponse(resp.errorCode, resp.errorMessage, resp.shareResult);
}

///DingTalk auth message response
///钉钉授权响应
class DDAuthResponse extends BaseDDResponse {
  final String accessCode;
  final String? state;

  DDAuthResponse(super.mErrCode, super.mErrStr, this.accessCode, this.state);
  factory DDAuthResponse.fromDTBaseResponse(FluDTAuthorizeResp resp) =>
      DDAuthResponse(
          resp.errorCode, resp.errorMessage, resp.accessCode, resp.state);
}



// errorCode = 0 成功
// errorCode = -1 通用错误
// errUserCancel = -2 用户取消
// errSentFailed = -3 发送失败
// errAuthDenied = -4 授权失败
// errUnsupport = -5 DingTalk不支持
///错误代码
// class ErrCode {
//   static const ERR_OK = 0;
//   static const ERR_COMM = -1;
//   static const ERR_USER_CANCEL = -2;
//   static const ERR_SENT_FAILED = -3;
//   static const ERR_AUTH_DENIED = -4;
//   static const ERR_UNSUPPORT = -5;
// }

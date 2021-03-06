const String _mErrCode = "errCode";
const String _mErrStr = "errStr";
const String _mTransaction = "mTransaction";

typedef BaseDDShareResponse _DDShareResponseInvoker(Map argument);

///Response callback mapping
Map<String, _DDShareResponseInvoker> _nameAndResponseMapper = {
  "onShareResponse": (Map argument) => DDShareResponse.fromMap(argument),
  "onAuthResponse": (Map argument) => DDShareAuthResponse.fromMap(argument),
};

///Base DingTalk Response callback;
///基础响应
class BaseDDShareResponse {
  final int mErrCode;
  final String mErrStr;
  final String mTransaction;

  bool get isSuccessful => mErrCode == 0;

  BaseDDShareResponse._(this.mErrCode, this.mErrStr, this.mTransaction);

  /// create response from response pool
  factory BaseDDShareResponse.create(String name, Map argument) =>
      _nameAndResponseMapper[name]!(argument);
}

///DingTalk share message response
///钉钉分享响应
class DDShareResponse extends BaseDDShareResponse {
  final int type;

  DDShareResponse.fromMap(Map map)
      : type = map["type"],
        super._(map[_mErrCode], map[_mErrStr] ?? "", map[_mTransaction] ?? "");
}

///DingTalk auth message response
///钉钉授权响应
class DDShareAuthResponse extends BaseDDShareResponse {
  final String code;
  final String state;

  DDShareAuthResponse.fromMap(Map map)
      : code = map["code"],
        state = map["state"] ?? "",
        super._(map[_mErrCode], map[_mErrStr] ?? "", map[_mTransaction] ?? "");
}

///错误代码
class ErrCode {
  static const ERR_OK = 0;
  static const ERR_COMM = -1;
  static const ERR_USER_CANCEL = -2;
  static const ERR_SENT_FAILED = -3;
  static const ERR_AUTH_DENIED = -4;
  static const ERR_UNSUPPORT = -5;
}

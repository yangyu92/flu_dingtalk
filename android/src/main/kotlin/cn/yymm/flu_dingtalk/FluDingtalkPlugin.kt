package cn.yymm.flu_dingtalk

import android.util.Log
import com.android.dingtalk.share.ddsharemodule.DDShareApiFactory
import com.android.dingtalk.share.ddsharemodule.IDDShareApi
import com.android.dingtalk.share.ddsharemodule.message.DDImageMessage
import com.android.dingtalk.share.ddsharemodule.message.DDMediaMessage
import com.android.dingtalk.share.ddsharemodule.message.DDTextMessage
import com.android.dingtalk.share.ddsharemodule.message.DDWebpageMessage
import com.android.dingtalk.share.ddsharemodule.message.SendAuth
import com.android.dingtalk.share.ddsharemodule.message.SendMessageToDD
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.io.File

/** FluDingTalkPlugin */
class FluDingTalkPlugin : FlutterPlugin, FluDingtalkPluginApi, ActivityAware {

    private val iddShareApi: IDDShareApi?
        get() {
            return IDDShareApiHandler.iddShareApi
        }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        FluDingtalkPluginApi.setUp(flutterPluginBinding.binaryMessenger, this)
        IDDShareApiHandler.dingTalkEvent = FluDingTalkEventApi(flutterPluginBinding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        FluDingtalkPluginApi.setUp(binding.binaryMessenger, null)
        IDDShareApiHandler.dingTalkEvent = FluDingTalkEventApi(binding.binaryMessenger)
    }

    override fun openAPIVersion(): String {
        val req = SendAuth.Req()
        return "${req.supportVersion}"
    }

    override fun openDDApp(callback: (Result<Boolean>) -> Unit) {
        try {
            val result = iddShareApi!!.openDDApp()
            callback(Result.success(result))
        } catch (error: Exception) {
            throw error
        }
    }

    override fun isDingDingInstalled(): Boolean {
        return iddShareApi!!.isDDAppInstalled
    }

    override fun registerApp(appId: String, iosBundleId: String): Boolean {
        IDDShareApiHandler.iddShareApi =
            DDShareApiFactory.createDDShareApi(IDDShareApiHandler.activity, appId, true)
        return iddShareApi!!.registerApp(appId)
    }

    override fun isDingTalkSupportSSO(): Boolean {
        val req = SendAuth.Req()
        return req.supportVersion <= iddShareApi!!.ddSupportAPI
    }

    override fun sendAuth(authReq: DTAuthReq, callback: (Result<Boolean>) -> Unit) {
        val req = SendAuth.Req()
        req.scope = SendAuth.Req.SNS_LOGIN
        req.state = authReq.state
        if (verifyDingTalk()) {
            try {
                val result = iddShareApi!!.sendReq(req)
                callback(Result.success(result))
            } catch (error: Exception) {
                throw error
            }
        }
    }

    override fun sendTextMessage(text: String, callback: (Result<Boolean>) -> Unit) {
        val isSupport: Boolean = IDDShareApiHandler.iddShareApi!!.isDDSupportAPI
        Log.d("yy", "是否支持分享到好友=======>$isSupport")

        if (verifyDingTalk()) {
            //初始化一个DDTextMessage对象
            val textObject = DDTextMessage()
            textObject.mText = text

            //用DDTextMessage对象初始化一个DDMediaMessage对象
            val mediaMessage = DDMediaMessage()
            mediaMessage.mMediaObject = textObject

            //构造一个Req
            val req = SendMessageToDD.Req()
            req.mMediaMessage = mediaMessage
            try {
                val result = iddShareApi!!.sendReq(req)
                callback(Result.success(result))
            } catch (error: Exception) {
                Log.d("yy", "sendAuth ===========>$error")
                callback(
                    Result.failure(
                        FluDingtalkPluginFlutterError(
                            "-5",
                            error.message,
                            error.toString()
                        )
                    )
                )
            }
        }
    }

    override fun sendWebPageMessage(
        url: String,
        title: String,
        content: String,
        thumbUrl: String,
        callback: (Result<Boolean>) -> Unit
    ) {
        val isSupport: Boolean = IDDShareApiHandler.iddShareApi!!.isDDSupportAPI
        Log.d("yy", "是否支持分享到好友=======>$isSupport")

        if (verifyDingTalk()) {
            val mUrl = url as String?

            //初始化一个DDWebpageMessage并填充网页链接地址
            val webPageObject = DDWebpageMessage()
            webPageObject.mUrl = mUrl

            //构造一个DDMediaMessage对象
            val webMessage = DDMediaMessage()
            webMessage.mMediaObject = webPageObject
            webMessage.mTitle = title
            webMessage.mContent = content
            webMessage.mThumbUrl = thumbUrl
            // 网页分享的缩略图也可以使用bitmap形式传输
//         webMessage.setThumbImage(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher));

            //构造一个Req
            val webReq = SendMessageToDD.Req()
            webReq.mMediaMessage = webMessage
            //        webReq.transaction = buildTransaction("webpage");
            try {
                val result = iddShareApi!!.sendReq(webReq)
                callback(Result.success(result))
            } catch (error: Exception) {
                Log.d("yy", "sendAuth ===========>$error")
                callback(
                    Result.failure(
                        FluDingtalkPluginFlutterError(
                            "-5",
                            error.message,
                            error.toString()
                        )
                    )
                )
            }
        }
    }

    override fun sendImageMessage(
        picUrl: String?,
        picPath: String?,
        callback: (Result<Boolean>) -> Unit
    ) {
        val isSupport: Boolean = IDDShareApiHandler.iddShareApi!!.isDDSupportAPI
        Log.d("yy", "是否支持分享到好友=======>$isSupport")

        if (verifyDingTalk()) {
            //初始化一个DDImageMessage
            val imageObject = DDImageMessage()
            //url图片
            if (picUrl != null) {
                imageObject.mImageUrl = picUrl
            } else if (picPath != null) {
                //本地图片
                val file = File(picPath)
                if (!file.exists()) {
                    Log.d("FlutterDDShareLog", "图片路径无效: $picPath")
                    callback(
                        Result.failure(
                            FluDingtalkPluginFlutterError(
                                "-1",
                                "picPath error",
                                "图片路径无效"
                            )
                        )
                    )
                } else {
                    imageObject.mImagePath = picPath
                }
            } else {
                Log.d("FlutterDDShareLog", "无图片来源")
                callback(
                    Result.failure(
                        FluDingtalkPluginFlutterError(
                            "-1",
                            "Image error",
                            "请传输图片来源"
                        )
                    )
                )
            }

            //构造一个mMediaObject对象
            val mediaMessage = DDMediaMessage()
            mediaMessage.mMediaObject = imageObject

            //构造一个Req
            val req = SendMessageToDD.Req()
            req.mMediaMessage = mediaMessage
            //        req.transaction = buildTransaction("image");
            try {
                val result = iddShareApi!!.sendReq(req)
                callback(Result.success(result))
            } catch (error: Exception) {
                Log.d("yy", "sendAuth ===========>$error")
                callback(
                    Result.failure(
                        FluDingtalkPluginFlutterError(
                            "-5",
                            error.message,
                            error.toString()
                        )
                    )
                )
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        IDDShareApiHandler.setRegister(binding)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        IDDShareApiHandler.setRegister(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        IDDShareApiHandler.setRegister(null)
    }

    override fun onDetachedFromActivity() {
        IDDShareApiHandler.setRegister(null)
    }

    private fun verifyDingTalk(): Boolean {
        val req = SendAuth.Req()
        if (iddShareApi == null) {
            throw FluDingtalkPluginFlutterError(
                "-1",
                "DingDing Api Not Registered"
            )
        } else if (!iddShareApi!!.isDDAppInstalled) {
            throw FluDingtalkPluginFlutterError(
                "-2",
                "DingDing not installed"
            )
        } else if (req.supportVersion > iddShareApi!!.ddSupportAPI) {
            //钉钉版本过低，不支持登录授权
            throw FluDingtalkPluginFlutterError(
                "-2",
                "DingDing version is too low"
            )
        }
        return true
    }
}

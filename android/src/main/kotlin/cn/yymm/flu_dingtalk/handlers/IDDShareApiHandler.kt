package cn.yymm.flu_dingtalk.handlers

import android.content.Context
import android.content.Intent
import android.util.Log
import com.android.dingtalk.share.ddsharemodule.DDShareApiFactory
import com.android.dingtalk.share.ddsharemodule.IDDAPIEventHandler
import com.android.dingtalk.share.ddsharemodule.IDDShareApi
import com.android.dingtalk.share.ddsharemodule.message.*
import cn.yymm.flu_dingtalk.constant.CallResult
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

object IDDShareApiHandler {
    var  iddShareApi : IDDShareApi? = null

    private var context : Context? = null

    fun setRegister(register:Context?){
        this.context = register
    }

    fun openAPIVersion(call: MethodCall, result: MethodChannel.Result) {
        val req = SendAuth.Req()
        result.success("${req.supportVersion}")
    }

    fun registerApp(call: MethodCall, result: MethodChannel.Result) {
        Log.d("钉钉Registrar：", "context:${context != null}")
        if (iddShareApi != null){
            result.success(true)
            return
        }
        val appId: String? = call.argument("appId")
        if (appId.isNullOrBlank()){
            result.error(CallResult.Result_APPID_NULL,"not set AppId",null)
            return
        }
        iddShareApi = DDShareApiFactory.createDDShareApi(context,appId,true)
        result.success(true)
    }

    fun unregisterApp(result: MethodChannel.Result){
        iddShareApi?.unregisterApp()
        result.success(true)
    }

    fun checkInstall(result: MethodChannel.Result) {
        if (iddShareApi == null)
            result.error(CallResult.RESULT_API_NULL, "DingDing Api Not Registered", null)
        else
            result.success(iddShareApi!!.isDDAppInstalled)
    }

    fun isDingTalkSupportSSO(result: MethodChannel.Result) {
        if (iddShareApi == null)
            result.error(CallResult.RESULT_API_NULL, "DingDing Api Not Registered", null)
        else
            result.success(iddShareApi!!.isDDSupportDingAPI)
    }

    fun openDingtalk(result: MethodChannel.Result) {
        if (iddShareApi == null)
            result.error(CallResult.RESULT_API_NULL, "DingDing Api Not Registered", null)
        else
            result.success(iddShareApi!!.openDDApp())
    }

    fun sendAuth(call: MethodCall, result: MethodChannel.Result) {
        val req = SendAuth.Req()
        req.scope = SendAuth.Req.SNS_LOGIN;
        req.state = call.argument<String>("state") ?: "state";
        if (iddShareApi == null) {
            result.error(CallResult.RESULT_API_NULL, "DingDing Api Not Registered", null)
        } else if (!iddShareApi!!.isDDAppInstalled) {
            result.error(CallResult.RESULT_NOT_INSTALLED, "DingDing not installed", null)
        } else if (!iddShareApi!!.isDDAppInstalled) {
            result.error(CallResult.RESULT_NOT_INSTALLED, "DingDing not installed", null)
        } else if (req.supportVersion > iddShareApi!!.ddSupportAPI) {
            //钉钉版本过低，不支持登录授权
            result.error(CallResult.RESULT_VERSION_IS_TOO_LOW, "DingDing version is too low", null)
        } else {
            result.success(iddShareApi?.sendReq(req))
        }
    }

    /**
     * 分享文本消息
     */
    fun sendTextMessage(args: Map<String?, Any?>, result: MethodChannel.Result?) {
        val text = args["text"] as String?
        val isSendDing = args["isSendDing"] as Boolean

        //初始化一个DDTextMessage对象
        val textObject = DDTextMessage()
        textObject.mText = text

        //用DDTextMessage对象初始化一个DDMediaMessage对象
        val mediaMessage = DDMediaMessage()
        mediaMessage.mMediaObject = textObject

        //构造一个Req
        val req = SendMessageToDD.Req()
        req.mMediaMessage = mediaMessage

        //调用api接口发送消息到钉钉
        if (isSendDing) {
            iddShareApi!!.sendReqToDing(req)
        } else {
            iddShareApi!!.sendReq(req)
        }
    }

    /**
     * 分享网页消息
     */
    fun sendWebPageMessage(args: Map<String?, Any?>, result: MethodChannel.Result?) {
        val mUrl = args["url"] as String?
        val isSendDing = args["isSendDing"] as Boolean

        //初始化一个DDWebpageMessage并填充网页链接地址
        val webPageObject = DDWebpageMessage()
        webPageObject.mUrl = mUrl

        //构造一个DDMediaMessage对象
        val webMessage = DDMediaMessage()
        webMessage.mMediaObject = webPageObject
        webMessage.mTitle = args["title"] as String?
        webMessage.mContent = args["content"] as String?
        webMessage.mThumbUrl = args["thumbUrl"] as String?
        // 网页分享的缩略图也可以使用bitmap形式传输
//         webMessage.setThumbImage(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher));

        //构造一个Req
        val webReq = SendMessageToDD.Req()
        webReq.mMediaMessage = webMessage
        //        webReq.transaction = buildTransaction("webpage");

        //调用api接口发送消息到支付宝
        if (isSendDing) {
            iddShareApi!!.sendReqToDing(webReq)
        } else {
            iddShareApi!!.sendReq(webReq)
        }
    }

    /**
     * 分享图片消息
     */
    fun sendImageMessage(args: Map<String?, Any?>, result: MethodChannel.Result) {
        val isSendDing = args["isSendDing"] as Boolean
        //初始化一个DDImageMessage
        val imageObject = DDImageMessage()


        //url图片
        if (args["picUrl"] != null) {
            val picUrl = args["picUrl"] as String?
            imageObject.mImageUrl = picUrl
        } else if (args["picPath"] != null) {
            //本地图片
            val picPath = args["picPath"] as String?
            val file = File(picPath)
            if (!file.exists()) {
                Log.d("FlutterDDShareLog", "图片路径无效: $picPath")
                result.error("picPath error", "图片路径无效", picPath)
            } else {
                imageObject.mImagePath = picPath
            }
        } else {
            Log.d("FlutterDDShareLog", "无图片来源")
            result.error("Image error", "请传输图片来源", null)
        }


        //构造一个mMediaObject对象
        val mediaMessage = DDMediaMessage()
        mediaMessage.mMediaObject = imageObject

        //构造一个Req
        val req = SendMessageToDD.Req()
        req.mMediaMessage = mediaMessage
        //        req.transaction = buildTransaction("image");

        //调用api接口发送消息到支付宝
        if (isSendDing) {
            iddShareApi!!.sendReqToDing(req)
        } else {
            iddShareApi!!.sendReq(req)
        }
    }

    fun handleIntent(var1: Intent?, var2: IDDAPIEventHandler?) {
        try {
            iddShareApi!!.handleIntent(var1, var2)
        } catch (e: Exception) {
            e.printStackTrace()
            Log.d("FlutterDDShareLog", "e===========>$e")
        }
    }

}
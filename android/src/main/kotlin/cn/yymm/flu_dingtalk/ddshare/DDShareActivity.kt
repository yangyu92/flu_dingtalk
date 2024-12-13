package cn.yymm.flu_dingtalk.ddshare

import android.app.Activity
import android.os.Bundle
import android.util.Log
import cn.yymm.flu_dingtalk.FluDTAuthorizeResp
import cn.yymm.flu_dingtalk.FluDTShareResp
import cn.yymm.flu_dingtalk.IDDShareApiHandler
import com.android.dingtalk.share.ddsharemodule.IDDAPIEventHandler
import com.android.dingtalk.share.ddsharemodule.ShareConstant
import com.android.dingtalk.share.ddsharemodule.message.BaseReq
import com.android.dingtalk.share.ddsharemodule.message.BaseResp
import com.android.dingtalk.share.ddsharemodule.message.SendAuth
import com.android.dingtalk.share.ddsharemodule.message.SendMessageToDD

open class DDShareActivity : Activity(), IDDAPIEventHandler {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            IDDShareApiHandler.iddShareApi?.handleIntent(intent, this)
        } catch (e: Exception) {
            e.printStackTrace()
            Log.d("yy", "e===========>$e")
        }
        finish()
    }

    override fun onResp(baseResp: BaseResp) {
        val errCode = baseResp.mErrCode
        Log.d("yy", "errorCode==========>$errCode")
        val errMsg = baseResp.mErrStr
        Log.d("yy", "errMsg==========>$errMsg")
        if (baseResp.type == ShareConstant.COMMAND_SENDAUTH_V2 && baseResp is SendAuth.Resp) {//登陆
            handleAuthResponse(baseResp)
        } else if (baseResp is SendMessageToDD.Resp) {
            handleSendMessageResp(baseResp)
        }
    }

    override fun onReq(baseResp: BaseReq) {
        Log.d("yy", "onReq=============>")
    }

    private fun handleAuthResponse(response: SendAuth.Resp) {
        Log.d("yy", "AuthResponse =============> ${response.code}")
        val authResp = FluDTAuthorizeResp("${response.mErrCode}", "", response.code, response.state)
        IDDShareApiHandler.dingTalkEvent?.onAuthResponse(authResp) { result ->
            result.onSuccess {
                println("Authentication successful!")
            }.onFailure { error ->
                println("Authentication failed: ${error.message}")
            }
        }
    }

    private fun handleSendMessageResp(message: SendMessageToDD.Resp) {
        Log.d("yy", "SendMessage =============> ${message.mErrCode}")
        val response = FluDTShareResp("${message.mErrCode}", "", message.mErrCode == 0)
        IDDShareApiHandler.dingTalkEvent?.onShareResponse(response) { }
    }
}
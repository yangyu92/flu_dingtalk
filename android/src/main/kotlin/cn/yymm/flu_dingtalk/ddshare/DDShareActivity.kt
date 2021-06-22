package cn.yymm.flu_dingtalk.ddshare

import android.app.Activity
import android.os.Bundle
import android.util.Log
import com.android.dingtalk.share.ddsharemodule.IDDAPIEventHandler
import com.android.dingtalk.share.ddsharemodule.message.BaseReq
import com.android.dingtalk.share.ddsharemodule.message.BaseResp
import cn.yymm.flu_dingtalk.handlers.IDDShareApiHandler
import cn.yymm.flu_dingtalk.handlers.IDDShareResponseHandler
import java.lang.Exception

open class DDShareActivity :Activity(), IDDAPIEventHandler{

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            IDDShareApiHandler.iddShareApi?.handleIntent(intent,this)
        }catch (e: Exception){
            e.printStackTrace()
            Log.d("lzc", "e===========>$e")
        }
        finish()
    }

    override fun onResp(p0: BaseResp?) {
//        TODO("Not yet implemented")
        if (p0 != null) {
            IDDShareResponseHandler.handleResponse(p0)
        }
    }

    override fun onReq(p0: BaseReq?) {
//        TODO("Not yet implemented")
    }
}
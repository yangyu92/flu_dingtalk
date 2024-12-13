package cn.yymm.flu_dingtalk

import android.app.Activity
import com.android.dingtalk.share.ddsharemodule.IDDShareApi
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

object IDDShareApiHandler {
    var iddShareApi: IDDShareApi? = null
    var dingTalkEvent: FluDingTalkEventApi? = null

    private var binding: ActivityPluginBinding? = null

    val activity: Activity
        get() {
            val binding =
                this.binding ?: throw FluDingtalkPluginFlutterError(
                    "-1",
                    "Plugin hasn't been attached to an Activity"
                )
            return binding.activity
        }

    fun setRegister(register: ActivityPluginBinding?) {
        this.binding = register
    }
}
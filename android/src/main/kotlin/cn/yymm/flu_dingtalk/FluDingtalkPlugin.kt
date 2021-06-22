package cn.yymm.flu_dingtalk

import androidx.annotation.NonNull
import cn.yymm.flu_dingtalk.constant.Methods
import cn.yymm.flu_dingtalk.handlers.IDDShareApiHandler
import cn.yymm.flu_dingtalk.handlers.IDDShareResponseHandler

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FluDingtalkPlugin */
class FluDingtalkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flu_dingtalk")
    channel.setMethodCallHandler(this)
    IDDShareResponseHandler.setMethodChannel(channel)
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flu_dingtalk")
      channel.setMethodCallHandler(FluDingtalkPlugin())
      IDDShareApiHandler.setRegister(registrar.activity())
      IDDShareResponseHandler.setMethodChannel(channel)
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method){
      Methods.OPENAPI_VERSION -> {
        IDDShareApiHandler.openAPIVersion(call,result)
      }
      Methods.REGISTER_APP -> {
        IDDShareApiHandler.registerApp(call,result)
      }
      Methods.UNREGISTER_APP -> {
        IDDShareApiHandler.unregisterApp(result)
      }
      Methods.IS_Ding_Ding_INSTALLED -> {
        IDDShareApiHandler.checkInstall(result)
      }
      Methods.ISDINGTALK_SUPPORTSSO -> {
        IDDShareApiHandler.isDingTalkSupportSSO(result)
      }
      Methods.OPEN_DINGTALK -> {
        IDDShareApiHandler.openDingtalk(result)
      }
      Methods.SEND_AUTH -> {
        IDDShareApiHandler.sendAuth(call,result)
      }
      Methods.SEND_TEXT_MESSAGE -> {
        IDDShareApiHandler.sendTextMessage(call.arguments as Map<String?, Any?>,result)
      }
      Methods.SEND_IMAGE_MESSAGE -> {
        IDDShareApiHandler.sendImageMessage(call.arguments as Map<String?, Any?>,result)
      }
      Methods.SEND_WEB_PAGE_MESSAGE -> {
        IDDShareApiHandler.sendWebPageMessage(call.arguments as Map<String?, Any?>,result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    IDDShareApiHandler.setRegister(null)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    IDDShareApiHandler.setRegister(binding.activity)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    IDDShareApiHandler.setRegister(binding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    IDDShareApiHandler.setRegister(null)
  }
}

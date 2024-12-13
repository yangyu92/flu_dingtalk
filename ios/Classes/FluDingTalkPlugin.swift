import Flutter
import UIKit

public class FluDingTalkPlugin: NSObject, FlutterPlugin, FluDingtalkPluginApi {
    var _appId: String!
    var bundleId: String!
    static var dingTalkEvent: FluDingTalkEventApi!
    
    public static func register(with registrar: any FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : FluDingtalkPluginApi & NSObjectProtocol = FluDingTalkPlugin.init()
        FluDingtalkPluginApiSetup.setUp(binaryMessenger: messenger, api: api);
        dingTalkEvent = FluDingTalkEventApi(binaryMessenger: messenger)
        registrar.addApplicationDelegate(api as! FlutterPlugin)
    }
    
    func registerApp(appId: String, iosBundleId: String) throws -> Bool {
        self._appId = appId
        self.bundleId = iosBundleId
        
        return DTOpenAPI.registerApp(appId);
    }
    
    func openAPIVersion() throws -> String {
        return DTOpenAPI.openAPIVersion() ?? "--"
    }
    
    func openDDApp(completion: @escaping (Result<Bool, any Error>) -> Void) {
        DTOpenAPI.openDingTalk { result in
            completion(.success(result))
        }
    }
    
    func isDingDingInstalled() throws -> Bool {
        return DTOpenAPI.isDingTalkInstalled()
    }
    
    func isDingTalkSupportSSO() throws -> Bool {
        return DTOpenAPI.isDingTalkSupportSSO()
    }
    
    func sendAuth(authReq: DTAuthReq, completion: @escaping (Result<Bool, any Error>) -> Void) {
        let req = DTAuthorizeReq()
        // 必选参数
        req.redirectURI = authReq.redirectURI
        req.bundleId = self.bundleId
        DTOpenAPI.send(req) { result in
            completion(.success(result))
        }
    }
    
    func sendTextMessage(text: String, completion: @escaping (Result<Bool, any Error>) -> Void) {
        let req = DTSendMessageToDingTalkReq()
        let mediaMessage = DTMediaMessage()
        let textObject = DTMediaTextObject()
        textObject.text = text
        mediaMessage.mediaObject = textObject
        req.message = mediaMessage
        
        DTOpenAPI.send(req) { result in
            completion(.success(result))
        }
    }
    
    func sendWebPageMessage(url: String, title: String, content: String, thumbUrl: String, completion: @escaping (Result<Bool, any Error>) -> Void) {
        let req = DTSendMessageToDingTalkReq()
        let mediaMessage = DTMediaMessage()
        let webObject = DTMediaWebObject()
        webObject.pageURL = url
        mediaMessage.title = title
        mediaMessage.thumbURL = thumbUrl
        mediaMessage.messageDescription = content
        mediaMessage.mediaObject = webObject
        req.message = mediaMessage
        
        DTOpenAPI.send(req) { result in
            completion(.success(result))
        }
    }
    
    func sendImageMessage(picUrl: String?, picPath: String?, completion: @escaping (Result<Bool, any Error>) -> Void) {
        let req = DTSendMessageToDingTalkReq()
        let mediaMessage = DTMediaMessage()
        let imageObject = DTMediaImageObject()
        imageObject.imageData = Data()
        imageObject.imageURL = picUrl
        
        mediaMessage.mediaObject = imageObject
        req.message = mediaMessage
        
        DTOpenAPI.send(req) { result in
            completion(.success(result))
        }
    }
    
    // MARK: ApplicatioonLifeCycle
    
    func handleOpenURL(url: URL) -> Bool {
        if(url.scheme == _appId) {
            return DTOpenAPI.handleOpen(url, delegate: self)
        }
        return false
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return handleOpenURL(url: url)
    }
    
    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return handleOpenURL(url: url)
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any) -> Bool {
        return handleOpenURL(url: url)
    }
}


// MARK: - 钉钉协议实现
extension FluDingTalkPlugin : DTOpenAPIDelegate {
    // MARK: - 导航栏 自定义标题 通用组件
    
    public func onReq(_ req: DTBaseReq!) {
        print("onReq")
    }
    
    public func onResp(_ resp: DTBaseResp!) {
        if(resp is DTAuthorizeResp) {
            let authResp = resp as! DTAuthorizeResp
            print("DTAuthorizeResp", authResp.accessCode ?? "")
            let response = FluDTAuthorizeResp(
                errorCode: "\(authResp.errorCode.rawValue)",
                errorMessage: authResp.errorMessage,
                accessCode: authResp.accessCode)
            FluDingTalkPlugin.dingTalkEvent.onAuthResponse(authResp: response) { _ in }
        } else if(resp is DTSendMessageToDingTalkResp) {
            let shareResp = resp as! DTSendMessageToDingTalkResp
            print("DTAuthorizeResp", shareResp.errorCode, shareResp.errorMessage ?? "")
            let response = FluDTShareResp(
                errorCode: "\(shareResp.errorCode.rawValue)" ,
                errorMessage: shareResp.errorMessage,
                shareResult: shareResp.errorCode == DTOpenAPIErrorCode.success)
            FluDingTalkPlugin.dingTalkEvent.onShareResponse(shareResp: response) { _ in }
        } else {
            let response = DTBaseResponse(
                errorCode: "\(resp.errorCode.rawValue)" ,
                errorMessage: resp.errorMessage)
            FluDingTalkPlugin.dingTalkEvent.onBaseResponse(response: response) { _ in }
        }
    }
}

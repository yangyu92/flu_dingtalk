//
//  ApiHandler.m
//  flutter_dingtalk
//
//  Created by 候建斌 on 2021/4/28.
//

#import "ApiHandler.h"
#import <DTShareKit/DTOpenAPIObject.h>
#import <DTShareKit/DTOpenKit.h>
#import <DTShareKit/DTOpenAPI.h>
@interface ApiHandler(){
    FlutterMethodChannel *_methodChannel;
}
@end

@implementation ApiHandler
- (instancetype) initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar methodChannel:(FlutterMethodChannel *)flutterMethodChannel{
    self=[super init];
    if(self){
        _methodChannel=flutterMethodChannel;
    }
    return self;
}

- (void)openAPIVersion:(FlutterMethodCall *)call result:(FlutterResult)result{
    result([@"version: " stringByAppendingString: [DTOpenAPI openAPIVersion]]);
}

- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSDictionary<NSString *,id> *args=(NSDictionary<NSString *,id> *)[call arguments];
    NSString* appId=(NSString*) args[@"appId"];
    BOOL registerResult= [DTOpenAPI registerApp: appId];
    NSLog(@"[FlutterDDShareLog]:注册API==>%@",registerResult?@"YES":@"NO");
    result(@(registerResult));
}

- (void)isDDAppInstalled:(FlutterMethodCall *)call result:(FlutterResult)result{
    BOOL installed=[DTOpenAPI isDingTalkInstalled];
    result(@(installed));
}

- (void)isDingTalkSupportSSO:(FlutterMethodCall *)call result:(FlutterResult)result{
    BOOL res=[DTOpenAPI isDingTalkSupportSSO];
    result(@(res));
}

- (void)openDingTalk:(FlutterMethodCall *)call result:(FlutterResult)result{
    BOOL res=[DTOpenAPI openDingTalk];
    result(@(res));
}

- (void)sendAuth:(FlutterMethodCall *)call result:(FlutterResult)result bundleId:(NSString *)bundleId{
    // send oauth request
    DTAuthorizeReq *authReq = [DTAuthorizeReq new];
    NSLog(@"%@", bundleId);
    authReq.bundleId = bundleId;
    BOOL isDingTalkSupport=[DTOpenAPI isDingTalkSupportSSO];
    if (isDingTalkSupport) {
        BOOL authResult = [DTOpenAPI sendReq:authReq];
        if (result) {
            NSLog(@"[FlutterDDShareLog]授权登录 发送成功.");
            result([NSNumber numberWithBool:authResult]);
        }
        else {
            NSLog(@"[FlutterDDShareLog]授权登录 发送失败.");
            result([FlutterError errorWithCode:@"authError" message:@"授权失败" details:authReq]);
        }
    } else {
        result([FlutterError errorWithCode:@"authError" message:@"授权失败" details:nil]);
    }
}

- (void)sendTextMessage:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSDictionary<NSString *,id> *args=(NSDictionary<NSString *,id> *)[call arguments];
    NSString* text=(NSString*) args[@"text"];
    
    DTSendMessageToDingTalkReq *sendMessageReq = [[DTSendMessageToDingTalkReq alloc] init];
    
    DTMediaMessage *mediaMessage = [[DTMediaMessage alloc] init];
    
    DTMediaTextObject *textObject = [[DTMediaTextObject alloc] init];
    textObject.text = text;
    
    mediaMessage.mediaObject = textObject;
    sendMessageReq.message = mediaMessage;
    
    BOOL apiResult = [DTOpenAPI sendReq:sendMessageReq];
    if (apiResult)
    {
        NSLog(@"[FlutterDDShareLog]发送成功.");
        result(@(apiResult));
    }
    else
    {
        NSLog(@"[FlutterDDShareLog]发送失败.");
        result([FlutterError errorWithCode:@"ShareError" message:@"分享文本失败" details:nil]);
    }
}

- (void)sendWebPageMessage:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSDictionary<NSString *,id> *args=(NSDictionary<NSString *,id> *)[call arguments];
    NSString* mUrl=(NSString*) args[@"url"];
    
    DTSendMessageToDingTalkReq *sendMessageReq = [[DTSendMessageToDingTalkReq alloc] init];
    
    DTMediaMessage *mediaMessage = [[DTMediaMessage alloc] init];
    DTMediaWebObject *webObject = [[DTMediaWebObject alloc] init];
    webObject.pageURL = mUrl;
    
    mediaMessage.title = (NSString*) args[@"title"];
    
    mediaMessage.thumbURL = (NSString*) args[@"thumbUrl"];
    
    // Or Set a image data which less than 32K.
    // mediaMessage.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"open_icon"]);
    
    mediaMessage.messageDescription = (NSString*) args[@"content"];
    mediaMessage.mediaObject = webObject;
    sendMessageReq.message = mediaMessage;
    
    BOOL apiResult = [DTOpenAPI sendReq:sendMessageReq];
    if (apiResult)
    {
        NSLog(@"[FlutterDDShareLog]发送成功.");
        result(@(apiResult));
    }
    else
    {
        NSLog(@"[FlutterDDShareLog]发送失败.");
        result([FlutterError errorWithCode:@"ShareError" message:@"分享链接失败" details:nil]);
    }
}

- (void)sendImageMessage:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSDictionary<NSString *,id> *args=(NSDictionary<NSString *,id> *)[call arguments];
    NSString* imageUrl=(NSString*) args[@"picUrl"];
    
    DTSendMessageToDingTalkReq *sendMessageReq = [[DTSendMessageToDingTalkReq alloc] init];
    
    DTMediaMessage *mediaMessage = [[DTMediaMessage alloc] init];
    
    DTMediaImageObject *imageObject = [[DTMediaImageObject alloc] init];
    imageObject.imageData = [NSData data];
    imageObject.imageURL = imageUrl;
    
    mediaMessage.mediaObject = imageObject;
    sendMessageReq.message = mediaMessage;
    
    BOOL apiResult = [DTOpenAPI sendReq:sendMessageReq];
    if (apiResult)
    {
        NSLog(@"[FlutterDDShareLog]发送成功.");
        result(@(apiResult));
    }
    else
    {
        NSLog(@"[FlutterDDShareLog]发送失败.");
        result([FlutterError errorWithCode:@"ShareError" message:@"分享图片失败" details:nil]);
    }
}

@end



#import "LKSDKManager.h"

#import "LKSystem.h"
#import "LKSDKConfigApi.h"
#import "LKAFManager.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "LKGlobalConf.h"
#import "LKOauthManager.h"
#import "LKPayManager.h"
#import "LKAFManager.h"
#import "LKAdManager.h"
#import "LKSDKConfigApi.h"
#import "LKSDKConfig.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "LKPointManager.h"
#import "LKPointApi.h"
#import "LKTaptapUpload.h"
#import "LKApplePayManager.h"
#import "LKLog.h"
#import "LKAdFace.h"
#import <GravityEngineSDK/GravityEngineSDK.h>
#import <DouyinOpenSDK/DouyinOpenSDKApplicationDelegate.h>

@interface LKSDKManager ()<UIApplicationDelegate>
/// 授权管理类
@property (nonatomic, strong) LKOauthManager *oauthManager;
/// 支付管理类
@property (nonatomic, strong) LKPayManager *payManager;
/// 数据分析管理类
@property (nonatomic, strong) LKAFManager *afManager;
/// 广告管理对象
@property (nonatomic, strong) LKAdManager *adManager;
@property (nonatomic, strong) LKAdFace *adFace;

/// 打点管理类
@property (nonatomic, strong) LKPointManager *pointManager;


@property (nonatomic, copy) void(^registerSDKComplete)(LKSDKManager *manager,NSError *error);



@end

static LKSDKManager *instance = nil;
static GravityEngineSDK *gravityEngine = nil;

@implementation LKSDKManager


+ (instancetype)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LKSDKManager alloc] init];

    });
    return instance;
}
#pragma mark -- 初始化SDK
//- (void)loadSDKConfig:(NSString *)appId{
//
//
//    [LKSDKConfigApi fetchSDKConfigAppId:appId complete:^(NSError * _Nullable error) {
//        if (error == nil) {
//            [self initializeOtherManager];
//
//            // 判断KEY 和 SECRT 是否正确
//            [self verifyAppIdAndsecretKey];
//
//            // 注册广告
////            [[LKAdManager shared] registerAggregateAd];
//            [[LKAdFace shared] registerAggregateAd];
//
//        }else{
//            LKLogInfo(@"==SDK初始化失败==");
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([self.delegate respondsToSelector:@selector(lkSDKInitializeManager:withFail:)]) {
//                [self.delegate lkSDKInitializeManager:self withFail:error];
//            }
//            if (self.registerSDKComplete) {
//                self.registerSDKComplete(self, error);
//            }
//
//            if (self.initializeSDKCallBack) {
//                self.initializeSDKCallBack(self, error);
//            }
//        });
//    }];
//
//}



- (void)loadSDKConfig:(NSString *)appId{

    [LKSDKConfigApi fetchSDKConfigURLWithAppId:appId complete:^(NSString * _Nullable url, NSError * _Nullable error) {
        if (url.exceptNull != nil && error == nil) {
            // 添加时间参数确保每次请求都是最新的
            NSString *separator = [url containsString:@"?"]? @"&":@"?";
            NSString *urlWithTimestamp=[ NSString stringWithFormat:@"%@%@_t=%ld", url, separator, (long) [[NSDate date] timeIntervalSince1970] *1000];
            [self loadSDKConfigJsonWithURL:urlWithTimestamp];
//            [self loadSDKConfigJsonWithURL:url];
        }else{
            LKLogError(@"error:%@",error);
        }
    }];

}

- (void)loadSDKConfigJsonWithURL:(NSString *)url{
    [LKSDKConfigApi fetchSDKConfigWithURL:url complete:^(NSError * _Nullable error) {
        if (error == nil) {
            [self initializeOtherManager];

            // 判断KEY 和 SECRT 是否正确
            [self verifyAppIdAndsecretKey];

            // 注册广告
//            [[LKAdManager shared] registerAggregateAd];
            [[LKAdFace shared] registerAggregateAd];
            

        }else{
            LKLogInfo(@"==SDK初始化失败==");
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(lkSDKInitializeManager:withFail:)]) {
                [self.delegate lkSDKInitializeManager:self withFail:error];
            }
            if (self.registerSDKComplete) {
                self.registerSDKComplete(self, error);
            }

            if (self.initializeSDKCallBack) {
                self.initializeSDKCallBack(self, error);
            }
        });
    }];
}




- (void)verifyAppIdAndsecretKey{
    
//    LKSDKConfig *sdkConfig =[LKSDKConfig getSDKConfig];
//    NSDictionary *sdk_config = sdkConfig.sdk_config;
    
//    NSString *key_ios = sdk_config[@"key_ios"];
//    NSString *app_id_ios = sdk_config[@"app_id_ios"];
    
//    LKSystem *system = [LKSystem getSystem];
    
//    if (system.appID.exceptNull == nil) {
//         NSAssert(system.appID.exceptNull != nil, @"appid Can not be empty");
//        LKLogInfo(@"appID is empty");
//    }
//    if (system.secretkey.exceptNull == nil) {
//         NSAssert(system.secretkey.exceptNull != nil, @"secretkey Can not be empty");
//        LKLogInfo(@"secretkey is empty");
//    }
    
//     NSAssert([system.appID isEqualToString:app_id_ios], @"appId is incorrect");
//     NSAssert([system.secretkey isEqualToString:key_ios], @"secretkey is incorrect");

}


/// 注册SDK
- (void)registLinKingSDKAppID:(NSString * _Nonnull)appId withSecretkey:(NSString * _Nonnull)secretkey cmoplete:(void(^_Nonnull)(LKSDKManager *_Nullable manager,NSError * _Nullable error))complete{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SYSTEMSDK"];
    LKSystem *system = [LKSystem getSystem];
    system.appID = appId;
    system.secretkey = secretkey;
    
    [[NSUserDefaults standardUserDefaults] setObject:appId forKey:@"SDK_APPID"];
    [[NSUserDefaults standardUserDefaults] setObject:secretkey forKey:@"SDK_SECRETKEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [LKSystem setSystem:system];
    
    [instance loadSDKConfig:appId];
    
    self.registerSDKComplete = complete;
}

- (void)initializeOtherManager{
    self.oauthManager = [LKOauthManager instance];
    self.payManager = [LKPayManager instance];
    self.afManager = [LKAFManager shared];
    self.adFace = [LKAdFace shared];
    self.pointManager = [LKPointManager shared];
    [LKPointApi pointEventName:@"Activation" withTp:@"Activation" withValues:nil complete:^(NSError * _Nonnull error) {
    }];
    // 引力引擎
    [self initGravityEngineAndTap];
    
    // 抖音登录初始化
    LKSDKConfig *config =  [LKSDKConfig getSDKConfig];
    if (config.douyin_config != nil) {
        NSString *client_key = config.douyin_config[@"client_key"];
        NSString *btn_login_visible = config.douyin_config[@"btn_login_visible"];
        if (client_key!=nil && [@"1" isEqualToString:btn_login_visible] ) {
//            NSString *clientKey = @"awp7vsk6aly1jpqw";//com.linking.wzsyr
            [[DouyinOpenSDKApplicationDelegate sharedInstance] registerAppId:client_key];
            LKLogInfo(@"douyin_config info client_key=%@,btn_login_visible=%@", client_key, btn_login_visible);
        }
    }
    
    // 军娜taptap的php服务端上报
    [LKTaptapUpload uploadTaptapType:@"1" withAmount:@"0" withPayType:@"" complete:nil];
}

- (void)initGravityEngineAndTap {
    NSDictionary *gravityengine_config=[LKSDKConfig getGravityEngineFromConfig];
    if (gravityengine_config!=nil) {
        NSString * use_flag=gravityengine_config[@"use_flag"];
        NSString * appId3=gravityengine_config[@"app_id"];
        NSString * token3=gravityengine_config[@"access_token"];
        LKLogInfo(@"gravityengine_config info use_flag=%@,app_id=%@, access_token=%@", use_flag, appId3, token3);
        if ([@"1" isEqualToString:use_flag]) {
            //初始化引力引擎
            GEConfig *config = [GEConfig new];
            config.appid = appId3;
            config.accessToken = token3;
            [GravityEngineSDK startWithConfig:config];
            gravityEngine = [GravityEngineSDK sharedInstanceWithAppid:config.appid];
            // 开启自动采集
            [gravityEngine enableAutoTrack:GravityEngineEventTypeAll];
            [gravityEngine initializeGravityEngineWithAsaEnable:NO withClientId:nil withCaid1:nil withCaid2:nil withSyncAttribution:NO withChannel:@"AppStore" withSuccessCallback:^(NSDictionary * _Nonnull response) {
                LKLogInfo(@"gravity engine initialize success, response is %@", response);
                //注册上报
                [gravityEngine trackRegisterEvent];
            } withErrorCallback:^(NSError * _Nonnull error) {
                LKLogInfo(@"gravity engine initialize failed, and error is %@", error);
            }];
            
        }
    }
    
    
}

- (void)registAnalysis{
    /// 注册AF（如需使用AppsFlyer）
    [[LKAFManager shared] registAppsFlyer];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions {


        
    // 开启监听支付
    [[LKApplePayManager shared] startManager];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    

    
    [[AppsFlyerLib shared] start];
}
- (void)applicationWillTerminate:(UIApplication *)application{
    [[LKApplePayManager shared] stopManager];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    return  YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    

     [[AppsFlyerLib shared] handleOpenUrl:url options:options];
    
    if ([[DouyinOpenSDKApplicationDelegate sharedInstance] application: app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]
        ) {
        return YES;
    }
     return YES;
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
     [[AppsFlyerLib shared] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    
    if ([[DouyinOpenSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return YES;
    }

    return YES;
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[AppsFlyerLib shared] handlePushNotification:userInfo];
}


//========适配了SceneDelegate的App
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts API_AVAILABLE(ios(13.0)){
    UIOpenURLContext *context = URLContexts.allObjects.firstObject;
    NSURL* url = context.URL;
   if(url){

       // AF
       [[AppsFlyerLib shared] handleOpenUrl:url options:nil];
   }
}
// AppDelegate:
//  注意：适配了SceneDelegate的App，系统将会回调SceneDelegate的continueUserActivity方法，所以需要重写SceneDelegate的该方法。
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    
    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:restorationHandler];

    return YES;
}

// SceneDelegate:
- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity  API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0)){

}

- (void)geTrackPayEventWithAmount:(int)payAmount withPayType:(NSString *)payType withOrderId:(NSString *)orderId withPayReason:(NSString *)payReason withPayMethod:(NSString *)payMethod{
    if (gravityEngine!=nil) {
        [gravityEngine trackPayEventWithAmount:payAmount withPayType:payType withOrderId:orderId withPayReason:payReason withPayMethod:payMethod];
        NSLog(@"gravity TrackPayEventWithAmount=%d,payType=%@,orderId=%@, payReason=%@, payMethod=%@", payAmount, payType, orderId, payReason, payMethod);
    }
}



@end

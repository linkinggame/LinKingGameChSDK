
#import <UIKit/UIKit.h>

@class LKOauthManager;
@class LKPayManager;
@class LKAFManager;
@class LKAdManager;
@class LKSDKManager;
@class LKPointManager;
@class LKAdFace;
NS_ASSUME_NONNULL_BEGIN


@protocol LKSDKManagerDelegate <NSObject>

@required
- (void)lkSDKInitializeManager:(LKSDKManager *)manager withFail:(NSError *)error;
@end

@interface LKSDKManager : NSObject

@property (nonatomic, copy) void(^initializeSDKCallBack)(LKSDKManager * _Nullable manager,NSError * _Nullable error);
/// 授权管理类
@property (nonatomic, strong,readonly) LKOauthManager *oauthManager;
/// 支付管理类
@property (nonatomic, strong,readonly) LKPayManager *payManager;
/// 数据分析管理类
@property (nonatomic, strong,readonly) LKAFManager *afManager;
/// 广告管理对象
@property (nonatomic, strong,readonly) LKAdManager *adManager;
/// 广告管理对象
@property (nonatomic, strong,readonly) LKAdFace *adFace;
/// 打点管理类
@property (nonatomic, strong,readonly) LKPointManager *pointManager;

@property (nonatomic, weak) id<LKSDKManagerDelegate>delegate;

+ (instancetype)instance;


/// 注册数据分析
- (void)registAnalysis;
/// 注册SDK
/// @param appId  平台分发的appId
/// @param secretkey 平台分发的key
/// @param complete 完成注册的回调
- (void)registLinKingSDKAppID:(NSString * _Nonnull)appId withSecretkey:(NSString * _Nonnull)secretkey cmoplete:(void(^_Nonnull)(LKSDKManager *_Nullable manager,NSError * _Nullable error))complete;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions;

- (void)applicationWillTerminate:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity  API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0));

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts API_AVAILABLE(ios(13.0));


@end

NS_ASSUME_NONNULL_END

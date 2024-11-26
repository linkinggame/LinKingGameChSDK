#import <UIKit/UIKit.h>
#import "LKRealNameVerify.h"
NS_ASSUME_NONNULL_BEGIN

@class LKUser;
@protocol LKOauthManagerDelegate <NSObject>
/// 退出登录
- (void)logoutSDKCallback;
- (void)changeAccountCallBack;
@end

@interface LKOauthManager : NSObject
+ (instancetype)instance;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, weak) id <LKOauthManagerDelegate>delegate;
@property (nonatomic,copy)void(^bindingAccountCompleteCallBack)(LKUser * _Nullable user,NSError *_Nullable error);

/// 实名认证接口调用回调
@property (nonatomic,copy)void(^realNameCompleteCallBack)(BOOL isSuccess,LKUser * _Nullable user,NSError *_Nullable error);
/// 是否已经实名
- (BOOL)isRealName;
/// 防沉迷弹框
- (void)showRealNameViewRootViewController:(UIViewController *)viewController complete:(void(^)(BOOL isCancel,NSError * _Nullable error))complete;
/// 获取当前实名认证状态
- (RealVerifyState)getRealVerifyState;
/// Dashboard授权面板
/// @param viewController 根控制器
/// @param complete 完成登录回调
- (void)loginWithDashboardRootViewController:(UIViewController *)viewController complete:(void(^)(LKUser * _Nullable user,NSError *_Nullable error))complete;
/// API方式登录
/// @param viewController 根控制器
/// @param complete 完成登录回调
- (void)loginApiWithRootViewController:(UIViewController *_Nullable)viewController complete:(void(^)(LKUser * _Nullable user,NSError * _Nullable error))complete;
/// 显示仪表盘
/// @param viewController 根控制器
- (void)showFloatViewDashboard:(UIViewController *)viewController;
// 隐藏仪表盘
- (void)hiddenFloatViewDashboard;
/// 退出登录
- (void)logOutSDK;

@end

NS_ASSUME_NONNULL_END

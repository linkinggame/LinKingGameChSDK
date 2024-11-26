

#import <UIKit/UIKit.h>


@class LKTitokExpressManager;
typedef NS_ENUM(NSInteger,LKPLATFORM) {
    LKPLATFORM_NONE,
    LKPLATFORM_Titok,
    LKPLATFORM_YLH,
    LKPLATFORM_TopOn
};

typedef NS_ENUM(NSInteger, LKADTYPE) {
    ADTYPE_REWARDVIDEO = 0,
    ADTYPE_INTERSTITAL = 1,
    ADTYPE_BANNER = 2,
};


typedef NS_ENUM(NSInteger,LKPAYUSERTYPE) {
    LK_UNDEFINED = 0,  // 未定义
    LK_PAY = 1,        // 付费
    LK_NOPAY = 2       // 非付费
};


NS_ASSUME_NONNULL_BEGIN
@protocol LKAdManagerDelegate <NSObject>

@optional


/// 横屏广告加载失败
/// @param error 错误信息
- (void)bannerAdDidLoadFail:(NSError * _Nullable)error;
/// 横屏广告点击关闭
- (void)bannerAdDidClose;
/// 横屏广告点击
- (void)bannerAdDidClick;
/// 横屏广告呈现成功
- (void)bannerAdDidVisible;


/// 激励视频加载失败
/// @param error 错误信息
- (void)rewardAdDidLoadFail:(NSError * _Nullable)error;
/// 激励视频点击关闭
- (void)rewardAdDidClose;
/// 激励视频点击
- (void)rewardAdDidClick;
/// 激励视频呈现成功
- (void)rewardAdDidVisible;
/// 获取奖励
- (void)rewardAdWinReward;



/// 插屏广告加载失败
/// @param error 错误信息
- (void)interstitialAdDidLoadFail:(NSError * _Nullable)error;
/// 插屏广告关闭
- (void)interstitialAdDidClose;
/// 插屏广告点击
- (void)interstitialAdDidClick;
/// 插屏广告呈现成功
- (void)interstitialAdDidVisible;

/// 广告加载成功
- (void)adDidFinishLoading:(LKADTYPE)type;

- (void)adDidFailToLoadCallBack:(NSError * _Nullable)error;


@end

@interface LKAdManager : NSObject
@property (nonatomic, assign,readonly) LKPLATFORM platform;
@property (nonatomic, weak) id <LKAdManagerDelegate>delegate;

+ (instancetype)shared;

/// 注册广告
- (void)registerAggregateAd;

/// 初始化广告
/// @param type 广告类型
/// @param viewController 控制器
/// @param superView 视图
- (void)initAd:(LKADTYPE)type rootViewController:(UIViewController * _Nonnull)viewController superView:(UIView * _Nullable)superView;

/// 展示横屏
- (void)showBanner;
/// 展现插屏
- (void)showInterstitialAd;
/// 展示激励视频广告
- (void)showRewardVideoAd;



/// 展示横屏
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showBannerPayuser:(LKPAYUSERTYPE)type;
/// 展现插屏
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showInterstitialAdPayuser:(LKPAYUSERTYPE)type;
/// 展示激励视频广告
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showRewardVideoAdPayuser:(LKPAYUSERTYPE)type;


@end

NS_ASSUME_NONNULL_END

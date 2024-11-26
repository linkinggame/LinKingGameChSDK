

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKTitokExpressManager : NSObject

///  横屏广告回调
// 加载
@property (nonatomic, copy) void(^bannerAdViewDidLoadCallBack)(void);
@property (nonatomic, copy) void(^bannerAdViewDidLoadFailCallBack)(NSError * _Nullable error);
// 渲染
@property (nonatomic, copy) void(^bannerAdViewRenderCallBack)(void);
@property (nonatomic, copy) void(^bannerAdViewRenderFailCallBack)(NSError * _Nullable error);
// 展现
@property (nonatomic, copy) void(^bannerAdViewVisibleCallBack)(void);
// 点击
@property (nonatomic, copy) void(^bannerAdViewDidClickCallBack)(void);
// 关闭原因
@property (nonatomic, copy) void(^bannerAdViewCloseReasonCallBack)(void);
// 跳转下载追踪
@property (nonatomic, copy) void(^bannerAdViewDidCloseOtherControllerCallBack)(void);

///  插屏广告回调
// 加载
@property (nonatomic, copy) void(^interstitialAdViewDidLoadCallBack)(void);
@property (nonatomic, copy) void(^interstitialAdViewDidLoadFailCallBack)(NSError * _Nullable error);
// 渲染
@property (nonatomic, copy) void(^interstitialAdViewRenderCallBack)(void);
@property (nonatomic, copy) void(^interstitialAdViewRenderFailCallBack)(NSError * _Nullable error);
// 展现
@property (nonatomic, copy) void(^interstitialAdViewVisibleCallBack)(void);
// 点击
@property (nonatomic, copy) void(^interstitialAdViewDidClickCallBack)(void);
// 将要关闭
@property (nonatomic, copy) void(^interstitialAdViewWillCloseCallBack)(void);
// 已经关闭
@property (nonatomic, copy) void(^interstitialAdViewDidCloseCallBack)(void);
// 跳转下载追踪
@property (nonatomic, copy) void(^interstitialAdViewDidCloseOtherControllerCallBack)(void);

///  激励广告回调
// 加载
@property (nonatomic, copy) void(^rewardAdViewDidLoadCallBack)(void);
@property (nonatomic, copy) void(^rewardAdViewDidLoadFailCallBack)(NSError * _Nullable error);
// 渲染
@property (nonatomic, copy) void(^rewardAdViewRenderCallBack)(void);
@property (nonatomic, copy) void(^rewardAdViewRenderFailCallBack)(NSError * _Nullable error);
// 开始下载
@property (nonatomic, copy) void(^rewardAdViewDidDownLoadCallBack)(void);
// 将要展现
@property (nonatomic, copy) void(^rewardAdViewWillVisibleCallBack)(void);
// 已经展现
@property (nonatomic, copy) void(^rewardAdViewDidVisibleCallBack)(void);
// 点击
@property (nonatomic, copy) void(^rewardAdViewDidClickCallBack)(void);
// 将要关闭
@property (nonatomic, copy) void(^rewardAdViewWillCloseCallBack)(void);
// 已经关闭
@property (nonatomic, copy) void(^rewardAdViewDidCloseCallBack)(void);
// 点击跳过
@property (nonatomic, copy) void(^rewardAdViewDidClickSkipCallBack)(void);
// 完成 发放奖励
@property (nonatomic, copy) void(^rewardAdViewDidPlayFinishCallBack)(NSError * _Nullable error);
// 服务成功
@property (nonatomic, copy) void(^rewardAdViewRewardDidSucceedCallBack)(void);
// 服务失败
@property (nonatomic, copy) void(^rewardAdViewRewardDidFailCallBack)(void);
// 跳转下载追踪
@property (nonatomic, copy) void(^rewardAdViewDidCloseOtherControllerCallBack)(void);

///  全屏广告的回调
// 加载
@property (nonatomic, copy) void(^fullscreenAdViewDidLoadCallBack)(void);
@property (nonatomic, copy) void(^fullscreenAdViewDidLoadFailCallBack)(NSError * _Nullable error);
// 渲染
@property (nonatomic, copy) void(^fullscreenAdViewRenderCallBack)(void);
@property (nonatomic, copy) void(^fullscreenAdViewRenderFailCallBack)(NSError * _Nullable error);
// 开始下载
@property (nonatomic, copy) void(^fullscreenAdViewDidDownLoadCallBack)(void);
// 将要展现
@property (nonatomic, copy) void(^fullscreenAdViewWillVisibleCallBack)(void);
// 已经展现
@property (nonatomic, copy) void(^fullscreenAdViewDidVisibleCallBack)(void);
// 点击
@property (nonatomic, copy) void(^fullscreenAdViewDidClickCallBack)(void);
// 将要关闭
@property (nonatomic, copy) void(^fullscreenAdViewWillCloseCallBack)(void);
// 已经关闭
@property (nonatomic, copy) void(^fullscreenAdViewDidCloseCallBack)(void);
// 点击跳过
@property (nonatomic, copy) void(^fullscreenAdViewDidClickSkipCallBack)(void);
// 完成
@property (nonatomic, copy) void(^fullscreenAdViewDidPlayFinishCallBack)(NSError * _Nullable error);
// 服务成功
@property (nonatomic, copy) void(^fullscreenAdViewRewardDidSucceedCallBack)(void);
// 服务失败
@property (nonatomic, copy) void(^fullscreenAdViewRewardDidFailCallBack)(void);
// 跳转下载追踪
@property (nonatomic, copy) void(^fullscreenAdViewDidCloseOtherControllerCallBack)(void);



+ (instancetype)shared;
/// 初始化Titok
- (void)initializeTitokAdConfig;

/// 初始化Banner广告
- (void)initializationTittokBannerRootViewController:(UIViewController *)viewController superView:(UIView *)superView frame:(CGRect)frame;
/// 展示Banner广告
- (void)showTittokBanner;
/// 移除Banner
- (void)removeBannerViewFromSuperView;


/// 初始化插屏广告
- (void)initializationTittokInterstitialAd:(UIViewController *)viewController;
/// 展现插屏
- (void)showTittokInterstitialAd;


/// 初始化激励视频广告
- (void)initializationTittokRewardVideoAd:(UIViewController *)viewController;
/// 展示激励视频广告
- (void)showTittokRewardVideoAd;


// 初始全屏广告
- (void)initializationTittokFullScreenVideoAd:(UIViewController *)viewController;;

// 展示全屏广告
- (void)showTittokFullScreenVideoAd;



@end


NS_ASSUME_NONNULL_END





#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LKTopOnManager : NSObject

@property (nonatomic, copy) void(^topOnAdDidFinishLoadingCallBack)(NSString *_Nullable placementID,NSString *adType);
@property (nonatomic, copy) void(^topOnAdDidFailToLoadCallBack)(NSString * _Nullable placementID,NSError * _Nullable error);

@property (nonatomic, copy) void(^rewardedVideoDidClickCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^rewardedVideoDidCloseCallBack)(NSString * _Nullable placementID,BOOL reward,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^rewardedVideoDidEndPlayingCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^rewardedVideoDidFailCallBack)(NSString * _Nullable placementID,NSError * _Nullable error,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^rewardedVideoDidRewardSuccessCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^rewardedVideoDidStartCallBack)(NSString * _Nullable placementID,NSDictionary *_Nullable extra);


@property (nonatomic, copy) void(^interstitialDidClickCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^interstitialDidCloseCallBack)(NSString * _Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^interstitialDidEndPlayingCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^interstitialDidFailCallBack)(NSString * _Nullable placementID,NSError * _Nullable error,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^interstitialDidShowCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^interstitialDidStartCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^interstitialFailedToShowCallBack)(NSString * _Nullable placementID,NSError * _Nullable error,NSDictionary *_Nullable extra);


@property (nonatomic, copy) void(^bannerViewDidAutoRefreshCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^bannerViewDidCloseCallBack)(NSString * _Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^bannerViewDidClickCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^bannerViewDidShowAdCallBack)(NSString * _Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^bannerViewDidTapCloseCallBack)(NSString *_Nullable placementID,NSDictionary *_Nullable extra);
@property (nonatomic, copy) void(^bannerViewFailedToAutoRefreshCallBack)(NSString * _Nullable placementID,NSError * _Nullable error);

+ (instancetype)shared;

- (void)setLogEnabled:(BOOL)enable;

- (void)registerTopOnSDK;
/// 初始化激励视频广告
- (void)initializationTopOnRewardVideoAd:(UIViewController *)viewController;
/// 展示激励视频广告
- (void)showToOnRewardVideoAd;

/// 初始化插屏广告
- (void)initializationTopOnInterstitialAd:(UIViewController *)viewController;
/// 展现插屏
- (void)showTopOnInterstitialAd;

/// 初始化呢banner
- (void)initializationTopOnBannerRootViewController:(UIViewController *)viewController superView:(UIView *)superView;
/// 展现banner
- (void)showTopOnBanner;
/// 移除banner
- (void)removeTopOnBannerViewFromSuperView;
- (BOOL)bannerViewAdReady;
- (BOOL)interstitialAdReady;
- (BOOL)rewardVideoAdReady;

@end



NS_ASSUME_NONNULL_END

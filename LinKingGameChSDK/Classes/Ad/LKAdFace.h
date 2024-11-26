//
//  LKAdFace.h
//  LinKingSDK
//
//  Created by leon on 2021/5/28.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKAdContext.h"
typedef NS_ENUM(NSInteger, LK_ADTYPE) {
    LK_ADTYPE_REWARDVIDEO = 0,
    LK_ADTYPE_INTERSTITAL = 1,
    LK_ADTYPE_BANNER = 2,
};


typedef NS_ENUM(NSInteger,LK_PAYUSERTYPE) {
    LK_PAYUSERTYPE_UNDEFINED = 0,  // 未定义
    LK_PAYUSERTYPE_PAY = 1,        // 付费
    LK_PAYUSERTYPE_NOPAY = 2       // 非付费
};

@protocol LKAdFaceDelegate <NSObject>

@optional
/// 横屏广告加载失败
/// @param error 错误信息
- (void)bannerAdDidLoadFail:(NSError * _Nullable)error;
/// 广告加载成功
- (void)bannerAdDidFinishLoading;
/// 横屏广告点击关闭
- (void)bannerAdDidClose;
/// 横屏广告点击
- (void)bannerAdDidClick;
/// 横屏广告呈现成功
- (void)bannerAdDidVisible;


/// 激励视频加载失败
/// @param error 错误信息
- (void)rewardAdDidLoadFail:(NSError * _Nullable)error;
/// 展示失败
/// @param error error description
- (void)rewardAdDidVisibleFail:(NSError * _Nullable)error;
/// 广告加载成功
- (void)rewardAdDidFinishLoading;
/// 激励视频呈现成功
- (void)rewardAdDidVisible;
/// 激励视频点击关闭
- (void)rewardAdDidClose;
/// 激励视频点击
- (void)rewardAdDidClick;
/// 获取奖励
- (void)rewardAdWinReward;


/// 插屏广告加载失败
/// @param error 错误信息
- (void)interstitialAdDidLoadFail:(NSError * _Nullable)error;
/// 展示失败
/// @param error error description
- (void)interstitialAdDidVisibleFail:(NSError * _Nullable)error;
/// 广告加载成功
- (void)interstitialAdDidFinishLoading;
/// 插屏广告呈现成功
- (void)interstitialAdDidVisible;
/// 插屏广告关闭
- (void)interstitialAdDidClose;
/// 插屏广告点击
- (void)interstitialAdDidClick;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LKAdFace : LKAdContext<LKAdContext>
@property (nonatomic, weak) id <LKAdFaceDelegate>delegate;

+ (instancetype)shared;

/// 注册广告
- (void)registerAggregateAd;

/// 初始化广告
/// @param type 广告类型
/// @param viewController 控制器
/// @param superView 视图
- (void)initAd:(LK_ADTYPE)type rootViewController:(UIViewController * _Nonnull)viewController superView:(UIView * _Nullable)superView;

/// 展示横屏
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showBannerPayuser:(LK_PAYUSERTYPE)type;
/// 移除横屏
- (void)removeBanner;
/// 展现插屏
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showInterstitialAdPayuser:(LK_PAYUSERTYPE)type;
/// 展示激励视频广告
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showRewardVideoAdPayuser:(LK_PAYUSERTYPE)type;

@end

NS_ASSUME_NONNULL_END

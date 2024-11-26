//
//  LKAdInterface.h
//  LinKingSDK
//
//  Created by leon on 2021/5/27.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTopOnContext.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LKAdInterface <NSObject>

/// 初始化广告
- (void)initBannerAdWithrootViewController:(UIViewController * _Nonnull)viewController superView:(UIView * _Nullable)superView;
/// 展示横屏
- (void)showBanner;
/// 移除Banner
- (void)removeBannerViewFromSuperView;

/// 初始化广告
- (void)initInterstitialAdWithrootViewController:(UIViewController * _Nonnull)viewController;
/// 展现插屏
- (void)showInterstitialAd;

/// 初始化广告
- (void)initRewardVideoAdWithrootViewController:(UIViewController * _Nonnull)viewController;
/// 展示激励视频广告
- (void)showRewardVideoAd;

@optional
/// 设置TOPON广告上下文对象用于回调
/// @param context context description
- (void)setAdContext:(LKTopOnContext<LKTopOnContext>* _Nullable)context;


@end

@interface LKAdInterface : NSObject

@end

NS_ASSUME_NONNULL_END

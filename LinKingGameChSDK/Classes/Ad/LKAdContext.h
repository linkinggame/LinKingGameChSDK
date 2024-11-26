//
//  LKAdContext.h
//  LinKingSDK
//
//  Created by leon on 2021/5/27.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LKAdContext <NSObject>

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

@interface LKAdContext : NSObject

@end

NS_ASSUME_NONNULL_END

//
//  LKAdFace.m
//  LinKingSDK
//
//  Created by leon on 2021/5/28.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKAdFace.h"
#import "LKAdContext.h"
#import "LKTitokExpressManager.h"
#import "LKTitokExpressManager.h"
#import "LKPointManager.h"
#import "LKGlobalConf.h"
#import "LKUser.h"
#import "LKSDKConfig.h"
#import "LKTopOnManager.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "LKLog.h"
#import "LKAdTopOnFactory.h"
#import "LKTopOnConcrete.h"
static LKAdFace *_insatnce  = nil;

@interface LKAdFace ()
@property (nonatomic, strong) LKTopOnConcrete *topOnConcrete;
@property (nonatomic, assign) LK_PAYUSERTYPE payUserVideoType;
@property (nonatomic, assign) LK_PAYUSERTYPE payUserBannerType;
@property (nonatomic, assign) LK_PAYUSERTYPE payUserInterstitialType;
@end

@implementation LKAdFace


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _insatnce = [[LKAdFace alloc] init];
        _insatnce.topOnConcrete = [[LKAdTopOnFactory shared] createAdConcrete:_insatnce];
    });
    return _insatnce;
}


/// 注册广告
- (void)registerAggregateAd{
    [self.topOnConcrete setLogEnabled:YES];
    [self.topOnConcrete registerTopOnSDK];
}

/// 初始化广告
/// @param type 广告类型
/// @param viewController 控制器
/// @param superView 视图
- (void)initAd:(LK_ADTYPE)type rootViewController:(UIViewController * _Nonnull)viewController superView:(UIView * _Nullable)superView{
    
    if (type == LK_ADTYPE_BANNER) {
        [self.topOnConcrete initBannerAdWithrootViewController:viewController superView:superView];
    } else if (type == LK_ADTYPE_INTERSTITAL){
        [self.topOnConcrete initInterstitialAdWithrootViewController:viewController];
    } else if (type == LK_ADTYPE_REWARDVIDEO){
        [self.topOnConcrete initRewardVideoAdWithrootViewController:viewController];
    }
    
    
    
}

/// 展示横屏
- (void)showBanner{
    [self.topOnConcrete showBanner];
}
/// 展现插屏
- (void)showInterstitialAd{
    [self.topOnConcrete showInterstitialAd];
}
/// 展示激励视频广告
- (void)showRewardVideoAd{
    [self.topOnConcrete showRewardVideoAd];
}


- (void)removeBanner{
    [self.topOnConcrete removeBannerViewFromSuperView];
}

/// 展示横屏
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showBannerPayuser:(LK_PAYUSERTYPE)type{
    self.payUserBannerType = type;
    NSDictionary *param = [self getAdBannerParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showBanner];
}
- (NSDictionary *)getAdBannerParam{
    NSDictionary *param = @{};
    if (self.payUserBannerType == LK_PAYUSERTYPE_UNDEFINED) {
        param = @{@"ad_type":@"banner",@"ad_channel":@"TopOn"};
    } else if (self.payUserBannerType == LK_PAYUSERTYPE_PAY){
        param = @{@"ad_type":@"banner",@"ad_channel":@"TopOn",@"pay_user":@1}; // 付费
    } else if (self.payUserBannerType == LK_PAYUSERTYPE_NOPAY){
        param = @{@"ad_type":@"banner",@"ad_channel":@"TopOn",@"pay_user":@2}; // 非付费
    } else {
        param = @{@"ad_type":@"banner",@"ad_channel":@"TopOn"};
    }
    return param;
}

/// 展现插屏
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showInterstitialAdPayuser:(LK_PAYUSERTYPE)type{
    self.payUserInterstitialType = type;
    NSDictionary *param = [self getAdInterstitialParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showInterstitialAd];
}
- (NSDictionary *)getAdInterstitialParam{
    NSDictionary *param = @{};
    if (self.payUserInterstitialType == LK_PAYUSERTYPE_UNDEFINED) {
        param = @{@"ad_type":@"interstitial",@"ad_channel":@"TopOn"};
    } else if (self.payUserInterstitialType == LK_PAYUSERTYPE_PAY){
        param =  @{@"ad_type":@"interstitial",@"ad_channel":@"TopOn",@"pay_user":@1};// 付费
    } else if (self.payUserInterstitialType ==LK_PAYUSERTYPE_NOPAY){
        param =  @{@"ad_type":@"interstitial",@"ad_channel":@"TopOn",@"pay_user":@2}; // 非付费
    } else {
        param = @{@"ad_type":@"interstitial",@"ad_channel":@"TopOn"};
    }
    return param;
}


/// 展示激励视频广告
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showRewardVideoAdPayuser:(LK_PAYUSERTYPE)type{
    self.payUserVideoType = type;
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showRewardVideoAd];
}

- (NSDictionary *)getAdVideoParam{
    NSDictionary *param = @{};
    if (self.payUserVideoType == LK_PAYUSERTYPE_UNDEFINED) {
        param = @{@"ad_type":@"video",@"ad_channel":@"TopOn"};
    } else if (self.payUserVideoType ==LK_PAYUSERTYPE_PAY){
        param =  @{@"ad_type":@"video",@"ad_channel":@"TopOn",@"pay_user":@1};;// 付费
    } else if (self.payUserVideoType == LK_PAYUSERTYPE_NOPAY){
        param =  @{@"ad_type":@"video",@"ad_channel":@"TopOn",@"pay_user":@2};// 非付费
    }else{
        param = @{@"ad_type":@"video",@"ad_channel":@"TopOn"};
    }
    return param;
}





/// ===========================


#pragma -mark 激励广告回调
- (void)rewardAdDidClick {
    if ([self.delegate respondsToSelector:@selector(rewardAdDidClick)]) {
        [self.delegate rewardAdDidClick];
    }
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"click" withParameters:param complete:nil];
}

- (void)rewardAdDidClose {
    if ([self.delegate respondsToSelector:@selector(rewardAdDidClose)]) {
        [self.delegate rewardAdDidClose];
    }
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"cancel" withParameters:param complete:nil];
}

- (void)rewardAdDidFinishLoading {
    
    if ([self.delegate respondsToSelector:@selector(rewardAdDidFinishLoading)]) {
        [self.delegate rewardAdDidFinishLoading];
    }
    
}

- (void)rewardAdDidLoadFail:(NSError * _Nullable)error {
    if ([self.delegate respondsToSelector:@selector(rewardAdDidLoadFail:)]) {
        [self.delegate rewardAdDidLoadFail:error];
    }
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"show_fail" withParameters:param complete:nil];
}

- (void)rewardAdDidVisible {
    if ([self.delegate respondsToSelector:@selector(rewardAdDidVisible)]) {
        [self.delegate rewardAdDidVisible];
    }
    
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"show" withParameters:param complete:nil];
}

- (void)rewardAdDidVisibleFail:(NSError * _Nullable)error {
    
    if ([self.delegate respondsToSelector:@selector(rewardAdDidVisibleFail:)]) {
        [self.delegate rewardAdDidVisibleFail:error];
    }
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"show_fail" withParameters:param complete:nil];
}

- (void)rewardAdWinReward {
    if ([self.delegate respondsToSelector:@selector(rewardAdWinReward)]) {
        [self.delegate rewardAdWinReward];
    }
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"complete" withParameters:param complete:^(NSError * _Nonnull error) {
              
    }];
}

#pragma -mark 横屏广告回调
- (void)bannerAdDidClick {
    NSLog(@"=== bannerView点击了 ===");
    if ([self.delegate respondsToSelector:@selector(bannerAdDidClick)]) {
        [self.delegate bannerAdDidClick];
    }
    
     NSDictionary *param = [self getAdBannerParam];
     [[LKPointManager shared] adLogEventName:@"click" withParameters:param complete:nil];
}

- (void)bannerAdDidClose { 
    NSLog(@"=== bannerView关闭 ===");

    if ([self.delegate respondsToSelector:@selector(bannerAdDidClose)]) {
        [self.delegate bannerAdDidClose];
    }
    NSDictionary *param = [self getAdBannerParam];
     [[LKPointManager shared] adLogEventName:@"cancel" withParameters:param complete:nil];
}

- (void)bannerAdDidFinishLoading {
    
    if ([self.delegate respondsToSelector:@selector(bannerAdDidFinishLoading)]) {
        [self.delegate bannerAdDidFinishLoading];
    }
}

- (void)bannerAdDidLoadFail:(NSError * _Nullable)error {
    if ([self.delegate respondsToSelector:@selector(rewardAdDidLoadFail:)]) {
        [self.delegate rewardAdDidLoadFail:error];
    }
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"show_fail" withParameters:param complete:nil];
    
}

- (void)bannerAdDidVisible {
    NSLog(@"=== bannerView展示成功 ===");
    if ([self.delegate respondsToSelector:@selector(bannerAdDidVisible)]) {
        [self.delegate bannerAdDidVisible];
    }
    
    NSDictionary *param = [self getAdBannerParam];
    [[LKPointManager shared] adLogEventName:@"show" withParameters:param complete:nil];
}


#pragma -mark 插屏广告回调
- (void)interstitialAdDidClick {
    if ([self.delegate respondsToSelector:@selector(interstitialAdDidClick)]) {
        [self.delegate interstitialAdDidClick];
    }
    NSDictionary *param = [self getAdInterstitialParam];
    [[LKPointManager shared] adLogEventName:@"click" withParameters:param complete:nil];
}

- (void)interstitialAdDidClose {
    if ([self.delegate respondsToSelector:@selector(interstitialAdDidClose)]) {
        [self.delegate interstitialAdDidClose];
    }
    NSDictionary *param = [self getAdInterstitialParam];
    [[LKPointManager shared] adLogEventName:@"cancel" withParameters:param complete:nil];
}

- (void)interstitialAdDidFinishLoading {
    
    if ([self.delegate respondsToSelector:@selector(interstitialAdDidFinishLoading)]) {
        [self.delegate interstitialAdDidFinishLoading];
    }
}

- (void)interstitialAdDidLoadFail:(NSError * _Nullable)error {
    if ([self.delegate respondsToSelector:@selector(interstitialAdDidLoadFail:)]) {
        [self.delegate interstitialAdDidLoadFail:error];
    }
    if (error != nil) {
        NSDictionary *param = [self getAdInterstitialParam];
        [[LKPointManager shared] adLogEventName:@"show_fail" withParameters:param complete:nil];
    }
}

- (void)interstitialAdDidVisible {
    if ([self.delegate respondsToSelector:@selector(interstitialAdDidVisible)]) {
        [self.delegate interstitialAdDidVisible];
    }
    NSDictionary *param = [self getAdInterstitialParam];
    [[LKPointManager shared] adLogEventName:@"show" withParameters:param complete:nil];
}

- (void)interstitialAdDidVisibleFail:(NSError * _Nullable)error {
    if ([self.delegate respondsToSelector:@selector(interstitialAdDidLoadFail:)]) {
        [self.delegate interstitialAdDidVisibleFail:error];
    }
    if (error != nil) {
        NSDictionary *param = [self getAdInterstitialParam];
        [[LKPointManager shared] adLogEventName:@"show_fail" withParameters:param complete:nil];
    }
}

/// ===========================







@end

//
//  LKTitokExpressManager.m
//  LinKingSDK
//
//  Created by leoan on 2020/7/28.
//  Copyright © 2020 dml1630@163.com. All rights reserved.
//

#import "LKTitokExpressManager.h"
#import <BUAdSDK/BUNativeExpressBannerView.h>
//#import <BUAdSDK/BUNativeExpressInterstitialAd.h>
#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUAdSDKManager.h>
#import "LKUser.h"
#import "LKGlobalConf.h"
#import "LKSDKConfig.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "LKLog.h"
@interface LKTitokExpressManager ()
<BUNativeExpressBannerViewDelegate,BUNativeExpressRewardedVideoAdDelegate,BUNativeExpressFullscreenVideoAdDelegate>
@property(nonatomic, strong)  BUNativeExpressBannerView *bannerView;
//@property (nonatomic, strong) BUNativeExpressInterstitialAd *interstitialAd;
@property (nonatomic, strong) BUNativeExpressRewardedVideoAd *rewardedAd;
@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *fullscreenAd;

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, copy) NSString *bannerId;
@property (nonatomic, copy) NSString *fullscreenId;
@property (nonatomic, copy) NSString *rewardvideoId;
@property (nonatomic, copy) NSString *interstitialId;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, assign) BOOL isComplete;

@end


static LKTitokExpressManager *_instance = nil;

@implementation LKTitokExpressManager

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKTitokExpressManager alloc] init];
        [_instance loadData];
    });
    return _instance;
}

- (void)loadData{
   LKSDKConfig *sdkConfig = [LKSDKConfig getSDKConfig];
   
   NSDictionary *ad_config_ios = sdkConfig.ad_config_ios;
    
   NSDictionary *tiktok = ad_config_ios[@"tiktok"];
    
    NSArray *bannerArray = tiktok[@"banner"];
    NSArray *fullscreenArray = tiktok[@"fullscreen"];
    NSArray *rewardvideoArray = tiktok[@"rewardvideo"];
    NSArray *interstitialArray =tiktok[@"interstitial"];
    
    NSDictionary *banner = bannerArray.firstObject;
    NSDictionary *fullscreen = fullscreenArray.firstObject;
    NSDictionary *rewardvideo = rewardvideoArray.firstObject;
    NSDictionary *interstitial = interstitialArray.firstObject;
    
    self.appid = tiktok[@"appid"];
    self.bannerId = banner[@"id"];
    self.fullscreenId = fullscreen[@"id"];
    self.interstitialId = interstitial[@"id"];
    self.rewardvideoId = rewardvideo[@"id"];
}


- (void)initializeTitokAdConfig{
    LKSDKConfig *sdkConfig = [LKSDKConfig getSDKConfig];
    BOOL isDebug = [sdkConfig.mode_debug boolValue];
    if (isDebug) {
        //[BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
    }
//    [BUAdSDKManager setAppID:self.appid];

//    [BUAdSDKManager setIsPaidApp:NO];
    BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
    configuration.appID = self.appid;//除appid外，其他参数配置按照项目实际需求配置即可。
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
             //请求广告逻辑处理
              
            });
        }
    }];
}




#pragma mark -- 横屏
- (void)initializationTittokBannerRootViewController:(UIViewController *)viewController superView:(UIView *)superView frame:(CGRect)frame{
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            self.viewController = viewController;
            self.superView = superView;
            self.frame = frame;
            CGSize size = CGSizeMake(600, 150);
            CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
            CGFloat bannerHeigh = screenWidth/size.width*size.height;
            self.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:self.bannerId rootViewController:viewController adSize:CGSizeMake(screenWidth, bannerHeigh)];
            CGFloat bannerHeight = frame.size.width * size.height / size.width;
            CGFloat originY =  frame.origin.y + frame.size.height - bannerHeight;
            self.bannerView.frame = CGRectMake(0, originY, frame.size.width, 60);
            self.bannerView.delegate = self;
            [self.bannerView loadAdData];
        }];
    } else {
        self.viewController = viewController;
        self.superView = superView;
        self.frame = frame;
        CGSize size = CGSizeMake(600, 150);
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat bannerHeigh = screenWidth/size.width*size.height;
        self.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:self.bannerId rootViewController:viewController adSize:CGSizeMake(screenWidth, bannerHeigh)];
        CGFloat bannerHeight = frame.size.width * size.height / size.width;
        CGFloat originY =  frame.origin.y + frame.size.height - bannerHeight;
        self.bannerView.frame = CGRectMake(0, originY, frame.size.width, 60);
        self.bannerView.delegate = self;
        [self.bannerView loadAdData];
    }
   


}

// 展示横屏广告
- (void)showTittokBanner{
    CGSize size = CGSizeMake(600, 150);
    CGFloat bannerHeight = self.frame.size.width * size.height / size.width;
    CGFloat originY =  self.frame.origin.y + self.frame.size.height - bannerHeight;
    self.bannerView.frame = CGRectMake(0, originY, self.frame.size.width, bannerHeight);
    [self.superView addSubview:self.bannerView];
}


/// 移除Banner
- (void)removeBannerViewFromSuperView{
     [self.bannerView removeFromSuperview];
     self.bannerView = nil;
}


#pragma mark -- 插屏
- (void)initializationTittokInterstitialAd:(UIViewController *)viewController{
    
    /*if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            self.viewController = viewController;
            CGSize size = CGSizeMake(300, 300);
            CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)-40;
            CGFloat height = width/size.width*size.height;
            self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:self.interstitialId adSize:CGSizeMake(width, height)];
            self.interstitialAd.delegate = self;
            [self.interstitialAd loadAdData];
        }];
    } else {
        self.viewController = viewController;
        CGSize size = CGSizeMake(300, 300);
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)-40;
        CGFloat height = width/size.width*size.height;
        self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:self.interstitialId adSize:CGSizeMake(width, height)];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAdData];
    }*/
    

}

- (void)showTittokInterstitialAd{
   /*if (self.interstitialAd) {
       [self.interstitialAd showAdFromRootViewController:self.viewController];
   }*/
}

#pragma mark -- 激励

/// 初始化激励视频广告
- (void)initializationTittokRewardVideoAd:(UIViewController *)viewController{
    
    
    self.isComplete = NO;
    self.viewController = viewController;
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    LKUser *user = [LKUser getUser];
    model.userId = user.userId;
    // @"945113162"
    self.rewardedAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:self.rewardvideoId rewardedVideoModel:model];
    self.rewardedAd.delegate = self;
    [self.rewardedAd loadAdData];
    
    
}

/// 展示激励视频广告
- (void)showTittokRewardVideoAd{
    if (self.rewardedAd) {
        [self.rewardedAd showAdFromRootViewController:self.viewController];
    }
}

#pragma mark -- 全屏

// 初始全屏广告
- (void)initializationTittokFullScreenVideoAd:(UIViewController *)viewController{
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            self.viewController = viewController;
            // @"945135232"
            self.fullscreenAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:self.fullscreenId];
            self.fullscreenAd.delegate = self;
            [self.fullscreenAd loadAdData];
        }];
    } else {
        self.viewController = viewController;
       // @"945135232"
       self.fullscreenAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:self.fullscreenId];
       self.fullscreenAd.delegate = self;
       [self.fullscreenAd loadAdData];
    }
    

}


// 展示全屏广告
- (void)showTittokFullScreenVideoAd{
    if (self.fullscreenAd) {
        [self.fullscreenAd showAdFromRootViewController:self.viewController];
     }
}


#pragma mark -- BUNativeExpressFullscreenVideoAdDelegate
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    LKLogInfo(@"%s",__func__);

    if (self.fullscreenAdViewDidLoadCallBack) {
        self.fullscreenAdViewDidLoadCallBack();
    }

}

- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {

    LKLogInfo(@"%s",__func__);
    LKLogInfo(@"error code : %ld , error message : %@",(long)error.code,error.description);
    if (self.fullscreenAdViewDidLoadFailCallBack) {
        self.fullscreenAdViewDidLoadFailCallBack(error);
    }
}

- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd {

    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewRewardDidSucceedCallBack) {
        self.fullscreenAdViewRewardDidSucceedCallBack();
    }
}

- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewRewardDidFailCallBack) {
        self.fullscreenAdViewRewardDidFailCallBack();
    }
}

- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {

    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewDidDownLoadCallBack) {
        self.fullscreenAdViewDidDownLoadCallBack();
    }
}

- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewWillVisibleCallBack) {
        self.fullscreenAdViewWillVisibleCallBack();
    }
}

- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewDidVisibleCallBack) {
        self.fullscreenAdViewDidVisibleCallBack();
    }
}

- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    LKLogInfo(@"%s",__func__);

    if (self.fullscreenAdViewDidClickCallBack) {
        self.fullscreenAdViewDidClickCallBack();
    }
}

- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewDidClickSkipCallBack) {
        self.fullscreenAdViewDidClickSkipCallBack();
    }
}

- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewWillCloseCallBack) {
        self.fullscreenAdViewWillCloseCallBack();
    }
}

- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewDidCloseCallBack) {
        self.fullscreenAdViewDidCloseCallBack();
    }
    // 预加载下一次广告
   // [self initializationTittokFullScreenVideoAd:self.viewController];
}

- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    LKLogInfo(@"%s",__func__);
    if (self.fullscreenAdViewDidPlayFinishCallBack) {
        self.fullscreenAdViewDidPlayFinishCallBack(error);
    }
}

- (void)nativeExpressFullscreenVideoAdDidCloseOtherController:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    LKLogInfo(@"%s __ %@",__func__,str);
    if (self.fullscreenAdViewDidCloseOtherControllerCallBack) {
        self.fullscreenAdViewDidCloseOtherControllerCallBack();
    }
}


#pragma mark -- BUNativeExpressRewardedVideoAdDelegate
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    LKLogInfo(@"%s",__func__);

    if (self.rewardAdViewDidLoadCallBack) {
        self.rewardAdViewDidLoadCallBack();
    }

}

- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    LKLogInfo(@"%s",__func__);
    LKLogInfo(@"error code : %ld , error message : %@",(long)error.code,error.description);
    if (self.rewardAdViewDidLoadFailCallBack) {
        self.rewardAdViewDidLoadFailCallBack(error);
    }

}

- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewDidDownLoadCallBack) {
        self.rewardAdViewDidDownLoadCallBack();
    }
}

- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewRenderCallBack) {
        self.rewardAdViewRenderCallBack();
    }

}

- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {

    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewRenderFailCallBack) {
        self.rewardAdViewRenderFailCallBack(error);
    }

}

- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewWillVisibleCallBack) {
        self.rewardAdViewWillVisibleCallBack();
    }
}

- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewDidVisibleCallBack) {
        self.rewardAdViewDidVisibleCallBack();
    }

}

- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewWillCloseCallBack) {
        self.rewardAdViewWillCloseCallBack();
    }
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {

    LKLogInfo(@"%s",__func__);

    if (self.rewardAdViewDidCloseCallBack) {
        self.rewardAdViewDidCloseCallBack();
    }

    if (self.rewardedAd) {
        self.rewardedAd = nil;
    }
   // [self initializationTittokRewardVideoAd:self.viewController];
}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewDidClickCallBack) {
        self.rewardAdViewDidClickCallBack();
    }
}

//  This method is called when the user clicked skip button.
- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewDidClickSkipCallBack) {
        self.rewardAdViewDidClickSkipCallBack();
    }
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    LKLogInfo(@"%s",__func__);

    if (self.isComplete == NO) {
        self.isComplete = YES;
        if (self.rewardAdViewDidPlayFinishCallBack) {
            self.rewardAdViewDidPlayFinishCallBack(error);
        }
    }


}

- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewRewardDidSucceedCallBack) {
        self.rewardAdViewRewardDidSucceedCallBack();
    }
}

- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError * _Nullable)error {
    LKLogInfo(@"%s",__func__);
    if (self.rewardAdViewRewardDidFailCallBack) {
        self.rewardAdViewRewardDidFailCallBack();
    }
}


- (void)nativeExpressRewardedVideoAdDidCloseOtherController:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    LKLogInfo(@"%s __ %@",__func__,str);

    if (self.rewardAdViewDidCloseOtherControllerCallBack) {
        self.rewardAdViewDidCloseOtherControllerCallBack();
    }
}




/*
#pragma mark -- BUNativeExpresInterstitialAdDelegate
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {
    LKLogInfo(@"%s",__func__);
    if (self.interstitialAdViewDidLoadCallBack) {
        self.interstitialAdViewDidLoadCallBack();
    }
}

- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    LKLogInfo(@"error code : %ld , error message : %@",(long)error.code,error.description);
   if (self.interstitialAdViewDidLoadFailCallBack) {
       self.interstitialAdViewDidLoadFailCallBack(error);
   }
}

- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {
    LKLogInfo(@"%s",__func__);

    if (self.interstitialAdViewRenderCallBack) {
        self.interstitialAdViewRenderCallBack();
    }

}

- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError *)error {
    LKLogInfo(@"error code : %ld , error message : %@",(long)error.code,error.description);
    LKLogInfo(@"%s",__func__);
    if (self.interstitialAdViewRenderFailCallBack) {
        self.interstitialAdViewRenderFailCallBack(error);
    }
}

- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    LKLogInfo(@"%s",__func__);

    if (self.interstitialAdViewVisibleCallBack) {
        self.interstitialAdViewVisibleCallBack();
    }

}

- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    LKLogInfo(@"%s",__func__);

    if (self.interstitialAdViewDidClickCallBack) {
        self.interstitialAdViewDidClickCallBack();
    }
}

- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    LKLogInfo(@"%s",__func__);
    if (self.interstitialAdViewWillCloseCallBack) {
        self.interstitialAdViewWillCloseCallBack();
    }
}

- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {

    if (self.interstitialAdViewDidCloseCallBack) {
        self.interstitialAdViewDidCloseCallBack();
    }
}

- (void)nativeExpresInterstitialAdDidCloseOtherController:(BUNativeExpressInterstitialAd *)interstitialAd interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    LKLogInfo(@"%s __ %@",__func__,str);

    if (self.interstitialAdViewDidCloseOtherControllerCallBack) {
        self.interstitialAdViewDidCloseOtherControllerCallBack();
    }
}*/




#pragma  mark -- BUNativeExpressBannerViewDelegate
// 已经加载
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {

    LKLogInfo(@"%s",__func__);
    if (self.bannerAdViewDidLoadCallBack) {
        self.bannerAdViewDidLoadCallBack();
    }
}

// 加载失败
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {

    LKLogInfo(@"error code : %ld , error message : %@",(long)error.code,error.description);
    if (self.bannerAdViewDidLoadCallBack) {
        self.bannerAdViewDidLoadFailCallBack(error);
    }
}

// 成功渲染nativeExpressAdView时将调用此方法。
- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {

    LKLogInfo(@"%s",__func__);
    if (self.bannerAdViewRenderCallBack) {
        self.bannerAdViewRenderCallBack();
    }
}

// 渲染失败
- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error {

    LKLogInfo(@"%s",__func__);
    if (self.bannerAdViewRenderCallBack) {
        self.bannerAdViewRenderFailCallBack(error);
    }
}

// 成功展现
- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {

    LKLogInfo(@"%s",__func__);
    if (self.bannerAdViewVisibleCallBack) {
        self.bannerAdViewVisibleCallBack();
    }
}

// 点击
- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {

    LKLogInfo(@"%s",__func__);
    if (self.bannerAdViewDidClickCallBack) {
        self.bannerAdViewDidClickCallBack();
    }
}


// 关闭
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
    LKLogInfo(@"%s",__func__);

    [UIView animateWithDuration:0.25 animations:^{
        bannerAdView.alpha = 0;
    } completion:^(BOOL finished) {
        [bannerAdView removeFromSuperview];
        self.bannerView = nil;
    }];

    if (self.bannerAdViewCloseReasonCallBack) {
        self.bannerAdViewCloseReasonCallBack();
    }
}

// 跳转之后的是否下载事件
- (void)nativeExpressBannerAdViewDidCloseOtherController:(BUNativeExpressBannerView *)bannerAdView interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    LKLogInfo(@"%s __ %@",__func__,str);
    if (self.bannerAdViewDidCloseOtherControllerCallBack) {
        self.bannerAdViewDidCloseOtherControllerCallBack();
    }
}


@end

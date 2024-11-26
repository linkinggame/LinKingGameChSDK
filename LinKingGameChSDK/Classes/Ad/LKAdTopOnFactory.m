//
//  LKAdTopOnFactory.m
//  LinKingSDK
//
//  Created by leon on 2021/5/28.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKAdTopOnFactory.h"
#import "LKTopOnConcrete.h"
#import "LKAdContext.h"
#import "LKLog.h"
static LKAdTopOnFactory *_instance = nil;
@interface LKAdTopOnFactory ()
@property (nonatomic, weak)LKAdContext<LKAdContext>*adContext;
@property (nonatomic, strong) LKTopOnConcrete *topOnConcret;
@end

@implementation LKAdTopOnFactory

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKAdTopOnFactory alloc] init];
    });
    return _instance;
}

- (LKTopOnConcrete*)createAdConcrete:(LKAdContext<LKAdContext>*)adContext{
    self.topOnConcret =  [LKTopOnConcrete shared];
    LKAdTopOnFactory *factory = [LKAdTopOnFactory shared];
    [self.topOnConcret setAdContext:_instance];
    factory.adContext = adContext;
    return  self.topOnConcret;
}


- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    
    if (self.topOnConcret.style == TopOnAdStyle_Banner) {
        if ([self.adContext respondsToSelector:@selector(bannerAdDidLoadFail:)]) {
            [self.adContext bannerAdDidLoadFail:error];
        }
        
    } else if (self.topOnConcret.style == TopOnAdStyle_Interstitial){
        if ([self.adContext respondsToSelector:@selector(interstitialAdDidLoadFail:)]) {
            [self.adContext interstitialAdDidLoadFail:error];
        }
    } else if (self.topOnConcret.style == TopOnAdStyle_RewardVideo){
        if ([self.adContext respondsToSelector:@selector(rewardAdDidLoadFail:)]) {
            [self.adContext rewardAdDidLoadFail:error];
        }
    }
   
    
    
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    
    if (self.topOnConcret.style == TopOnAdStyle_Banner) {
        if ([self.adContext respondsToSelector:@selector(bannerAdDidFinishLoading)]) {
            [self.adContext bannerAdDidFinishLoading];
        }
        
    } else if (self.topOnConcret.style == TopOnAdStyle_Interstitial){
        if ([self.adContext respondsToSelector:@selector(interstitialAdDidFinishLoading)]) {
            [self.adContext interstitialAdDidFinishLoading];
        }
    } else if (self.topOnConcret.style == TopOnAdStyle_RewardVideo){
        if ([self.adContext respondsToSelector:@selector(rewardAdDidFinishLoading)]) {
            [self.adContext rewardAdDidFinishLoading];
        }
    }
    
    
    
}


#pragma mark -- banner回调
- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra {
    
    
}
- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if ([self.adContext respondsToSelector:@selector(bannerAdDidClick)]) {
        [self.adContext bannerAdDidClick];
    }
    
}
- (void)bannerView:(ATBannerView *)bannerView didCloseWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if ([self.adContext respondsToSelector:@selector(bannerAdDidClose)]) {
        [self.adContext bannerAdDidClose];
    }
    
}
- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    
}
- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if ([self.adContext respondsToSelector:@selector(bannerAdDidVisible)]) {
        [self.adContext bannerAdDidVisible];
    }
    
}

- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    if ([self.adContext respondsToSelector:@selector(bannerAdDidClose)]) {
        [self.adContext bannerAdDidClose];
    }
}

- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    
}




#pragma mark -- 插屏回调
- (void)interstitialDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    
}

- (void)interstitialDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if ([self.adContext respondsToSelector:@selector(interstitialAdDidClick)]) {
        [self.adContext interstitialAdDidClick];
    }
}

- (void)interstitialDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if ([self.adContext respondsToSelector:@selector(interstitialAdDidClose)]) {
        [self.adContext interstitialAdDidClose];
    }
}

- (void)interstitialDidEndPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {


}

/// 展示播放失败
- (void)interstitialDidFailToPlayVideoForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {

}

/// 展示成功
- (void)interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if ([self.adContext respondsToSelector:@selector(interstitialAdDidVisible)]) {
        [self.adContext interstitialAdDidVisible];
    }
}


/// 开始展示
- (void)interstitialDidStartPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    
}

- (void)interstitialFailedToShowForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    if ([self.adContext respondsToSelector:@selector(interstitialAdDidVisibleFail:)]) {
        [self.adContext interstitialAdDidVisibleFail:error];
    }
}



#pragma mark -- 激励视频回调

- (void)rewardedVideoDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    LKLogInfo(@"[LKAdTopOnFactory] %s",__FUNCTION__);
    if ([self.adContext respondsToSelector:@selector(rewardAdDidClick)]) {
        [self.adContext rewardAdDidClick];
    }

    
}

- (void)rewardedVideoDidCloseForPlacementID:(NSString *)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    LKLogInfo(@"[LKAdTopOnFactory] %s",__FUNCTION__);
    if ([self.adContext respondsToSelector:@selector(rewardAdDidClose)]) {
        [self.adContext rewardAdDidClose];
    }

}

- (void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    LKLogInfo(@"[LKAdTopOnFactory] %s",__FUNCTION__);
}

- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    LKLogInfo(@"[LKAdTopOnFactory] %s",__FUNCTION__);

    
}

- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    LKLogInfo(@"[LKAdTopOnFactory] %s",__FUNCTION__);
    if ([self.adContext respondsToSelector:@selector(rewardAdDidLoadFail:)]) {
        [self.adContext rewardAdDidLoadFail:error];
    }
    
}

- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    LKLogInfo(@"[LKAdTopOnFactory] %s",__FUNCTION__);
    if ([self.adContext respondsToSelector:@selector(rewardAdWinReward)]) {
        [self.adContext rewardAdWinReward];
    }
}

- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    LKLogInfo(@"[LKAdTopOnFactory] %s",__FUNCTION__);
    if ([self.adContext respondsToSelector:@selector(rewardAdDidVisible)]) {
        [self.adContext rewardAdDidVisible];
    }
}

@end

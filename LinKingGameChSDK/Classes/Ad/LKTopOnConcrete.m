//
//  LKTopOnConcrete.m
//  LinKingSDK
//
//  Created by leon on 2021/5/27.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKTopOnConcrete.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkBanner/AnyThinkBanner.h>
#import "LKSDKConfig.h"
#import "LKLog.h"

static LKTopOnConcrete *_instance = nil;
@interface LKTopOnConcrete ()<ATRewardedVideoDelegate,ATInterstitialDelegate,ATBannerDelegate>
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong)  ATBannerView *bannerView;
@property (nonatomic, copy) NSString *bannerId;
@property (nonatomic, copy) NSString *fullscreenId;
@property (nonatomic, copy) NSString *rewardvideoId;
@property (nonatomic, copy) NSString *interstitialId;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) BOOL isTest;
@property (nonatomic, weak) LKTopOnContext <LKTopOnContext>*topOnAdContext;
@end

@implementation LKTopOnConcrete


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKTopOnConcrete alloc] init];
        [_instance loadData];
    });
    return _instance;
}

- (void)initBannerAdWithrootViewController:(UIViewController * _Nonnull)viewController superView:(UIView * _Nullable)superView {
    self.rootViewController = viewController;
    self.contentView = superView;
    self.style = TopOnAdStyle_Banner;
    [[ATAdManager sharedManager] loadADWithPlacementID:self.bannerId extra:nil delegate:self];
}

- (void)initInterstitialAdWithrootViewController:(UIViewController * _Nonnull)viewController {
    self.rootViewController = viewController;
    self.style = TopOnAdStyle_Interstitial;
    [[ATAdManager sharedManager] loadADWithPlacementID:self.interstitialId extra:@{} delegate:self];
}

- (void)initRewardVideoAdWithrootViewController:(UIViewController * _Nonnull)viewController {
    self.rootViewController = viewController;
    self.style = TopOnAdStyle_RewardVideo;
    [[ATAdManager sharedManager] loadADWithPlacementID:self.rewardvideoId extra:@{} delegate:self];
}

- (void)removeBannerViewFromSuperView {
    [self.bannerView removeFromSuperview];
}

- (void)setAdContext:(LKTopOnContext<LKTopOnContext> *)context {
    
    self.topOnAdContext = context;
}

- (void)showBanner {
    
        if ([[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.bannerId]) {
               ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.bannerId];
               bannerView.delegate = self;
            self.bannerView = bannerView;
               bannerView.translatesAutoresizingMaskIntoConstraints = NO;
               bannerView.tag = 10;
               [self.contentView addSubview:bannerView];
    
    
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60]];
    
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
           } else {
    
           }
}

- (void)showInterstitialAd {
    if ([[ATAdManager sharedManager] interstitialReadyForPlacementID:self.interstitialId]) {
        [[ATAdManager sharedManager] showInterstitialWithPlacementID:self.interstitialId inViewController:self.rootViewController delegate:self];
    } else {
        //Load interstitial here
        LKLogInfo(@"插屏视频正在加载中...");
    }
}

- (void)showRewardVideoAd {
    if ([[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:self.rewardvideoId]) {

        [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:self.rewardvideoId inViewController:self.rootViewController delegate:self];
    } else {
        LKLogInfo(@"激励视频正在加载中...");
    }
}


// ======

- (void)loadData{

    LKSDKConfig *configSDk = [LKSDKConfig getSDKConfig];

    NSDictionary *topOn  = configSDk.ad_config_ios[@"topOn"];

    NSArray *bannerArray = topOn[@"banner"];
    NSArray *fullscreenArray = topOn[@"fullscreen"];
    NSArray *rewardvideoArray = topOn[@"rewardvideo"];
    NSArray *interstitialArray =topOn[@"interstitial"];
    NSNumber *test = topOn[@"isTest"];

    self.bannerId = bannerArray.firstObject;
    self.interstitialId = interstitialArray.firstObject;
    self.fullscreenId = fullscreenArray.firstObject;
    self.rewardvideoId = rewardvideoArray.firstObject;
    self.isTest = [test boolValue];
    self.appid = topOn[@"appId"];
    self.key = topOn[@"appKey"];

   
    
}


- (void)setLogEnabled:(BOOL)enable{
    [ATAPI setLogEnabled:enable];//Turn on debug logs
    [ATAPI integrationChecking];
}

- (void)registerTopOnSDK{
    
    if (self.appid == nil || self.key  == nil) {
        return;
    }
    [[ATAPI sharedInstance] startWithAppID:self.appid appKey:self.key error:nil];
}









#pragma mark - ATRewardedVideoDelegate

-(void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    LKLogInfo(@"RV Demo: didFinishLoadingADWithPlacementID");

    if ([self.bannerId isEqualToString:placementID]) {
    }else if([self.interstitialId isEqualToString:placementID]){
        
    }else if ([self.rewardvideoId isEqualToString:placementID]){
        
    }
    
    if ([self.topOnAdContext respondsToSelector:@selector(didFinishLoadingADWithPlacementID:)]) {
        [self.topOnAdContext didFinishLoadingADWithPlacementID:placementID];
    }


}

-(void)didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    LKLogInfo(@"RV Demo: failed to load:%@", error);
    if ([self.topOnAdContext respondsToSelector:@selector(didFailToLoadADWithPlacementID:error:)]) {
        [self.topOnAdContext didFailToLoadADWithPlacementID:placementID error:error];
    }
      
    
}

- (void)rewardedVideoDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(rewardedVideoDidClickForPlacementID:extra:)]) {
        [self.topOnAdContext rewardedVideoDidClickForPlacementID:placementID extra:extra];
    }
}

- (void)rewardedVideoDidCloseForPlacementID:(NSString *)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(rewardedVideoDidCloseForPlacementID:rewarded:extra:)]) {
        [self.topOnAdContext rewardedVideoDidCloseForPlacementID:placementID rewarded:rewarded extra:extra];
    }
}

- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(rewardedVideoDidEndPlayingForPlacementID:extra:)]) {
        [self.topOnAdContext rewardedVideoDidEndPlayingForPlacementID:placementID extra:extra];
    }
}

- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(rewardedVideoDidFailToPlayForPlacementID:error:extra:)]) {
        [self.topOnAdContext rewardedVideoDidFailToPlayForPlacementID:placementID error:error extra:extra];
    }
}

- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(rewardedVideoDidRewardSuccessForPlacemenID:extra:)]) {
        [self.topOnAdContext rewardedVideoDidRewardSuccessForPlacemenID:placementID extra:extra];
    }
}

- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    
    if ([self.topOnAdContext respondsToSelector:@selector(rewardedVideoDidStartPlayingForPlacementID:extra:)]) {
        [self.topOnAdContext rewardedVideoDidStartPlayingForPlacementID:placementID extra:extra];
    }

}
-(void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success{

    if ([self.topOnAdContext respondsToSelector:@selector(rewardedVideoDidDeepLinkOrJumpForPlacementID:extra:result:)]) {
        [self.topOnAdContext rewardedVideoDidDeepLinkOrJumpForPlacementID:placementID extra:extra result:success];
    }
    
}

#pragma mark - ATInterstitialDelegate

- (void)interstitialDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(interstitialDidClickForPlacementID:extra:)]) {
        [self.topOnAdContext interstitialDidClickForPlacementID:placementID extra:extra];
    }

}

- (void)interstitialDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(interstitialDidCloseForPlacementID:extra:)]) {
        [self.topOnAdContext interstitialDidCloseForPlacementID:placementID extra:extra];
    }

}

- (void)interstitialDidEndPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {


    if ([self.topOnAdContext respondsToSelector:@selector(interstitialDidEndPlayingVideoForPlacementID:extra:)]) {
        [self.topOnAdContext interstitialDidEndPlayingVideoForPlacementID:placementID extra:extra];
    }
}

- (void)interstitialDidFailToPlayVideoForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(interstitialDidFailToPlayVideoForPlacementID:error:extra:)]) {
        [self.topOnAdContext interstitialDidFailToPlayVideoForPlacementID:placementID error:error extra:extra];
    }
}

- (void)interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(interstitialDidShowForPlacementID:extra:)]) {
        [self.topOnAdContext interstitialDidShowForPlacementID:placementID extra:extra];
    }

}

- (void)interstitialDidStartPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(interstitialDidStartPlayingVideoForPlacementID:extra:)]) {
        [self.topOnAdContext interstitialDidStartPlayingVideoForPlacementID:placementID extra:extra];
    }
}

- (void)interstitialFailedToShowForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(interstitialFailedToShowForPlacementID:error:extra:)]) {
        [self.topOnAdContext interstitialFailedToShowForPlacementID:placementID error:error extra:extra];
    }
    
    
}

-(void)interstitialDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success{

    if ([self.topOnAdContext respondsToSelector:@selector(interstitialDeepLinkOrJumpForPlacementID:extra:result:)]) {
        [self.topOnAdContext interstitialDeepLinkOrJumpForPlacementID:placementID extra:extra result:success];
    }
}


#pragma  mark - ATBannerDelegate

- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(bannerView:didAutoRefreshWithPlacement:extra:)]) {
        [self.topOnAdContext bannerView:bannerView didAutoRefreshWithPlacement:placementID extra:extra];
    }
}

- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext  respondsToSelector:@selector(bannerView:didClickWithPlacementID:extra:)]) {
        [self.topOnAdContext bannerView:bannerView didClickWithPlacementID:placementID extra:extra];
    }
}

- (void)bannerView:(ATBannerView *)bannerView didCloseWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(bannerView:didCloseWithPlacementID:extra:)]) {
        [self.topOnAdContext bannerView:bannerView didCloseWithPlacementID:placementID extra:extra];
    }
}

- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(bannerView:didShowAdWithPlacementID:extra:)]) {
        [self.topOnAdContext bannerView:bannerView didShowAdWithPlacementID:placementID extra:extra];
    }

}

- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {

    if ([self.topOnAdContext respondsToSelector:@selector(bannerView:didTapCloseButtonWithPlacementID:extra:)]) {
        [self.topOnAdContext bannerView:bannerView didTapCloseButtonWithPlacementID:placementID extra:extra];
    }
}

- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {


    if ([self.topOnAdContext respondsToSelector:@selector(bannerView:failedToAutoRefreshWithPlacementID:error:)]) {
        [self.topOnAdContext bannerView:bannerView failedToAutoRefreshWithPlacementID:placementID error:error];
    }
    
}
-(void)bannerView:(ATBannerView*)bannerView didDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success{

    if ([self.topOnAdContext respondsToSelector:@selector(bannerView:didDeepLinkOrJumpForPlacementID:extra:result:)]) {
        [self.topOnAdContext bannerView:bannerView didDeepLinkOrJumpForPlacementID:placementID extra:extra result:success];
    }
}

@end

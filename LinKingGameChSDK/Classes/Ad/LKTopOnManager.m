

#import "LKTopOnManager.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkBanner/AnyThinkBanner.h>
#import "LKSDKConfig.h"
#import "LKLog.h"
@interface LKTopOnManager ()<ATRewardedVideoDelegate,ATInterstitialDelegate,ATBannerDelegate>
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
@end

static LKTopOnManager *_instance = nil;
@implementation LKTopOnManager


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKTopOnManager alloc] init];
        [_instance loadData];
    });
    return _instance;
}

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
    [ATAPI setLogEnabled:YES];//Turn on debug logs
    [ATAPI integrationChecking];
}

- (void)registerTopOnSDK{
    
    if (self.appid == nil || self.key  == nil) {
        return;
    }
    [[ATAPI sharedInstance] startWithAppID:self.appid appKey:self.key error:nil];
}

/// 初始化Banner广告
- (void)initializationTopOnBannerRootViewController:(UIViewController *)viewController superView:(UIView *)superView{
    self.rootViewController = viewController;
    self.contentView = superView;
    // b5bacad0803fd1
    [[ATAdManager sharedManager] loadADWithPlacementID:self.bannerId extra:nil delegate:self];
}


- (BOOL)bannerViewAdReady{
    
    return [[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.bannerId];
//    return YES;
}
- (BOOL)interstitialAdReady{
    return [[ATAdManager sharedManager] interstitialReadyForPlacementID:self.interstitialId];
//    return YES;
}
- (BOOL)rewardVideoAdReady{
    
    return [[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:self.rewardvideoId];
//    return YES;
}

/// 展示Banner广告
- (void)showTopOnBanner{
    

    if ([[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.bannerId]) {
           ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.bannerId];
           bannerView.delegate = self;
        self.bannerView = bannerView;
//               bannerView.presentingViewController = self;
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
/// 移除Banner
- (void)removeTopOnBannerViewFromSuperView{

    [self.bannerView removeFromSuperview];
}


/// 初始化插屏广告
- (void)initializationTopOnInterstitialAd:(UIViewController *)viewController{
    self.rootViewController = viewController;
    // b5bacad46a8bbb
    [[ATAdManager sharedManager] loadADWithPlacementID:self.interstitialId extra:@{} delegate:self];
}
/// 展现插屏
- (void)showTopOnInterstitialAd{
    if ([[ATAdManager sharedManager] interstitialReadyForPlacementID:self.interstitialId]) {
        [[ATAdManager sharedManager] showInterstitialWithPlacementID:self.interstitialId inViewController:self.rootViewController delegate:self];
    } else {
        //Load interstitial here
        LKLogInfo(@"插屏视频正在加载中...");
    }
}

/// 初始化激励视频广告
- (void)initializationTopOnRewardVideoAd:(UIViewController *)viewController{

    self.rootViewController = viewController;
//    // b5b44a07fc3bf6
    [[ATAdManager sharedManager] loadADWithPlacementID:self.rewardvideoId extra:@{} delegate:self];
    
}
/// 展示激励视频广告
- (void)showToOnRewardVideoAd{
    
    if ([[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:self.rewardvideoId]) {

        [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:self.rewardvideoId inViewController:self.rootViewController delegate:self];
    } else {
        LKLogInfo(@"激励视频正在加载中...");
    }
//
}

#pragma mark - ATRewardedVideoDelegate

-(void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    LKLogInfo(@"RV Demo: didFinishLoadingADWithPlacementID");
    
    if ([self.bannerId isEqualToString:placementID]) {
        if (self.topOnAdDidFinishLoadingCallBack) {
            self.topOnAdDidFinishLoadingCallBack(placementID,@"bannerAd");
        }
    }else if([self.interstitialId isEqualToString:placementID]){
        if (self.topOnAdDidFinishLoadingCallBack) {
            self.topOnAdDidFinishLoadingCallBack(placementID,@"interstitialAd");
        }
    }else if ([self.rewardvideoId isEqualToString:placementID]){
        if (self.topOnAdDidFinishLoadingCallBack) {
            self.topOnAdDidFinishLoadingCallBack(placementID,@"rewardVideoAd");
        }
    }
    

}

-(void)didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    LKLogInfo(@"RV Demo: failed to load:%@", error);
    if (self.topOnAdDidFailToLoadCallBack) {
        self.topOnAdDidFailToLoadCallBack(placementID, error);
    }
}

- (void)rewardedVideoDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.rewardedVideoDidClickCallBack) {
        self.rewardedVideoDidClickCallBack(placementID, extra);
    }
}

- (void)rewardedVideoDidCloseForPlacementID:(NSString *)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    
    if (self.rewardedVideoDidCloseCallBack) {
        self.rewardedVideoDidCloseCallBack(placementID, rewarded, extra);
    }
}

- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.rewardedVideoDidEndPlayingCallBack) {
        self.rewardedVideoDidEndPlayingCallBack(placementID, extra);
    }
}

- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    
    if (self.rewardedVideoDidFailCallBack) {
        self.rewardedVideoDidFailCallBack(placementID, error, extra);
    }
}

- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.rewardedVideoDidRewardSuccessCallBack) {
        self.rewardedVideoDidRewardSuccessCallBack(placementID, extra);
    }
}

- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.rewardedVideoDidStartCallBack) {
        self.rewardedVideoDidStartCallBack(placementID, extra);
    }
    
}
-(void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success{
    
}

#pragma mark - ATInterstitialDelegate

- (void)interstitialDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.interstitialDidClickCallBack) {
        self.interstitialDidClickCallBack(placementID, extra);
    }
}

- (void)interstitialDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.interstitialDidCloseCallBack) {
        self.interstitialDidCloseCallBack(placementID, extra);
    }
}

- (void)interstitialDidEndPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.interstitialDidEndPlayingCallBack) {
        self.interstitialDidEndPlayingCallBack(placementID, extra);
    }
}

- (void)interstitialDidFailToPlayVideoForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    
    if (self.interstitialDidFailCallBack) {
        self.interstitialDidFailCallBack(placementID, error, extra);
    }
}

- (void)interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.interstitialDidShowCallBack) {
        self.interstitialDidShowCallBack(placementID, extra);
    }
}

- (void)interstitialDidStartPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.interstitialDidStartCallBack) {
        self.interstitialDidStartCallBack(placementID, extra);
    }
}

- (void)interstitialFailedToShowForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    
    if (self.interstitialFailedToShowCallBack) {
        self.interstitialFailedToShowCallBack(placementID, error, extra);
    }
}

-(void)interstitialDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success{
    
}


#pragma  mark - ATBannerDelegate

- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.bannerViewDidAutoRefreshCallBack) {
        self.bannerViewDidAutoRefreshCallBack(placementID, extra);
    }
}

- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.bannerViewDidClickCallBack) {
        self.bannerViewDidClickCallBack(placementID, extra);
    }
}

- (void)bannerView:(ATBannerView *)bannerView didCloseWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.bannerViewDidCloseCallBack) {
        self.bannerViewDidCloseCallBack(placementID, extra);
    }
}

- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.bannerViewDidShowAdCallBack) {
        self.bannerViewDidShowAdCallBack(placementID, extra);
    }
}

- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    
    if (self.bannerViewDidTapCloseCallBack) {
        self.bannerViewDidTapCloseCallBack(placementID, extra);
    }
}

- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    
    if (self.bannerViewFailedToAutoRefreshCallBack) {
        self.bannerViewFailedToAutoRefreshCallBack(placementID, error);
    }
}
-(void)bannerView:(ATBannerView*)bannerView didDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success{
    
}

@end

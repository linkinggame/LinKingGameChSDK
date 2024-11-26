

#import "LKAdManager.h"
#import "LKTitokExpressManager.h"
#import "LKTitokExpressManager.h"
#import "LKPointManager.h"
#import "LKGlobalConf.h"
#import "LKUser.h"
#import "LKSDKConfig.h"
#import "LKTopOnManager.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "LKLog.h"
@interface LKAdManager ()
@property (nonatomic, strong) LKTitokExpressManager *titoManager;
@property (nonatomic, strong) LKTopOnManager *topOnManager;
@property (nonatomic, assign) LKPLATFORM platform;
@property (nonatomic, strong) NSMutableArray *prArray;
@property (nonatomic, assign) BOOL isComplete;
@property (nonatomic, assign) BOOL isAggregate;
@property (nonatomic, assign) LKPAYUSERTYPE payUserVideoType;
@property (nonatomic, assign) LKPAYUSERTYPE payUserBannerType;
@property (nonatomic, assign) LKPAYUSERTYPE payUserInterstitialType;
@end


static LKAdManager *_instance = nil;

@implementation LKAdManager

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKAdManager alloc] init];
        _instance.topOnManager = [LKTopOnManager shared];
        [_instance adCallBack];
        [_instance loadData];
    });
    return _instance;
}

- (NSMutableArray *)prArray{
    if (!_prArray) {
        _prArray = [NSMutableArray array];
    }
    return _prArray;
}

#pragma mark -- 加载数据
- (void)loadData{
    [self.prArray removeAllObjects];
    LKSDKConfig *sdkConfig = [LKSDKConfig getSDKConfig];
    NSDictionary *ad_config_ios = sdkConfig.ad_config_ios;
    NSArray *pr = ad_config_ios[@"pr"];
    [self.prArray addObjectsFromArray:pr];
}

- (void)adCallBack{
    
    __weak typeof(self)weakSelf = self;
    

    
    /// MARK: Banner
    
    
    _topOnManager.bannerViewDidClickCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {

        NSLog(@"=== bannerView点击了 ===");
        if ([weakSelf.delegate respondsToSelector:@selector(bannerAdDidClick)]) {
            [weakSelf.delegate bannerAdDidClick];
        }
        
         NSDictionary *param = [weakSelf getAdBannerParam];
         [[LKPointManager shared] adLogEventName:@"click" withParameters:param complete:nil];
    };
    
    _topOnManager.bannerViewDidCloseCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        NSLog(@"=== bannerView关闭 ===");

        if ([weakSelf.delegate respondsToSelector:@selector(bannerAdDidClose)]) {
            [weakSelf.delegate bannerAdDidClose];
        }
        NSDictionary *param = [weakSelf getAdBannerParam];
         [[LKPointManager shared] adLogEventName:@"cancel" withParameters:param complete:nil];
    };
    
    _topOnManager.bannerViewFailedToAutoRefreshCallBack = ^(NSString * _Nullable placementID, NSError * _Nullable error) {
        
        NSLog(@"=== bannerView自动刷新失败 ===");
    };
    
    _topOnManager.bannerViewDidAutoRefreshCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
        NSLog(@"=== bannerView自动刷新 ===");
 
    };
    
    _topOnManager.bannerViewDidShowAdCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
        NSLog(@"=== bannerView展示成功 ===");
        if ([weakSelf.delegate respondsToSelector:@selector(bannerAdDidVisible)]) {
            [weakSelf.delegate bannerAdDidVisible];
        }
        
        NSDictionary *param = [weakSelf getAdBannerParam];
        [[LKPointManager shared] adLogEventName:@"show" withParameters:param complete:nil];
    };
    
    _topOnManager.bannerViewDidTapCloseCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
        NSLog(@"=== bannerView双击点击关闭 ===");
        
        if ([weakSelf.delegate respondsToSelector:@selector(bannerAdDidClose)]) {
            [weakSelf.delegate bannerAdDidClose];
        }
        NSDictionary *param = [weakSelf getAdBannerParam];
         [[LKPointManager shared] adLogEventName:@"cancel" withParameters:param complete:nil];
    };
    
    
    /// MARK: Reward
    _topOnManager.rewardedVideoDidFailCallBack = ^(NSString * _Nullable placementID, NSError * _Nullable error, NSDictionary * _Nullable extra) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(rewardAdDidLoadFail:)]) {
            [weakSelf.delegate rewardAdDidLoadFail:error];
        }
        NSDictionary *param = [weakSelf getAdVideoParam];
        [[LKPointManager shared] adLogEventName:@"show_fail" withParameters:param complete:nil];
        
    };
    
    _topOnManager.rewardedVideoDidClickCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(rewardAdDidClick)]) {
            [weakSelf.delegate rewardAdDidClick];
        }
        NSDictionary *param = [weakSelf getAdVideoParam];
        [[LKPointManager shared] adLogEventName:@"click" withParameters:param complete:nil];
    };
    
    _topOnManager.rewardedVideoDidCloseCallBack = ^(NSString * _Nullable placementID, BOOL reward, NSDictionary * _Nullable extra) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(rewardAdDidClose)]) {
            [weakSelf.delegate rewardAdDidClose];
        }
        NSDictionary *param = [weakSelf getAdVideoParam];
        [[LKPointManager shared] adLogEventName:@"cancel" withParameters:param complete:nil];
        
    };
    
    _topOnManager.rewardedVideoDidStartCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(rewardAdDidVisible)]) {
            [weakSelf.delegate rewardAdDidVisible];
        }
        
        NSDictionary *param = [weakSelf getAdVideoParam];
        [[LKPointManager shared] adLogEventName:@"show" withParameters:param complete:nil];
    };
    
    _topOnManager.rewardedVideoDidEndPlayingCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        

    };
    
    _topOnManager.rewardedVideoDidRewardSuccessCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(rewardAdWinReward)]) {
            [weakSelf.delegate rewardAdWinReward];
        }
        
        NSDictionary *param = [weakSelf getAdVideoParam];
            
        [[LKPointManager shared] adLogEventName:@"complete" withParameters:param complete:^(NSError * _Nonnull error) {
                  
        }];

    };
    
    
    /// MARK: Interstitial
    
    _topOnManager.interstitialDidFailCallBack = ^(NSString * _Nullable placementID, NSError * _Nullable error, NSDictionary * _Nullable extra) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(interstitialAdDidLoadFail:)]) {
            [weakSelf.delegate interstitialAdDidLoadFail:error];
        }
 
        NSDictionary *param = [weakSelf getAdInterstitialParam];
        [[LKPointManager shared] adLogEventName:@"show_fail" withParameters:param complete:nil];
    };
    
    _topOnManager.interstitialDidShowCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(interstitialAdDidVisible)]) {
            [weakSelf.delegate interstitialAdDidVisible];
        }
        NSDictionary *param = [weakSelf getAdInterstitialParam];
        [[LKPointManager shared] adLogEventName:@"show" withParameters:param complete:nil];
    };
    
    _topOnManager.interstitialDidCloseCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
      
        
        if ([weakSelf.delegate respondsToSelector:@selector(interstitialAdDidClose)]) {
            [weakSelf.delegate interstitialAdDidClose];
        }
        NSDictionary *param = [weakSelf getAdInterstitialParam];
        [[LKPointManager shared] adLogEventName:@"cancel" withParameters:param complete:nil];
    };
    
    _topOnManager.interstitialDidClickCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(interstitialAdDidClick)]) {
            [weakSelf.delegate interstitialAdDidClick];
        }
        NSDictionary *param = [weakSelf getAdInterstitialParam];
        [[LKPointManager shared] adLogEventName:@"click" withParameters:param complete:nil];
    };
    

    _topOnManager.interstitialFailedToShowCallBack = ^(NSString * _Nullable placementID, NSError * _Nullable error, NSDictionary * _Nullable extra) {
        if ([weakSelf.delegate respondsToSelector:@selector(interstitialAdDidLoadFail:)]) {
            [weakSelf.delegate interstitialAdDidLoadFail:error];
        }
        if (error != nil) {
            NSDictionary *param = [weakSelf getAdInterstitialParam];
            [[LKPointManager shared] adLogEventName:@"show_fail" withParameters:param complete:nil];
        }
    };
    
    _topOnManager.interstitialDidEndPlayingCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
        
    
    };
    
    _topOnManager.interstitialDidStartCallBack = ^(NSString * _Nullable placementID, NSDictionary * _Nullable extra) {
      

    };
    
    
    _topOnManager.topOnAdDidFinishLoadingCallBack = ^(NSString * _Nullable placementID, NSString * _Nonnull adType) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(adDidFinishLoading:)]) {
           
            if ([adType isEqualToString:@"bannerAd"]) {
                [weakSelf.delegate adDidFinishLoading:ADTYPE_BANNER];
            }else if([adType isEqualToString:@"interstitialAd"]){
                [weakSelf.delegate adDidFinishLoading:ADTYPE_INTERSTITAL];
            }else if([adType isEqualToString:@"rewardVideoAd"]){
                [weakSelf.delegate adDidFinishLoading:ADTYPE_REWARDVIDEO];
            }
        }
        
    };

    
    _topOnManager.topOnAdDidFailToLoadCallBack = ^(NSString * _Nullable placementID, NSError * _Nullable error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(adDidFailToLoadCallBack:)]) {
            [weakSelf.delegate adDidFailToLoadCallBack:error];
        }
    };
    
    
    
     
}


/// 初始化广告
#pragma mark -- 注册广告
- (void)registerAggregateAd{
    self.isAggregate = YES;
    self.platform = LKPLATFORM_TopOn;
    [self registerTopOnAd];
}

/// 展示广告
/// @param type 广告类型
/// @param viewController 控制器
/// @param superView 视图
- (void)initAd:(LKADTYPE)type rootViewController:(UIViewController * _Nonnull)viewController superView:(UIView * _Nullable)superView{

    if (type ==  ADTYPE_BANNER) {
        [self initializationBannerRootViewController:viewController superView:superView platform:LKPLATFORM_TopOn];
    }else if(type == ADTYPE_REWARDVIDEO){
        [self initializationRewardVideoAd:viewController platform:LKPLATFORM_TopOn];
    }else if(type == ADTYPE_INTERSTITAL){
        [self initializationInterstitialAd:viewController platform:LKPLATFORM_TopOn];
    }
}



/// 展示广告
/// @param type 广告类型
/// @param viewController 控制器
/// @param superView 视图
- (void)adShow:(LKADTYPE)type rootViewController:(UIViewController * _Nonnull)viewController superView:(UIView * _Nullable)superView{

    if (type ==  ADTYPE_BANNER) {
        [self initializationBannerRootViewController:viewController superView:superView platform:LKPLATFORM_TopOn];
    }else if(type == ADTYPE_REWARDVIDEO){
        [self initializationRewardVideoAd:viewController platform:LKPLATFORM_TopOn];
    }else if(type == ADTYPE_INTERSTITAL){
        [self initializationInterstitialAd:viewController platform:LKPLATFORM_TopOn];
    }
}

#pragma mark -- Banner
#pragma mark -- 初始化Banner

- (void)initializationBannerRootViewController:(UIViewController *)viewController superView:(UIView *)superView platform:(LKPLATFORM)platform{
    if (platform != LKPLATFORM_NONE) {
           self.platform = platform;
    }
    if (self.isAggregate == YES) {
        self.platform = LKPLATFORM_TopOn;
    }
    CGRect rect = CGRectZero;
    if (self.platform == LKPLATFORM_YLH) {
         rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width, 100);
    }else{
         rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 60);
    }
   
    [self initializationBannerRootViewController:viewController superView:superView frame:rect];
    
}

- (void)initializationBannerRootViewController:(UIViewController *)viewController superView:(UIView *)superView frame:(CGRect)frame platform:(LKPLATFORM)platform{
    
    [self initializationBannerRootViewController:viewController superView:superView frame:frame];
}

/// 初始化Banner
/// @param viewController viewController description
/// @param superView superView description
/// @param frame frame description
- (void)initializationBannerRootViewController:(UIViewController *)viewController superView:(UIView *)superView frame:(CGRect)frame{
    
    
    [self initializationTopOnBannerRootViewController:viewController superView:superView frame:frame];
       
}

#pragma mark -- 展示Banner
/// 展示广告
- (void)showBanner{
    self.payUserBannerType = LK_UNDEFINED;
    NSDictionary *param = [self getAdBannerParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showTopOnBanner];
    
}

/// 展示横屏
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showBannerPayuser:(LKPAYUSERTYPE)type{
    self.payUserBannerType = type;
    NSDictionary *param = [self getAdBannerParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showTopOnBanner];
    
}

- (NSDictionary *)getAdBannerParam{
    NSDictionary *param = @{};
    if (self.payUserBannerType == LK_UNDEFINED) {
        param = @{@"ad_type":@"banner",@"ad_channel":@"TopOn"};
    } else if (self.payUserBannerType == LK_PAY){
        param = @{@"ad_type":@"banner",@"ad_channel":@"TopOn",@"pay_user":@1}; // 付费
    } else if (self.payUserBannerType == LK_NOPAY){
        param = @{@"ad_type":@"banner",@"ad_channel":@"TopOn",@"pay_user":@2}; // 非付费
    } else {
        param = @{@"ad_type":@"banner",@"ad_channel":@"TopOn"};
    }
    return param;
}

#pragma mark -- 移除Banner
- (void)removeBannerViewFromSuperView{
    [self removeTopOnBanner];
}

#pragma mark -- 插屏
- (void)initializationInterstitialAd:(UIViewController *)viewController platform:(LKPLATFORM)platform{

     [self initializationInterstitialAd:viewController];
}
/// 初始化插屏广告
- (void)initializationInterstitialAd:(UIViewController *)viewController{
    [self initializationTopOnInterstitialAd:viewController];
    
   
}
/// 展现插屏
- (void)showInterstitialAd{
    self.payUserInterstitialType = LK_UNDEFINED;
    NSDictionary *param = [self getAdInterstitialParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showTopOnInterstitialAd];
   
}


/// 展现插屏
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showInterstitialAdPayuser:(LKPAYUSERTYPE)type{
    self.payUserInterstitialType = type;
    NSDictionary *param = [self getAdInterstitialParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showTopOnInterstitialAd];
}


- (NSDictionary *)getAdInterstitialParam{
    NSDictionary *param = @{};
    if (self.payUserInterstitialType == LK_UNDEFINED) {
        param = @{@"ad_type":@"interstitial",@"ad_channel":@"TopOn"};
    } else if (self.payUserInterstitialType == LK_PAY){
        param =  @{@"ad_type":@"interstitial",@"ad_channel":@"TopOn",@"pay_user":@1};// 付费
    } else if (self.payUserInterstitialType == LK_NOPAY){
        param =  @{@"ad_type":@"interstitial",@"ad_channel":@"TopOn",@"pay_user":@2}; // 非付费
    } else {
        param = @{@"ad_type":@"interstitial",@"ad_channel":@"TopOn"};
    }
    return param;
}


#pragma mark -- 激励
- (void)initializationRewardVideoAd:(UIViewController *)viewController platform:(LKPLATFORM)platform{

    [self initializationRewardVideoAd:viewController];
}
/// 初始化激励视频广告
- (void)initializationRewardVideoAd:(UIViewController *)viewController{

    [self initializationTopOnRewardVideoAd:viewController];
   
}
/// 展示激励视频广告 video|interstitial|banner|offerwall|video_full_screen|game_flow
- (void)showRewardVideoAd{
    self.payUserVideoType = LK_UNDEFINED;
    NSDictionary *param =  [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showTopOnRewardVideoAd];
}

/// 展示激励视频广告
/// @param type LK_UNDEFINED:未定义 LK_ALREADYPAY:已经付费 LK_NOPAY:非付费
- (void)showRewardVideoAdPayuser:(LKPAYUSERTYPE)type{
    self.payUserVideoType = type;
    NSDictionary *param = [self getAdVideoParam];
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    [self showTopOnRewardVideoAd];
}

- (NSDictionary *)getAdVideoParam{
    NSDictionary *param = @{};
    if (self.payUserVideoType == LK_UNDEFINED) {
        param = @{@"ad_type":@"video",@"ad_channel":@"TopOn"};
    } else if (self.payUserVideoType == LK_PAY){
        param =  @{@"ad_type":@"video",@"ad_channel":@"TopOn",@"pay_user":@1};;// 付费
    } else if (self.payUserVideoType == LK_NOPAY){
        param =  @{@"ad_type":@"video",@"ad_channel":@"TopOn",@"pay_user":@2};// 非付费
    }else{
        param = @{@"ad_type":@"video",@"ad_channel":@"TopOn"};
    }
    return param;
}

#pragma mark -- 全屏
- (void)initializationFullScreenVideoAd:(UIViewController *)viewController platform:(LKPLATFORM)platform{
    if (platform != LKPLATFORM_NONE) {
           self.platform = platform;
       }
    [self initializationFullScreenVideoAd:viewController];
}
// 初始全屏广告
- (void)initializationFullScreenVideoAd:(UIViewController *)viewController{

     
}

// 展示全屏广告
- (void)showFullScreenVideoAd{
    
    NSDictionary *param = @{@"ad_type":@"video_full_screen",@"ad_channel":@"TopOn"};
    [[LKPointManager shared] adLogEventName:@"pull_up" withParameters:param complete:nil];
    

}


// 初始全屏广告
- (void)initializationTittokFullScreenVideoAd:(UIViewController *)viewController{
     [[LKTitokExpressManager shared] initializationTittokFullScreenVideoAd:viewController];
}

// 展示全屏广告
- (void)showTittokFullScreenVideoAd{
    [[LKTitokExpressManager shared] showTittokFullScreenVideoAd];
}

#pragma mark -- TopOn
- (void)registerTopOnAd{
    
    [[LKTopOnManager shared] registerTopOnSDK];
}
- (void)initializationTopOnBannerRootViewController:(UIViewController *)viewController superView:(UIView *)superView frame:(CGRect)frame{
  
   [[LKTopOnManager shared] initializationTopOnBannerRootViewController:viewController superView:superView];
    
}
- (void)showTopOnBanner{
    [[LKTopOnManager shared] showTopOnBanner];
}
- (void)removeTopOnBanner{
    [[LKTopOnManager shared] removeTopOnBannerViewFromSuperView];
}

/// 初始化插屏广告
- (void)initializationTopOnInterstitialAd:(UIViewController *)viewController{
    [[LKTopOnManager shared] initializationTopOnInterstitialAd:viewController];
}
/// 展现插屏
- (void)showTopOnInterstitialAd{
    [[LKTopOnManager shared] showTopOnInterstitialAd];
}

/// 初始化激励视频广告
- (void)initializationTopOnRewardVideoAd:(UIViewController *)viewController{
    [[LKTopOnManager shared] initializationTopOnRewardVideoAd:viewController];
}
/// 展示激励视频广告
- (void)showTopOnRewardVideoAd{
    [[LKTopOnManager shared] showToOnRewardVideoAd];
}





// =======


- (BOOL)bannerViewAdReady{
    return YES;
}
- (BOOL)interstitialAdReady{
    return YES;
}
- (BOOL)rewardVideoAdReady{
    return YES;
}

@end


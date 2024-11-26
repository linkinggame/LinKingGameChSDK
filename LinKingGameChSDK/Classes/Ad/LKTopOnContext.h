//
//  LKTopOnContext.h
//  LinKingSDK
//
//  Created by leon on 2021/5/28.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATBannerView;


@protocol LKTopOnContext

#pragma mark - ATRewardedVideoDelegate

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID;
- (void)didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error;
- (void)rewardedVideoDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)rewardedVideoDidCloseForPlacementID:(NSString *)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra;
- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra;
- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success;
#pragma mark - ATInterstitialDelegate

- (void)interstitialDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)interstitialDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)interstitialDidEndPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)interstitialDidFailToPlayVideoForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra;
- (void)interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)interstitialDidStartPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)interstitialFailedToShowForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra;
-(void)interstitialDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success;

#pragma  mark - ATBannerDelegate
- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)bannerView:(ATBannerView *)bannerView didCloseWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra;
- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error;
- (void)bannerView:(ATBannerView*)bannerView didDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success;
@end

@interface LKTopOnContext : NSObject

@end



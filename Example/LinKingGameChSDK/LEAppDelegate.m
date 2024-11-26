//
//  LEAppDelegate.m
//  LinKingGameChSDK
//
//  Created by leon on 11/26/2024.
//  Copyright (c) 2024 leon. All rights reserved.
//

#import "LEAppDelegate.h"
#import <LinKingGameChSDK/LinKingGameChSDK.h>
#import <AdSupport/AdSupport.h>

@interface LEAppDelegate ()
@property (nonatomic, strong) LKSDKManager *manager;
@end


@implementation LEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // SDK 日志等级
    [LKLog setLogLevel:LKLogLevelVerbose];
    
    // 第三方的 日志等级
    [LKThirdLog setThirdLog:LKThirdLogLevelOn];
    

    [[LKAFManager shared] registAppsFlyerDevKey:@"Rz7VqcsJLyJeofrrdNMQgg" appleAppID:@"id1559916773"];
    // 启动
    [[LKSDKManager instance] application:application didFinishLaunchingWithOptions:launchOptions];
    /// 注册SDK
    [[LKSDKManager instance] registLinKingSDKAppID:@"xxyzappcn_ios" withSecretkey:@"0f413dfbac" cmoplete:^(LKSDKManager * _Nonnull manager, NSError * _Nonnull error) {

        if (error != nil) {
            NSLog(@"初始化失败：%@",error);
        }
   }];
    

//    [[LKSDKManager instance] application:application didFinishLaunchingWithOptions:launchOptions];
//
//    [[LKSDKManager instance] registLinKingSDKAppID:@"qmscs_ios" withSecretkey:@"1w23e4r5t6y" cmoplete:^(LKSDKManager * _Nonnull manager, NSError * _Nonnull error) {
//
//        if (error != nil) {
//            NSLog(@"初始化失败：%@",error);
//        }
//   }];


    return YES;
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    return [[LKSDKManager instance] application:app openURL:url options:options];;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   return [[LKSDKManager instance] application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString * _Nullable )sourceApplication annotation:(id)annotation{
  return  [[LKSDKManager instance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[LKSDKManager instance] applicationWillTerminate:application];
 
}

#pragma mark Universal Link
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    return [[LKSDKManager instance] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}
// Report Push Notification attribution data for re-engagements
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[LKSDKManager instance] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[LKSDKManager instance] applicationDidBecomeActive:application];
}


@end

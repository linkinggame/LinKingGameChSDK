//
//  LEViewController.m
//  LinKingGameChSDK
//
//  Created by leon on 11/26/2024.
//  Copyright (c) 2024 leon. All rights reserved.
//

#import "LEViewController.h"
#import <LinKingGameChSDK/LinKingGameChSDK.h>
#import "LKAlterLoginApi.h"
@interface LEViewController ()
<LKAdManagerDelegate,LKOauthManagerDelegate,LKAdFaceDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) LKSDKManager *manager;
@end

@implementation LEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /// 监听SDK初始化回调
    [LKSDKManager instance].initializeSDKCallBack = ^(LKSDKManager * _Nonnull manager, NSError * _Nonnull error) {
        self.manager = manager;
        if (!error) {
            // 登录
            [self login:manager];
        }
        [self initADWithManager:manager];
        
        [self observerRealName:manager];
    };


}



- (void)observerRealName:(LKSDKManager *)manager{
    manager.oauthManager.realNameCompleteCallBack = ^(BOOL isSuccess, LKUser * _Nullable user, NSError * _Nullable error) {
        
        NSLog(@"isSuccess:%d",isSuccess);
        
        NSLog(@"user.real_name:%@",user.real_name);
        
        NSLog(@"error:%@",error);
    };
}


- (void)login:(LKSDKManager *)manager{
    manager.oauthManager.delegate = self;
    /// 唤起授权面板
    [manager.oauthManager loginWithDashboardRootViewController:self complete:^(LKUser * _Nonnull user, NSError * _Nonnull error) {
        if (!error) {
            // TODO: 保存用户信息
            LKLogInfo(@"userId:%@",user.userId);
        }else{
            LKLogInfo(@"%@",error);
        }

    }];
}
- (IBAction)logoutAction:(id)sender {

    [[LKSDKManager instance].oauthManager logOutSDK];
   
    
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self logEnterGame]; 戴明亮 340521199211183336
//
//    [self logTutorial];
//
//    [self logStage];
//
//    [self logLevel];
//
//    [self logEvent];
//
//    [self logEventParam];
    
    
//    [[LKPointManager shared] logRoleCreate:@"1000" roleId:@"200" roleName:@"奥斯卡"];
//
//    [[LKPointManager shared] logRoleLogin:@"10000" roleId:@"10000"];
    
    if ([LKSDKManager instance].oauthManager.isRealName) {
        NSLog(@"已经实名");
    }else{
        NSLog(@"未实名");
    }
  
}


- (void)logEnterGame{
    
    [[LKPointManager shared] logEnterGame:@"110" roleId:@"100" roleName:@"leon" enterGame:YES];
}

- (void)logTutorial{
    
    [[LKPointManager shared] logTutorial:@"1" content:@"第一关" EventServerId:@"110" roleId:@"100" roleName:@"leon"];
}


- (void)logStage{
    [[LKPointManager shared] logStage:1 serverId:@"110" roleId:@"100" roleName:@"leon"];
}

- (void)logLevel{
    [[LKPointManager shared] logLevel:1 serverId:@"110" roleId:@"100" roleName:@"leon"];
}

- (void)logEvent{
    [[LKPointManager shared] logEvent:@"充值"];
}

- (void)logEventParam{
    [[LKPointManager shared] logEvent:@"暴击" withValues:@{}];
}


#pragma LKOauthManagerDelegate
- (void)logoutSDKCallback{
    NSLog(@"====退出登录回调====");
    [self login:self.manager];
}
- (void)changeAccountCallBack{
    NSLog(@"====切换账号回调====");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self login:self.manager];
    });
}

- (void)initADWithManager:(LKSDKManager *)manager{
    
      // 设置广告回调代理
//      manager.adManager.delegate =  self;
    
    manager.adFace.delegate = self;
    
}





- (IBAction)showBannerAction:(id)sender {
    // 初始化横屏广告
    // [[LKSDKManager instance].adFace initAd:LK_ADTYPE_BANNER rootViewController:self superView:self.view];
    NSLog(@"info=%@", @"这是测试注销账号");
    [LKAlterLoginApi closeUserInfoWithId: @"" complete:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        if (error == nil) {
            NSLog(@"info=%@", @"注销成功");
            //走退出登录的操作
            [[LKSDKManager instance].oauthManager logOutSDK];
        }else{
            NSLog(@"info=%@", @"注销失败");
        }
    }];
    
}

- (IBAction)showInterstitialAction:(id)sender {
    // 初始化插屏广告

//    [[LKSDKManager instance].adManager initAd:ADTYPE_INTERSTITAL rootViewController:self superView:self.view];

    [[LKSDKManager instance].adFace initAd:LK_ADTYPE_INTERSTITAL rootViewController:self superView:self.view];
}

- (IBAction)showRewardVideoAction:(id)sender {
    // 初始化激励视频广告
//    [[LKSDKManager instance].adManager initAd:ADTYPE_REWARDVIDEO rootViewController:self superView:self.view];
    [[LKSDKManager instance].adFace initAd:LK_ADTYPE_REWARDVIDEO rootViewController:self superView:self.view];
     
}
#pragma LKAdManagerDelegate
///// TopOn 广告加载失败
//- (void)topOnAdDidFailToLoadFail:(NSError * _Nullable)error{
//    NSLog(@"%@",error);
//}
///// 广告加载成功
//- (void)adDidFinishLoading:(LKADTYPE)type{
//    if (type == ADTYPE_BANNER) {
//        [[LKSDKManager instance].adFace showBannerPayuser:LK_PAYUSERTYPE_PAY];
//    }else if(type == ADTYPE_INTERSTITAL){
//        [[LKSDKManager instance].adFace showInterstitialAdPayuser:LK_PAYUSERTYPE_PAY];
//    }else if(type == ADTYPE_REWARDVIDEO){
//        [[LKSDKManager instance].adFace showRewardVideoAdPayuser:LK_PAYUSERTYPE_PAY];
//    }
//}
//
//- (void)rewardAdDidFinishLoading{
//
//}



/// 横屏广告加载失败
/// @param error 错误信息
- (void)bannerAdDidLoadFail:(NSError * _Nullable)error{
    
}
/// 广告加载成功
- (void)bannerAdDidFinishLoading{
    
}
/// 横屏广告点击关闭
- (void)bannerAdDidClose{
    
}
/// 横屏广告点击
- (void)bannerAdDidClick{
    
}
/// 横屏广告呈现成功
- (void)bannerAdDidVisible{
    
}


/// 激励视频加载失败
/// @param error 错误信息
- (void)rewardAdDidLoadFail:(NSError * _Nullable)error{
    NSLog(@"%s",__func__);
}
/// 展示失败
/// @param error error description
- (void)rewardAdDidVisibleFail:(NSError * _Nullable)error{
    NSLog(@"%s",__func__);
}
/// 广告加载成功
- (void)rewardAdDidFinishLoading{
    NSLog(@"%s",__func__);
    [[LKSDKManager instance].adFace showRewardVideoAdPayuser:LK_PAYUSERTYPE_PAY];
}
/// 激励视频呈现成功
- (void)rewardAdDidVisible{
    NSLog(@"%s",__func__);
}
/// 激励视频点击关闭
- (void)rewardAdDidClose{
    NSLog(@"%s",__func__);
}
/// 激励视频点击
- (void)rewardAdDidClick{
    NSLog(@"%s",__func__);
}
/// 获取奖励
- (void)rewardAdWinReward{
    NSLog(@"%s",__func__);
}


/// 插屏广告加载失败
/// @param error 错误信息
- (void)interstitialAdDidLoadFail:(NSError * _Nullable)error{
    
}
/// 展示失败
/// @param error error description
- (void)interstitialAdDidVisibleFail:(NSError * _Nullable)error{
    
}
/// 广告加载成功
- (void)interstitialAdDidFinishLoading{
    
}
/// 插屏广告呈现成功
- (void)interstitialAdDidVisible{
    
}
/// 插屏广告关闭
- (void)interstitialAdDidClose{
    
}
/// 插屏广告点击
- (void)interstitialAdDidClick{
    
}




///// 横屏广告加载失败
///// @param error 错误信息
//- (void)bannerAdDidLoadFail:(NSError * _Nullable)error{
//
//    NSLog(@"%s",__func__);
//}
///// 横屏广告点击关闭
//- (void)bannerAdDidClose{
//    NSLog(@"%s",__func__);
//}
///// 横屏广告点击
//- (void)bannerAdDidClick{
//    NSLog(@"%s",__func__);
//}
///// 横屏广告呈现成功
//- (void)bannerAdDidVisible{
//    NSLog(@"%s",__func__);
//}
//
//
///// 激励视频加载失败
///// @param error 错误信息
//- (void)rewardAdDidLoadFail:(NSError * _Nullable)error{
//    NSLog(@"%s",__func__);
//}
///// 激励视频点击关闭
//- (void)rewardAdDidClose{
//    NSLog(@"%s",__func__);
//}
///// 激励视频点击
//- (void)rewardAdDidClick{
//    NSLog(@"%s",__func__);
//}
///// 激励视频呈现成功
//- (void)rewardAdDidVisible{
//    NSLog(@"%s",__func__);
//}
///// 获取奖励
//- (void)rewardAdWinReward{
//    NSLog(@"%s",__func__);
//}
//
//- (void)rewardAdDidVisibleFail:(NSError *)error{
//
//}
//
//
///// 插屏广告加载失败
///// @param error 错误信息
//- (void)interstitialAdDidLoadFail:(NSError * _Nullable)error{
//    NSLog(@"%s",__func__);
//}
///// 插屏广告关闭
//- (void)interstitialAdDidClose{
//    NSLog(@"%s",__func__);
//}
///// 插屏广告点击
//- (void)interstitialAdDidClick{
//    NSLog(@"%s",__func__);
//}
///// 插屏广告呈现成功
//- (void)interstitialAdDidVisible{
//    NSLog(@"%s",__func__);
//}
//
//- (void)interstitialAdDidVisibleFail:(NSError *)error{
//
//}


- (IBAction)showFullScreenAction:(id)sender {

    
}


- (IBAction)payAaction:(UIButton *)sender {
    self.textView.text = @"";
    [self.manager.payManager requestProductDatasComplete:^(NSError * _Nullable error, NSArray * _Nullable products) {
        srand((unsigned)time(0));
        int num = rand() % 5;
        LKGoods *goods = products[num];
            NSDictionary *params = @{
                @"cp_order_no":[NSString stringWithFormat:@"%@%d",@"432432494238934829042", rand() % 1000],
                @"server_id":@"2",
                @"notify_url":@"xxx",
                @"extra":@"1",
                @"role_id":@"31231",
                @"product_id":@"com.lingyue.jinbi1",
                @"product_desc":@"10金币",
                @"amount":@"1",
                @"type":@"ios"
            };
            
        [self.manager.payManager showPayViewRootViewController:self productId:@"com.lingyue.jinbi1" parameters:params complete:^(INAPPPurchType type, NSError * _Nullable error) {
            NSString *info = nil;
            if (type == INAPPPurchSuccess) { // 购买成功
                NSLog(@"支付成功");
                info = @"支付成功";
            }else if(type == INAPPPurchCancle){ // 购买取消
                info = @"支付取消";
            }else if(type == INAPPPurchFailed){ // 购买失败
                info = @"苹果支付失败";
            }else if(type == INAPPServiceFail){ // 购买失败
                info = @"购买失败";
            }else if(type == INAPPPurchNoGoods){ // 没有商品
                info = @"没有商品";
            }else if(type == INAPPReceiptInvalid){ // 支付票据无效
                info = @"支付票据无效";
            }else if(type == INAPPOrderNotExist){ // 支付订单不存在
                info = @"支付订单不存在";
            }else if(type == INAPPOrderClosed){ // 支付订单已结束
                info = @"支付订单已结束";
            }
            if (error != nil) {
                info = error.localizedDescription;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = info;
            });
            NSLog(@"info=%@",info);
            NSLog(@"error=%@",error);
            NSLog(@"error=%@",error.localizedDescription);
        }];
    }];
    

    

}


- (IBAction)requestGoodsList:(UIButton *)sender {
    

    
    
    [self.manager.payManager requestProductDatasComplete:^(NSError * _Nullable error, NSArray * _Nullable products) {
         NSLog(@"-->%@",products);
        
        for (LKGoods * goods in products) {
            NSLog(@"name:%@",goods.name);
            NSLog(@"num:%@",goods.num);
            NSLog(@"productId:%@",goods.productId);
            NSLog(@"amount:%@",goods.amount);
        }
    }];

}


- (IBAction)iosPayAction:(id)sender {
//    NSDictionary *params = @{
//        @"cp_order_no":@"1587465595000",
//        @"server_id":@"1",
//        @"notify_url":@"xxx",
//        @"extra":@"1",
//        @"role_id":@"31231",
//        @"product_id":@"1587465595000",
//        @"product_desc":@"红包",
//        @"amount":@"0.01"
//    };
//
//    [self.manager.payManager startPurchWithID:@"1587465595000" parames:params completeHandle:^(INAPPPurchType type, NSError * _Nullable data) {
//    }];
    
    [self.manager.oauthManager showRealNameViewRootViewController:self complete:^(BOOL isCancel, NSError * _Nullable error) {
        // 是否取消
        NSLog(@"isCancel = %d",isCancel);
        if (isCancel == NO) {
            if(error == nil){
                NSLog(@"认证成功回调");
            }else{
                NSLog(@"%@",error);
            }
        }else{
            NSLog(@"已取消");
        }
        
    }];
    
}


- (IBAction)pointAction:(id)sender {
    

 
}

- (IBAction)customePointAction:(id)sender {
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

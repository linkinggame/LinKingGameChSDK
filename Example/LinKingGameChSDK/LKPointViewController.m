//
//  LKPointViewController.m
//  LinKingSDK_Example
//
//  Created by leon on 2021/4/16.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKPointViewController.h"
#import <LinKingGameChSDK/LinKingGameChSDK.h>
@interface LKPointViewController ()

@end

@implementation LKPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
// 激活
- (IBAction)pointEvent_A:(id)sender {
    
    NSLog(@"==SDK内置打点==");
}

// 进入游戏
- (IBAction)pointEvent_B:(id)sender {
    
     
    [[LKPointManager shared] logEnterGame:@"110" roleId:@"100" roleName:@"leon" enterGame:YES];
}

// 启动
- (IBAction)pointEvent_C:(id)sender {
    NSLog(@"==SDK内置打点==");
}

// 创建角色
- (IBAction)pointEvent_D:(id)sender {
    
    [[LKPointManager shared] logRoleCreate:@"10000" roleId:@"10000" roleName:@"邪眸白虎"];
}

// 角色登录
- (IBAction)pointEvent_E:(id)sender {
    
    [[LKPointManager shared] logRoleLogin:@"10000" roleId:@"10000"];
}


// 等级
- (IBAction)pointEvent_F:(id)sender {
    
    [[LKPointManager shared] logLevel:1 serverId:@"110" roleId:@"100" roleName:@"leon"];
    
  
}



// 关卡
- (IBAction)pointEvent_G:(id)sender {
    
    [[LKPointManager shared] logStage:1 serverId:@"10000" roleId:@"10000" roleName:@"竹青"];
    
}

// 游玩时长
- (IBAction)pointEvent_H:(id)sender {
    
    NSLog(@"==SDK内置打点==");
  
}

// 引导页
- (IBAction)pointEvent_I:(id)sender {
    [[LKPointManager shared] logTutorial:@"1" content:@"1" EventServerId:@"100" roleId:@"200" roleName:@"胖子"];
}

// 有参自定义事件
- (IBAction)pointEvent_J:(id)sender {
    [[LKPointManager shared] logEvent:@"test" withValues:@{}];
}
// 无参自定义事件
- (IBAction)pointEvent_K:(id)sender {
    [[LKPointManager shared] logEvent:@"test"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  LKControlUtil.m
//  LinKingSDK
//
//  Created by leon on 2021/5/19.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKControlUtil.h"
#import "LKSDKConfig.h"
@interface LKControlUtil ()

@end

@implementation LKControlUtil


///  是否开启防沉迷开关
+ (BOOL)isOpenStopAddiction{
    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
    return [config.real_name_switch boolValue];
}

/// 实名认证中状态开关
+ (BOOL)realNameSuccessSwitch{
    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
    return [config.real_name_success boolValue];
}

/// 支付开关
+ (BOOL)payLimintSwitch{
    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
    return [config.pay_limit boolValue];
}


@end

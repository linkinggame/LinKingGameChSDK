//
//  LKControlUtil.h
//  LinKingSDK
//
//  Created by leon on 2021/5/19.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKControlUtil : NSObject
///  是否开启防沉迷  true:开启 false:失败
+ (BOOL)isOpenStopAddiction;
/// 实名认证中状态   true:认定认证成功 false:认定认证失败
+ (BOOL)realNameSuccessSwitch;
/// 充值   true: 只有实名认证用户才可以充值  false: 所有状态下的玩家都可以充值
+ (BOOL)payLimintSwitch;

@end

NS_ASSUME_NONNULL_END

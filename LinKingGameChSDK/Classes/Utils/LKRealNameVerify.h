//
//  LKRealNameVerify.h
//  LinKingSDK
//
//  Created by leon on 2021/5/19.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,RealVerifyState) {
    RealVerifyStateUnverified, // 0 未认证
    RealVerifyStateAuthenticating, // 1 认证中
    RealVerifyStateVerified   // 2 已认证
};

NS_ASSUME_NONNULL_BEGIN

@protocol LKRealNameVerify
/// 是否已实名
- (BOOL)isRealName;
/// 获取当前实名认证状态
- (RealVerifyState)getRealVerifyState;
/// 通过转换将字符串类型
/// @param string string description
- (RealVerifyState)convertRealVerifyStateWithString:(NSString *)string;
/// 保存用户实名认证状态
/// @param state 状态
- (void)saveUserRealVerifyState:(NSString *)state;
@end

NS_ASSUME_NONNULL_END

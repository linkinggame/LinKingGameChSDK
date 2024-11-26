//
//  LKConcreteRealNameVerify.m
//  LinKingSDK
//
//  Created by leon on 2021/5/19.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKConcreteRealNameVerify.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "NSObject+LKUserDefined.h"
#import "LKControlUtil.h"
#import "LKRealVerifyEvent.h"
#import "LKLog.h"
static LKConcreteRealNameVerify * _instance = nil;
@interface LKConcreteRealNameVerify (){
    NSString *_realVerifyStateString;
}

@end

@implementation LKConcreteRealNameVerify

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKConcreteRealNameVerify alloc] init];
        [_instance addMQTTObserRealVerifyEvent];
        
    });
    return _instance;
}

- (void)addMQTTObserRealVerifyEvent{
    
    [LKRealVerifyEvent shared].realVerifyEventHandler = ^(NSString * _Nullable realVerify) {
        LKLogInfo(@"认证状态发送改变---%@",realVerify);
        self->_realVerifyStateString = realVerify;
    };
}

- (RealVerifyState)getRealVerifyState {
    int state = 0;
    if (_realVerifyStateString.exceptNull != nil) {
        // 重内存中获取
        state = [_realVerifyStateString intValue];
    }else{
        // 从沙盒中获取
        NSString *realVerifyStateString = [self getUserRealVerifyState];
        if (realVerifyStateString.exceptNull != nil) {
            state = [[self getUserRealVerifyState] intValue];
        }
    }
    RealVerifyState verifyState;
    switch (state) {
        case 0:
            verifyState = RealVerifyStateUnverified;
            break;
        case 1:
            verifyState = RealVerifyStateAuthenticating;
            break;
        case 2:
            verifyState = RealVerifyStateVerified;
            break;
        default:
            verifyState = RealVerifyStateUnverified;
            break;
    }
    
    return verifyState;
}

/// 通过String 转换为 枚举状态
/// @param string string description
- (RealVerifyState)convertRealVerifyStateWithString:(nonnull NSString *)string {
    if (string.exceptNull == nil) {
        return RealVerifyStateUnverified;
    }
    int state = [string intValue];
    RealVerifyState verifyState;
    switch (state) {
        case 0:
            verifyState = RealVerifyStateUnverified;
            break;
        case 1:
            verifyState = RealVerifyStateAuthenticating;
            break;
        case 2:
            verifyState = RealVerifyStateVerified;
            break;
        default:
            verifyState = RealVerifyStateUnverified;
            break;
    }
    
    return verifyState;
}

/// 获取用户实名认证状态
- (NSString *)getUserRealVerifyState{
    LKUser *user = [LKUser getUser];
    if (user == nil || user.userId.exceptNull == nil) {
        return [NSString stringWithFormat:@"%ld",(long)RealVerifyStateUnverified];
    }
    NSString *key = [NSString stringWithFormat:@"REALVERIFYKEY_%@",user.userId];
    NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (state.exceptNull == nil) {
        return [NSString stringWithFormat:@"%ld",(long)RealVerifyStateUnverified];
    }
    return state;
}



/// 保存用户实名认证状态
/// @param state 状态
- (void)saveUserRealVerifyState:(NSString *)state{
    
    LKUser *user = [LKUser getUser];
    if (user == nil) {
        return;
    }
    if (state.exceptNull == nil || user.userId.exceptNull == nil) {
        return;
    }
    // 保存到全局
    _realVerifyStateString = state;
    NSString *key = [NSString stringWithFormat:@"REALVERIFYKEY_%@",user.userId];
    // k:userId v:state
    [[NSUserDefaults standardUserDefaults] setObject:state forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/// 是否已经实名
- (BOOL)isRealName{
    BOOL isReal = NO;
    RealVerifyState state = [self getRealVerifyState];
    switch (state) {
        case RealVerifyStateUnverified:
        {
            isReal = NO;
            LKLogInfo(@"==未认定实名==");
            break;
            
        }
        case RealVerifyStateAuthenticating:
        {
            // 认证中的状态，根据开关来判断是否已认证成功
            if ([LKControlUtil realNameSuccessSwitch]) {
                // 认定成功
                isReal = YES;
                if ([self realNameisEmpty] == YES) {
                    LKLogInfo(@"==用户名为空==");
                    isReal = NO;
                }
                LKLogInfo(@"==认证中的状态认定已实名==");
            }else{
                // 认定失败
                isReal = NO;
                LKLogInfo(@"==认证中的状态认定未实名==");
            }
            break;
        }
        case RealVerifyStateVerified:
        {
            isReal = YES;
            if ([self realNameisEmpty] == YES) {
                isReal = NO;
            }
            LKLogInfo(@"==已认定实名==");
            break;
        }
        default:
            isReal = NO;
            break;
    }
    
    return isReal;
}





- (BOOL)realNameisEmpty{
    BOOL isEmpty = YES;
    LKUser*user = [LKUser getUser];
    if (user != nil) {
        if (user.real_name.exceptNull != nil) { // 认证名
            isEmpty = NO;
        }
    }
    return isEmpty;
}







@end

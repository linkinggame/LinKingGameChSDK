//
//  LKAccountBlockedEvent.m
//  LinKingSDK
//
//  Created by leon on 2021/8/2.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKAccountBlockedEvent.h"
#import "LKLog.h"
#import "NSObject+LKUserDefined.h"

static LKAccountBlockedEvent *_instance = NULL;
@interface LKAccountBlockedEvent ()

@end

@implementation LKAccountBlockedEvent


+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKAccountBlockedEvent alloc] init];
    });
    return _instance;
}

// 账号封禁事件
- (NSString *)getTopicEvent {
    return @"blocked_account";
}

/**
 {"desc":"账号被封禁","user_id":"1390611194220929024","event":"blocked_account"}
 */

/// <#Description#>
/// @param message <#message description#>
/// @param topic <#topic description#>
/// @param retained <#retained description#>
- (void)receivedMessage:(NSDictionary *)message onTopic:(NSString *)topic retained:(BOOL)retained {
    
    // 检测是否是自己的信息
    [super receivedMessage:message onTopic:topic retained:retained];
    LKLogInfo(@"===SATRT接收到账号封禁事件通知===");
    LKLogInfo(@"message = %@",message);
    LKLogInfo(@"===END接收到账号封禁通知===");
    NSString *desc = message[@"desc"];
    NSString *userId = message[@"user_id"];
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          desc.exceptNull != nil ?desc:@"账号封禁",@"desc"
                          ,userId.exceptNull != nil ? userId : @"",@"user_id"
                          ,nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLOCKEDACCOUNT" object:nil userInfo:info];
}

@end

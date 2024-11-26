//
//  LKTopicEvent.m
//  LinKingSDK
//
//  Created by leon on 2021/5/25.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKTopicEvent.h"
#import "LKUser.h"
#import "NSObject+LKUserDefined.h"
#import "LKLog.h"
@implementation LKTopicEvent



- (BOOL)isMeWithUserId:(NSString *)userId{
    BOOL isMe = NO;
    LKUser *user =[LKUser getUser];
    NSString *currentUserId = user.userId;
    if (currentUserId.exceptNull != nil
        && userId.exceptNull != nil
        && [currentUserId isEqualToString:userId])
    {
        isMe = YES;
    }
    return isMe;
}
- (NSString * _Nonnull)getTopicEvent {
    return @"";
}

- (void)receivedMessage:(NSDictionary * _Nonnull)message onTopic:(NSString * _Nullable)topic retained:(BOOL)retained {
    LKLogInfo(@"~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*");
    LKLogInfo(@"message = %@",message);
    LKLogInfo(@"~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*");
    NSString *userId = message[@"user_id"];
    // 如果不是当前用户直接返回
    if ([self isMeWithUserId:userId] == NO) {
        return;
    }
    
}

@end

//
//  LKRedDotEvent.m
//  LinKingSDK
//
//  Created by leon on 2021/5/25.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKRedDotEvent.h"
#import "LKLog.h"
static LKRedDotEvent * _instance = nil;
@interface LKRedDotEvent ()
@property (nonatomic, assign) BOOL isRedRot;

@end

@implementation LKRedDotEvent


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKRedDotEvent alloc] init];
    });
    return _instance;
}

- (nonnull NSString *)getTopicEvent {
    return @"question_red_dot";
}

/**
 
 TODO:消息可能被接收多次,需要进行保护处理
 {
     "data":"",  //  是否有小红点
     "user_id":""
 }
 */
- (void)receivedMessage:(NSDictionary * _Nonnull)message onTopic:(NSString *)topic retained:(BOOL)retained {
    
    LKLogInfo(@"===SATRT接收到小红点事件通知===");
    LKLogInfo(@"message = %@",message);
    LKLogInfo(@"===END接收到小红点事件通知===");
    NSNumber *isRedRot = message[@"data"];
    NSString *userId = message[@"user_id"];
    // 防止重复消费
    if (self.isRedRot == [isRedRot boolValue]) {
        return;
    }
    self.isRedRot = [isRedRot boolValue];
    [self processMessage:self.isRedRot userId:userId];
}

- (BOOL)getisRedRot{
    return self.isRedRot;
}

- (void)processMessage:(BOOL)isRedRod userId:(NSString *)userId{
    if (self.isRedRodHandler) {
        self.isRedRodHandler(isRedRod);
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isRedRod],@"question_red_dot" ,nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REDDOTUPDATE" object:dict userInfo:dict];
}


@end

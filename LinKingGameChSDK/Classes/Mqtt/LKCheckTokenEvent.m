//
//  LKCheckTokenEvent.m
//  LinKingSDK
//
//  Created by leon on 2021/5/25.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//


#import "LKCheckTokenEvent.h"
#import "LKAuthApi.h"
#import "LKLog.h"
#import "NSObject+LKUserDefined.h"
@interface LKCheckTokenEvent ()
@end

static LKCheckTokenEvent *_instance = nil;
@implementation LKCheckTokenEvent


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKCheckTokenEvent alloc] init];
    });
    return _instance;
}

- (NSString * _Nonnull)getTopicEvent {
    return @"check_session_token";
}

/**
 
 TODO:消息可能被接收多次,需要进行保护处理
 {
     "event":"",
     "user_id":"",
     "session_token":""
 }
 */
- (void)receivedMessage:(NSDictionary * _Nonnull)message onTopic:(NSString * _Nullable)topic retained:(BOOL)retained {
    [super receivedMessage:message onTopic:topic retained:retained];
    LKLogInfo(@"===SATRT检查Token事件通知===");
    LKLogInfo(@"message = %@",message);
    LKLogInfo(@"===END检查Token事件通知===");
    NSString *token = message[@"session_token"];
    NSString *userId = message[@"user_id"];
   
    [self processMessage:token userId:userId];
    
}

- (void)processMessage:(NSString *)token userId:(NSString *)userId{

    [LKAuthApi checkSessionTokenWithComplete:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        if (error == nil) {
            NSNumber *success = result[@"success"];
            if ([success boolValue] == YES){
                LKLogInfo(@"token校验成功");
            }else{
                NSNumber *codeServer = result[@"code"];
                int code = -1;
                if (codeServer.exceptNull != nil) {
                    code = [codeServer intValue];
                }
                // token 失效
                if (code == 2101) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TOKENINVALID" object:nil];
                }else{
                    LKLogInfo(@"其他错误❌");
                }
            }
        }else{ // 网络错误
           
        }
    }];
    
    
}

@end

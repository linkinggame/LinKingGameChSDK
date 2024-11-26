//
//  LKAntiAddictionEvent.m
//  LinKingSDK
//
//  Created by leon on 2021/5/25.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKAntiAddictionEvent.h"
#import "NSObject+LKUserDefined.h"
#import "LKAuthApi.h"
#import "LKLog.h"
#import "LKMQTTFace.h"
#import "LKUserEntity.h"
#import "LKUser.h"
static LKAntiAddictionEvent *_instance = nil;

@interface LKAntiAddictionEvent ()
@property (nonatomic,copy) NSString *realVerify;
@end

@implementation LKAntiAddictionEvent

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKAntiAddictionEvent alloc] init];
    });
    return _instance;
}

- (NSString * _Nonnull)getTopicEvent {
    return @"anti_addiction";
}
/**
 
 TODO:消息可能被接收多次,需要进行保护处理
 {
     "event":"real_verify",
     "real_verify":"",   // 0 未认证  1 认证中 2 已认证   // 1 关闭防沉迷校验  2认证队列中的玩家认为已完成实名认证状态  3认证队列中的完成认为未实名状态(国家要求)
     "user_id":"",
 */
- (void)receivedMessage:(NSDictionary * _Nonnull)message onTopic:(NSString * _Nullable)topic retained:(BOOL)retained {
    [super receivedMessage:message onTopic:topic retained:retained];
    
    LKLogInfo(@"[LKAntiAddictionEvent] ===SATRT接收到防沉迷消息通知===");
    LKLogInfo(@"[LKAntiAddictionEvent]  message = %@",message);
    LKLogInfo(@"[LKAntiAddictionEvent] ===END接收到防沉迷消息通知===");
    
    [self processMessage:message];
}

- (void)processMessage:(NSDictionary *)message{
    
    /**
     {
     {
       "success" : false,
       "code" : "2234",
       "data" : {
         "real_verify" : 0,
         "user_id" : "1397135675901890560",
         "ok" : false,
         "time" : null,
         "limit" : null
       },
       "desc" : "游客模式时间到"
     }
     }
     */
    // 检查防沉迷
    [LKAuthApi checkAntiAddictionWithComplete:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        if (error == nil) {
            NSDictionary *data = result[@"data"];
            NSNumber *success = result[@"success"];
            NSNumber *codeServer = result[@"code"];
            NSString *desc = result[@"desc"];
            NSError *err  = nil;
            int code = -1;
            if (codeServer.exceptNull != nil) {
                code = [codeServer intValue];
            }
            if ([success boolValue] == YES) {
                NSNumber *time = data[@"time"];
                NSNumber *ok = data[@"ok"];
                if ([ok boolValue] == YES) { // 成年
                    
                }else{// 未成年
                    err = [self responserErrorMsg:desc code:code];
                    NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:time,@"time" ,nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEPLAYTIMEEXPIRE" object:err userInfo:userinfo];
                }
                
            }else{
                // 2234 游客模式时间到 提示去实名
                // 2235 未成年模式休息时间  禁止游戏
                // 2236 未成年模式游玩是游戏时间到 禁止游戏
                // 2101 用户不存在
                err = [self responserErrorMsg:desc code:code];
                  if (code == 2234) {
                      
                      err = [self responserErrorMsg:desc code:code];
                      
                      if (data != nil) {
                          NSString *userId = data[@"user_id"];
                          NSString *real_verify = [NSString stringWithFormat:@"%@",data[@"real_verify"]];
                          if ([userId isEqualToString:[LKUserEntity shared].user.userId]) {
                              if (real_verify.exceptNull != nil) {
                                  if (real_verify.exceptNull != nil) {
                                      [LKUserEntity shared].user.real_verify = real_verify;
                                  }
                                  if ([real_verify isEqualToString:@"0"]) {
                                      
                                      [LKUserEntity shared].user.real_name = @"";
                                      [LKUserEntity shared].user.id_card = @"";
                                      // 更新用户信息
                                      [LKUser setUser:[LKUserEntity shared].user];
                                      
                                  }
                              }
                          }
                      }
                      
                      

                  }else if(code == 2235 ) { // 固定点不可玩
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEFORBIDPLAYGAME" object:err userInfo:nil];
                  }else if(code == 2236 ) { // 累计时间超出不可玩
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEPLAYTIMEEXPIRE" object:err userInfo:nil];
                  } else if (code == 2101 ) { // token 失效
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"TOKENINVALID" object:nil];
                  }
            }
            
        }else{
            // 网络错误
        }
        
    }];
    
}

- (NSError *)responserErrorMsg:(NSString *)msg code:(int)code{
    if (msg.exceptNull == nil) {
        msg = @"系统错误";
    }
    NSString *domain = @"com.linking.sdk.ErrorDomain";
        NSString *errorDesc = NSLocalizedString(msg, @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDesc };
        NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    return error;
}

@end

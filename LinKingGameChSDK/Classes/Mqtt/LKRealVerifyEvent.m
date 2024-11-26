//
//  LKRealVerifyEvent.m
//  LinKingSDK
//
//  Created by leon on 2021/5/18.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKRealVerifyEvent.h"
#import "LKRealNameVerifyFactory.h"
#import "NSObject+LKUserDefined.h"
#import "LKAuthApi.h"
#import "LKUser.h"
#import "LKLog.h"
#import "LKUserEntity.h"
#import "LKAntiAddictionEvent.h"
static LKRealVerifyEvent *_instance = nil;
@interface LKRealVerifyEvent ()
@property (nonatomic,copy) NSString *realVerify;
@end

/// 实名认证验证
@implementation LKRealVerifyEvent


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKRealVerifyEvent alloc] init];
    });
    return _instance;
}

- (NSString *)getTopicEvent{
    return @"real_verify";
}

/**
 
 TODO:消息可能被接收多次,需要进行保护处理
 {
     data =     {
         code = 2234;
         data =         {
             ok = 0;
             realVerify = 0;
             userId = 1397135675901890560;
         };
         desc = "\U6e38\U5ba2\U6a21\U5f0f\U65f6\U95f4\U5230";
         success = 0;
     };
     event = "real_verify";
     "real_verify" = 0; // 1 关闭防沉迷校验  2认证队列中的玩家认为已完成实名认证状态  3认证队列中的完成认为未实名状态(国家要求)
     "user_id" = 1397135675901890560;
 }

 */
- (void)receivedMessage:(NSDictionary * _Nonnull)message onTopic:(NSString * _Nullable)topic retained:(BOOL)retained{
    
    [super receivedMessage:message onTopic:topic retained:retained];
    LKLogInfo(@"===SATRT接收到实名迷消息通知===");
    LKLogInfo(@"message = %@",message);
    LKLogInfo(@"===END接收到实名迷消息通知===");
    LKLogInfo(@"real_verify = %@",[NSString stringWithFormat:@"%@",message[@"real_verify"]]);
    
    NSString *realVerify = [NSString stringWithFormat:@"%@",message[@"real_verify"]];
    NSString *userId = [NSString stringWithFormat:@"%@", message[@"user_id"]];
    NSDictionary *data =  message[@"data"];
    NSString *desc = [NSString stringWithFormat:@"%@", data[@"desc"]];
    NSString *codeString = [NSString stringWithFormat:@"%@", data[@"code"]];
    
    LKLogInfo(@"desc = %@",desc);
    LKLogInfo(@"codeString = %@",codeString);

    int code = -1;
    if (codeString.exceptNull != nil) {
        code = [codeString intValue];
    }
    self.realVerify = realVerify;
   
    // 处理加工消息
    [self processMessage:realVerify userId:userId withCode:code];
    
}

/**
 "success":true,"code":null,"desc":null,"data":{"age":"-1","user_id":"1397483273613901824","id_card":null,"real_name":null,"real_verify":0,"under_age_limit":1}}
 */
- (void)processMessage:(NSString *)realVerify userId:(NSString *)userId withCode:(int)code{
    if (realVerify.exceptNull != nil) {
        if (self.realVerifyEventHandler) {
            self.realVerifyEventHandler(realVerify);
        }
      
        LKLogInfo(@"开始请求real_name_info");
        
        // 校验更新实名认证信息
        [LKAuthApi checkRealNameInfoWithComplete:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
            // 重置标记值，单例会知道下次值不会发送改变
            self.realVerify = nil;
            if (error == nil) {
                NSNumber *success = result[@"success"];
                NSDictionary *data = result[@"data"];
                if ([success boolValue] == YES){ // 请求成功
                    NSString *realName = data[@"real_name"];
                    NSString *idCard = data[@"id_card"];
                    NSString *age = data[@"age"];
                    NSString *userId = data[@"user_id"];
                    NSString *real_verify = [NSString stringWithFormat:@"%@",data[@"real_verify"]];
                    if (userId.exceptNull != nil) {
                        
                        if ([userId isEqualToString:[LKUserEntity shared].user.userId]) {
                            if (real_verify.exceptNull != nil) {
                                // 更新实名状态
//                                [[LKRealNameVerifyFactory createRealNameVerify] saveUserRealVerifyState:real_verify];
                                
                                if (real_verify.exceptNull != nil) {
                                    [LKUserEntity shared].user.real_verify = real_verify;
                                }
                                
                                if ([real_verify isEqualToString:@"0"]) { // 校验失败
                                    
                                    if ([LKAntiAddictionEvent shared].code == 2234) {
                                        // 
                                        [LKAntiAddictionEvent shared].code = 0;
                                        LKLogInfo(@"===实名认证失败，再次弹起===");
                                        // 2234 游客时间到需要提示实名认证 无关闭按钮 需要提示 认证失败
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthentication" object:[self responserErrorMsg:@"认证失败" code:2234]];
                                        });
                                    }else{
                                        LKLogInfo(@"===实名认证失败，再次弹起===");
                                        // 其他主动认证，有关闭按钮
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthentication" object:[self responserErrorMsg:@"认证失败" code:-113]];
                                        });
                                    }
                                    
                                  
                                    [LKUserEntity shared].user.real_name = @"";
                                    [LKUserEntity shared].user.id_card = @"";
                                }if ([real_verify isEqualToString:@"2"]) { // 校验成功
                            
                                    if (realName.exceptNull != nil) {
                                        [LKUserEntity shared].user.real_name = realName;
                                    }
                                    
                                    if (idCard.exceptNull != nil) {
                                        [LKUserEntity shared].user.id_card = idCard;
                                    }
                                  
                                    if (age.exceptNull != nil) {
                                        [LKUserEntity shared].user.age = age;
                                    }
                                    
                                }else{
                                    LKLogInfo(@"===实名认证中===");
                                }

                            }else{
                                [[LKRealNameVerifyFactory createRealNameVerify] saveUserRealVerifyState:realVerify];
                            }
                          
                            LKLogInfo(@"保存到本地=====%@",realVerify);
                            // 再次保存到本地
                            [LKUser setUser:[LKUserEntity shared].user];
                            
                        }else{
                            LKLogVerbose(@"用户id不一致");
                        }
                        
                    }else{
                        LKLogVerbose(@"用户id为空");
                    }
                }else{
                    if (code == 2234) { // 游客时间到
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"VISITORPLAYTIMEEXPIRE" object:error userInfo:nil];
                    }
                }
            }else{ // 网络错误
                LKLogVerbose(@"网络错误");
            }
            
            
        }];
        
    }else{
        LKLogInfo(@"参数为空=====%@",realVerify);
    }
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



#import "LKAlterLoginApi.h"
#import "LKNetWork.h"
#import "LKUser.h"
#import "LKUserEntity.h"
#import "LKLog.h"
#import "LKTaptapUpload.h"
#import "NSObject+LKUserDefined.h"
@implementation LKAlterLoginApi


/// 获取验证码
/// @param phone <#phone description#>
/// @param complete <#complete description#>
+ (void)fetchCheckCodeByPhone:(NSString *)phone isNewUserComplete:(void(^)(BOOL isNewUser,NSError *error))complete{
    
     NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"login/phone_login_code"];
    
     NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
     
    [parameters setObject:phone forKey:@"phone"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
//    [headers setObject:[LELanguage instance].preferredLanguage forKey:@"LK_LANGUAGE"];
    [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

        NSNumber *success = responseObject[@"success"];
        NSString *desc = responseObject[@"desc"];
         NSString *errorCode = responseObject[@"code"];
        if ([success boolValue] == YES) {
            NSNumber *data = responseObject[@"data"];
            // data = false 老用户 data = true 新用户
            if ([data boolValue] == NO) {
                if (complete) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete(YES,nil);
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(NO,nil);
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
               complete(NO,[self responserErrorMsg:desc code:[errorCode intValue]]);
            });
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(NO,error);
        });
    }];
    
    return;
}

/// 获取验证码
/// @param phone <#phone description#>
/// @param complete <#complete description#>
+ (void)fetchCheckCodeBindingByPhone:(NSString *)phone complete:(void(^)(NSError *error))complete{
    
     NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"login/phone_binding_code"];
    
     NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
     
    [parameters setObject:phone forKey:@"phone"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
//    [headers setObject:[LELanguage instance].preferredLanguage forKey:@"LK_LANGUAGE"];
    [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

        NSNumber *success = responseObject[@"success"];
        NSString *desc = responseObject[@"desc"];
         NSString *errorCode = responseObject[@"code"];
        if ([success boolValue] == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
               complete([self responserErrorMsg:desc code:[errorCode intValue]]);
            });
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(error);
        });
    }];
    
    return;
}


/// 手机号码
/// @param iphone <#iphone description#>
/// @param code <#code description#>
/// @param password <#password description#>
/// @param complete <#complete description#>
+ (void)loginWithIphone:(NSString *)iphone checkCode:(NSString *)code password:(NSString *)password complete:(void(^)(NSError *error))complete{

         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"login/phone_login"];
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
         [parameters setObject:iphone forKey:@"phone"];
         [parameters setObject:code forKey:@"code"];
         if (password != nil) {
          [parameters setObject:password forKey:@"pwd"];
         }
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            NSDictionary *data = responseObject[@"data"];
            NSString *errorCode = responseObject[@"code"];
            if ([success boolValue] == YES) {
                LKUser *user = [[LKUser alloc] initWithDictionary:data[@"user"]];
                if (user != nil) {
                    // 将用户信息存储到本地
                    if (password != nil) {
                        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"USERPASSWORD"];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:iphone forKey:@"USERPHONE"];
                    [LKUser setUser:user];
                    [LKTaptapUpload uploadLoginTaptapType:@"" complete:nil];
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                      if (complete) {
                          complete(nil);
                      }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete([self responserErrorMsg:desc code:[errorCode intValue]]);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error);
            });
        }];
    
}


/// 快速登录
/// @param complete <#complete description#>
+ (void)quickLoginComplete:(void(^)(NSError *error))complete{

         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"login/direct_login"];
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
      
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
             NSNumber *success = responseObject[@"success"];
             NSString *desc = responseObject[@"desc"];
             NSString *code = responseObject[@"code"];
             NSDictionary *data = responseObject[@"data"];
            if ([success boolValue] == YES) {
                LKUser *user = [[LKUser alloc] initWithDictionary:data[@"user"]];
                if (user != nil) {
                    // 将用户信息存储到本地
                    [LKUser setUser:user];
                    [LKTaptapUpload uploadLoginTaptapType:@"" complete:nil];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) {
                        complete(nil);
                    }
                });

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([code intValue] == 2234) {
                        if ([code intValue]) {
                            NSDictionary *data = responseObject[@"data"];
                            if ([data isKindOfClass:[NSDictionary class]]) {
                               NSString *userId = data[@"user_id"];
                               if (userId != nil) {
                                   [LKUserEntity shared].userId = userId;
                               }
                            }
                        }
                    }

                    complete([self responserErrorMsg:desc code:[code intValue]]);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error);
            });
        }];
    
}


/// 苹果登录
/// @param complete <#complete description#>
+ (void)appleLoginWithToken:(NSString *)token Complete:(void(^)(NSError *error))complete{

         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"login/ios_login"];
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
      
        [parameters setObject:token forKey:@"id_token"];
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            NSDictionary *data = responseObject[@"data"];
             NSString *code = responseObject[@"code"];
            if ([success boolValue] == YES) {
                LKUser *user = [[LKUser alloc] initWithDictionary:data[@"user"]];
                if (user != nil) {
                    // 将用户信息存储到本地
                    [LKUser setUser:user];
                    [LKTaptapUpload uploadLoginTaptapType:@"" complete:nil];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) {
                        complete(nil);
                    }
                });

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete([self responserErrorMsg:desc code:[code intValue]]);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error);
            });
        }];
    
}



+ (void)accountLoginWithIphone:(NSString *)iphone withPassword:(NSString *)password Complete:(void(^)(NSError *error))complete{
       NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"login/account_login"];
       NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
    
      [parameters setObject:iphone forKey:@"account"];
      [parameters setObject:password forKey:@"pwd"];
      NSMutableDictionary *headers = [NSMutableDictionary dictionary];
      [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
          NSNumber *success = responseObject[@"success"];
          NSString *desc = responseObject[@"desc"];
          NSDictionary *data = responseObject[@"data"];
           NSString *code = responseObject[@"code"];
          if ([success boolValue] == YES) {
              LKUser *user = [[LKUser alloc] initWithDictionary:data[@"user"]];
              if (user != nil) {
                  // 将用户信息存储到本地
                  [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"USERPASSWORD"];
                  [[NSUserDefaults standardUserDefaults] setObject:iphone forKey:@"USERPHONE"];
                  [LKUser setUser:user];
                  [LKTaptapUpload uploadLoginTaptapType:@"" complete:nil];
              }
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (complete) {
                      complete(nil);
                  }
              });

          }else{
              dispatch_async(dispatch_get_main_queue(), ^{
                  complete([self responserErrorMsg:desc code:[code intValue]]);
              });
          }
      } failure:^(NSError * _Nonnull error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              complete(error);
          });
      }];
}



+ (void)leonLoginWithCode:(NSString *)code Complete:(void(^)(NSError *error))complete{
    NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"login/we_chat_login"];
          NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
       
         [parameters setObject:code forKey:@"code"];
         NSMutableDictionary *headers = [NSMutableDictionary dictionary];
         [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
             NSNumber *success = responseObject[@"success"];
             NSString *desc = responseObject[@"desc"];
             NSString *code = responseObject[@"code"];
             NSDictionary *data = responseObject[@"data"];
             if ([success boolValue] == YES) {
                 LKUser *user = [[LKUser alloc] initWithDictionary:data[@"user"]];
                 if (user != nil) {
                     // 将用户信息存储到本地
                     [LKUser setUser:user];
                     [LKTaptapUpload uploadLoginTaptapType:@"" complete:nil];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (complete) {
                         complete(nil);
                     }
                 });

             }else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     complete([self responserErrorMsg:desc code:[code intValue]]);
                 });
             }
         } failure:^(NSError * _Nonnull error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 complete(error);
             });
         }];
}

+ (void)autoLoginComplete:(void(^)(NSError *error))complete{
    LKUser *userTmp = [LKUser getUser];
    if (userTmp != nil && userTmp.token != nil && userTmp.token.length >0) {
            NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"login/auto_login"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
            NSMutableDictionary *headers = [NSMutableDictionary dictionary];
            [headers setObject:userTmp.token forKey:@"LK_TOKEN"];
            [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
                NSNumber *success = responseObject[@"success"];
                NSString *desc = responseObject[@"desc"];
                NSString *code = responseObject[@"code"];
                NSDictionary *data = responseObject[@"data"];
                 if ([success boolValue] == YES) {
                     LKUser *user = [[LKUser alloc] initWithDictionary:data[@"user"]];
                     if (user != nil) {
                         // 将用户信息存储到本地
                         [LKUser setUser:user];
                         [LKTaptapUpload uploadLoginTaptapType:@"" complete:nil];
                     }
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (complete) {
                             complete(nil);
                         }
                     });

                 }else{
                     dispatch_async(dispatch_get_main_queue(), ^{
                         complete([self responserErrorMsg:desc code:[code intValue]]);
                     });
                 }
             } failure:^(NSError * _Nonnull error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     complete(error);
                 });
             }];
    }else{
        LKLogInfo(@"⚠️用户信息不存在⚠️%s",__func__);
        dispatch_async(dispatch_get_main_queue(), ^{
           complete([self responserErrorMsg:@"用户信息不存在"]);
        });
    }
}



/*
 
 {
   "success" : true,
   "code" : null,
   "data" : {
     "token" : "MTI4NTE0NTIxMTUwMTUwMzU4MTsxNDAuMjA2LjgwLjIyOzE1OTUyODc5MTM7NTA0NDQ7MWZjNDMzMjRlZDlkNWUxNGQ0ZDJiNWI1MDVmN2MwNTg=",
     "user" : {
       "id" : "1285145210678018048",
       "real_name" : null,
       "phone" : "15609631943",
       "age" : "-1",
       "timestamp" : 1595237469761,
       "verify" : "5584d11b26aa534a7d2798ee09f964b9",
       "login_type" : "Phone",
       "ppid" : "1285145210678018048",
       "is_new_user" : true,
       "nick_name" : "",
       "third_id" : "15609631943",
       "head_icon" : "5",
       "token" : "MTI4NTE0NTIxMTUwMTUwMzU4MTsxNDAuMjA2LjgwLjIyOzE1OTUyODc5MTM7NTA0NDQ7MWZjNDMzMjRlZDlkNWUxNGQ0ZDJiNWI1MDVmN2MwNTg=",
       "id_card" : null,
       "create_time" : "20200720173109",
       "gender" : ""
     }
   },
   "desc" : null
 }
 
 **/


/**
 {
 {
     code = "<null>";
     data =     {
         limit = "<null>";
         ok = 1;
         "question_red_dot" = 0;  未认证  1 认证中 2 已认证
         "real_verify" = 0;  0 未认证  1 认证中 2 已认证
         time = "<null>";
         "user_id" = "<null>";
     };
     desc = "<null>";
     success = 1;
 }
 }
 
 */
+ (void)checkUserInfoWithTime:(int)second complete:(void(^)(NSDictionary *result,NSError *error))complete{
    LKUser *user = [LKUser getUser];
    if (user != nil) {

        NSString *url =[NSString stringWithFormat:@"%@%@",[self baseCheckTokenURL],@"user/check_token"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
         
        [parameters setObject:[NSNumber numberWithInt:second] forKey:@"time"];
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        
        if (user.token != nil) {
            [headers setObject:user.token forKey:@"LK_TOKEN"];
        }
        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
             NSString *code = responseObject[@"code"];
            if ([success boolValue] == YES) {
                if (complete) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            complete(responseObject,nil);
                        });
                    }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([code intValue] == 2234) {
                        if ([code intValue]) {
                            NSDictionary *data = responseObject[@"data"];
                            if ([data isKindOfClass:[NSDictionary class]]) {
                               NSString *userId = data[@"user_id"];
                               if (userId != nil) {
                                   [LKUserEntity shared].userId = userId;
                               }
                            }
                        }
                    }
                    
                    complete(responseObject,[self responserErrorMsg:desc code:[code intValue]]);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil,error);
            });
        }];
    }else{
//        LKLogInfo(@"用户信息不存在,无法轮询");
    }

    
    
}

+ (void)closeUserInfoWithId:(NSString *)userid complete:(void(^)(NSDictionary *result,NSError *error))complete{
    LKUser *user = [LKUser getUser];
    if (user != nil) {
        NSString *url =[NSString stringWithFormat:@"%@%@",[self baseCheckTokenURL],@"user/close"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
        
        [parameters setObject:user.userId forKey:@"user_id"];
        
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        
        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
             NSString *code = responseObject[@"code"];
            if ([success boolValue] == YES) {
                if (complete) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            complete(responseObject,nil);
                        });
                    }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(responseObject,[self responserErrorMsg:desc code:[code intValue]]);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil,error);
            });
        }];
    }else{
        LKLogInfo(@"用户信息不存在,无法注销");
    }
}



@end

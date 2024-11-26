
#import "LKAuthApi.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import "LKUserEntity.h"
#import "NSObject+LKUserDefined.h"
#import "LKPointApi.h"
#import "LKRealNameVerifyFactory.h"
@implementation LKAuthApi
+ (void)authWithName:(NSString *)name IdNumber:(NSString *)number complete:(void(^)(NSDictionary *result,NSError *error))complete{

         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/verify/real_name"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
         
        [parameters setObject:name forKey:@"name"];
        [parameters setObject:number forKey:@"id_card"];
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
    
         LKUser *user = [LKUser getUser];
    
        if ([LKUserEntity shared].userId.exceptNull != nil) {
            [parameters setObject:[LKUserEntity shared].userId forKey:@"user_id"];
        }else{
            if (user.token.exceptNull != nil) {
                [headers setObject:user.token forKey:@"LK_TOKEN"];
            }
            if (user.token.exceptNull == nil) {
                [self logPointUserInfoIsEmptyWithToken:user.token];
            }
        }

        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

            if (complete) {
                complete(responseObject,nil);
            }
        } failure:^(NSError * _Nonnull error) {
            
            if (complete) {
                complete(nil,error);
            }
        }];
}


+ (void)checkRealNameInfoWithComplete:(void(^)(NSDictionary *result,NSError *error))complete{
      NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/real_name_info"];
     
      NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
      
     NSMutableDictionary *headers = [NSMutableDictionary dictionary];
     LKUser *user = [LKUser getUser];
      [headers setObject:user.token forKey:@"LK_TOKEN"];
     [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

         if (complete) {
             complete(responseObject,nil);
        }
     } failure:^(NSError * _Nonnull error) {
         if (complete) {
             complete(nil,error);
         }
     }];
     
  
    
    
}



/// 防沉迷检查
/// @param complete complete description
+ (void)checkAntiAddictionWithComplete:(void(^)(NSDictionary *result,NSError *error))complete{
    NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/check_anti_addiction"];
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
    
   NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    LKUser *user = [LKUser getUser];
    if (user != nil && user.exceptNull != nil) {
        [headers setObject:user.token forKey:@"LK_TOKEN"];
       [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

           /*
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
            **/
           if (complete) {
               complete(responseObject,nil);
          }
       } failure:^(NSError * _Nonnull error) {
           if (complete) {
               complete(nil,error);
           }
       }];
    }
    

  
   
}



+ (void)checkSessionTokenWithComplete:(void(^)(NSDictionary *result,NSError *error))complete{
    NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/check_session_token"];
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
    
   NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    LKUser *user = [LKUser getUser];
    if (user != nil && user.exceptNull != nil) {
        
         [headers setObject:user.token forKey:@"LK_TOKEN"];
        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
            if (complete) {
                complete(responseObject,nil);
           }
        } failure:^(NSError * _Nonnull error) {
            if (complete) {
                complete(nil,error);
            }
        }];
    }
   
   
}




+ (void)logPointUserInfoIsEmptyWithToken:(NSString *)token{
    
    if (token.exceptNull == nil) {
        token = @"";
    }
    NSDictionary *orderInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               token,@"token",
                               nil];
    NSMutableDictionary *result = [LKPointApi getReportLogInfo];
    [result addEntriesFromDictionary:orderInfo];
    [LKPointApi logReportServerWithEvent:@"USER_INFO_EMPTY" eventName:@"用户信息为空" infos:result complete:^(NSError * _Nullable error) {
            
    }];
}

@end

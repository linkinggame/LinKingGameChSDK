

#import "LKPasswordApi.h"
#import "LKNetWork.h"
#import "LKUser.h"
@implementation LKPasswordApi


+ (void)fetchRestPwdCheckCodeByPhone:(NSString *)phone isNewUserComplete:(void(^)(NSError *error))complete{

         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/rs/pwd_code"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
         
        [parameters setObject:phone forKey:@"phone"];
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];

        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            if ([success boolValue] == YES) {
                //NSNumber *data = responseObject[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                      complete(nil);
                  });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete([self responserErrorMsg:desc]);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error);
            });
        }];
    
    
}

+ (void)resetPasswordWithIphone:(NSString *)iphone code:(NSString *)code newPassword:(NSString *)nPwd surePassword:(NSString *)sPwd complete:(void(^)(NSError *error))complete{
    
     NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/rs/pwd"];
    
     NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
     
     [parameters setObject:iphone forKey:@"phone"];
     [parameters setObject:code forKey:@"code"];
     [parameters setObject:nPwd forKey:@"pwd"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
 
    LKUser *user = [LKUser getUser];
    if (user != nil) {
        [headers setObject:user.token forKey:@"LK_TOKEN"];
    }

    [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

        NSNumber *success = responseObject[@"success"];
        NSString *desc = responseObject[@"desc"];
        if ([success boolValue] == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                  complete(nil);
              });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete([self responserErrorMsg:desc]);
            });
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(error);
        });
    }];
    
}
+ (void)fixPasswordWithOldPassword:(NSString *)oldPwd newPassword:(NSString *)newPwd complete:(void(^)(NSError *error))complete{
    
     NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/c/pwd"];
    
     NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
     
     [parameters setObject:oldPwd forKey:@"o_pwd"];
     [parameters setObject:newPwd forKey:@"n_pwd"];
   
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
 
    LKUser *user = [LKUser getUser];
    if (user != nil) {
        [headers setObject:user.token forKey:@"LK_TOKEN"];
    }
    
    [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

        NSNumber *success = responseObject[@"success"];
        NSString *desc = responseObject[@"desc"];
        if ([success boolValue] == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                  complete(nil);
              });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete([self responserErrorMsg:desc]);
            });
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(error);
        });
    }];
    
}


@end

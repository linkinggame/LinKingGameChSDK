

#import "LKOrderApi.h"
#import "LKGlobalConf.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "LKSystem.h"
#import "LKLog.h"
#define SDKConfBaseURL @"http://config.yumengnetwork.com"
#define SDKConfPrefix @"/bgsys/matrix"
@implementation LKOrderApi
+ (void)orderRecordQuery:(NSString *)fullDate month:(NSString *)month complete:(void(^)(NSError *error,NSArray *records))complete{

         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"pay/record_query"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
         
        [parameters setObject:fullDate forKey:@"one_month"];
        [parameters setObject:month forKey:@"month"];
    
       
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
         LKUser *user = [LKUser getUser];
         
         [headers setObject:user.token forKey:@"LK_TOKEN"];

        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            NSDictionary *data = responseObject[@"data"];
            if ([success boolValue] == YES) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (complete) {
                           NSArray *records = data[@"records"];
                           complete(nil,records);
                       }
                   });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete([self responserErrorMsg:desc],nil);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error,nil);
            });
        }];
    
    
}

+ (void)createOrderType:(NSString *)type withParameters:(NSDictionary *)parames complete:(void(^)(NSError *error, NSDictionary*result))complete{
    
       NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"pay/create"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
    
        for (NSString *key in parames.allKeys) {
            
            [parameters setObject:parames[key] forKey:key];
        }
        

    
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
         LKUser *user = [LKUser getUser];
         
         [headers setObject:user.token forKey:@"LK_TOKEN"];

        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id _Nonnull responseObject) {
            if (complete) {
                complete(nil,responseObject);
            }
            
        } failure:^(NSError * _Nonnull error) {
            if (complete) {
                complete(error,nil);
            }
        }];

}

+ (void)appleFinishOrderNum:(NSString *)orderNum receipt:(NSString *)receipt transactionIdentifier:(NSString *)transactionIdentifier subscribe:(BOOL)subscribe complete:(void(^)(NSError *error, NSDictionary*result))complete{
    
         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"pay/finish"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
    
          [parameters setObject:@"ios" forKey:@"type"];
          [parameters setObject:orderNum forKey:@"order_no"];
          [parameters setObject:receipt forKey:@"receipt"];
            if (transactionIdentifier.exceptNull != nil) {
                [parameters setObject:transactionIdentifier forKey:@"client_original_transaction_id"];
            }
          [parameters setObject:[NSNumber numberWithBool:subscribe] forKey:@"subscribe"];
    
         NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
         LKUser *user = [LKUser getUser];
         
        if (user != nil && user.token.exceptNull != nil) {
            [headers setObject:user.token forKey:@"LK_TOKEN"];
        }else{
            LKLogInfo(@"user:%@ ; user.token:%@",user,user.token);
        }

        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {


            
            if (complete) {
                complete(nil,responseObject);
            }
        } failure:^(NSError * _Nonnull error) {
            
            if (complete) {
                complete(error,nil);
            }
        }];
    
    
    
}


+ (void)appleFinishOrderNum:(NSString *)orderNum receipt:(NSString *)receipt subscribe:(BOOL)subscribe complete:(void(^)(NSError *error, NSDictionary*result))complete{
    
         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"pay/finish"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
    
          [parameters setObject:@"ios" forKey:@"type"];
          [parameters setObject:orderNum forKey:@"order_no"];
          [parameters setObject:receipt forKey:@"receipt"];
          [parameters setObject:[NSNumber numberWithBool:subscribe] forKey:@"subscribe"];
//          [parameters setObject:amount forKey:@"amount"];
    
         NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
         LKUser *user = [LKUser getUser];
         
         [headers setObject:user.token forKey:@"LK_TOKEN"];

        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            NSDictionary *data = responseObject[@"data"];
            if ([success boolValue] == YES) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (complete) {
                           NSDictionary *result = data;
                           complete(nil,result);
                       }
                   });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete([self responserErrorMsg:desc],nil);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error,nil);
            });
        }];
    
    
    
}

/// 获取支付配信息
+ (NSString *)getSDKPayConf{
    
     LKSystem *system = [LKSystem getSystem];
      NSString *string  = system.appID;
     if (string == nil) {
        string = [[NSUserDefaults standardUserDefaults] objectForKey:@"SDK_APPID"];
      }
      if ([string rangeOfString:@"_"].length > 0) {
          NSArray *array = [string componentsSeparatedByString:@"_"];
          NSString *appName = array[0];
           NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/json/%@_product.json",SDKConfBaseURL,SDKConfPrefix,appName, system.appID];
           return urlStr;
          
      }
    
    return nil;
}

+ (void)fetchtAppleProductDatasComplete:(void(^)(NSError *error, NSArray*results))complete{
    
    NSString *url = [self getSDKPayConf];
        
    [LKNetWork getWithURLString:url success:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (complete) {
                complete(nil,responseObject);
            }
        }

    } failure:^(NSError * _Nonnull error) {
        if (complete) {
            complete(error,nil);
        }
    }];

}
+ (void)querySubscribeProduct:(NSString *)productId Complete:(void(^)(NSError *error, NSDictionary*results))complete{
    
        
     NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"pay/subscribe_query"];
    
     NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];

      [parameters setObject:@"ios" forKey:@"type"];
      [parameters setObject:productId forKey:@"product_id"];


     NSMutableDictionary *headers = [NSMutableDictionary dictionary];

     LKUser *user = [LKUser getUser];
     
     [headers setObject:user.token forKey:@"LK_TOKEN"];

    [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

        NSNumber *success = responseObject[@"success"];
        NSString *desc = responseObject[@"desc"];
        NSDictionary *data = responseObject[@"data"];
        if ([success boolValue] == YES) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (complete) {
                       NSDictionary *result = data;
                       complete(nil,result);
                   }
               });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete([self responserErrorMsg:desc],nil);
            });
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(error,nil);
        });
    }];

}






@end

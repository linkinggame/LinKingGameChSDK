

#import "LKSDKConfigApi.h"
#import "LKSDKConfig.h"
#import "LKGlobalConf.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import "LKSystem.h"
#import "LKBundleUtil.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "LKLog.h"
#define SDKConfBaseURL  @"http://config.yumengnetwork.com"
#define SDKConfPrefix @"/bgsys/matrix"
@implementation LKSDKConfigApi

/// 获取SDK配置文件
+ (NSString *)getSDKConf{
   LKSystem *system = [LKSystem getSystem];
   NSString *string  = system.appID;
    if ([string rangeOfString:@"_"].length > 0) {
        NSArray *array = [string componentsSeparatedByString:@"_"];
        NSString *appName = array[0];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/json/%@.json",SDKConfBaseURL,SDKConfPrefix,appName, system.appID];
        LKLogInfo(@"config-url:%@",urlStr);
        return urlStr;
    }
    return nil;
}


+ (void)fetchSDKConfigURLWithAppId:(NSString *)appId complete:(void(^_Nullable)(NSString * _Nullable url,NSError *_Nullable error))complete{
    
     NSString *sdkVersion = [LKBundleUtil getSDKVersion];
    if (sdkVersion.exceptNull == nil) {
        sdkVersion = @"1.0.0";
    }
    NSString *url = [NSString stringWithFormat:@"%@?g=%@&v=%@",@"http://appver.yumengnetwork.com/json.php",appId,sdkVersion];
    LKLogInfo("config--url:%@",url);
    
    [LKNetWork getFromPhpithURLString:url success:^(id  _Nonnull responseObject) {
        LKLogInfo("responseObject:%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *configURL = responseObject[@"url"];
            if (configURL.exceptNull != nil) {
                if (complete) {
                    complete(configURL,nil);
                }
            }else{
                NSError *custome_error = [self responserErrorMsg:@"数据为空" code:-1008];
                [self alterTipPhPAppId:appId info:custome_error.localizedDescription code:[NSString stringWithFormat:@"%d",(int)custome_error.code] complete:complete];
            }
        }else{
            NSError *custome_error = [self responserErrorMsg:@"数据解析失败" code:-1007];
            [self alterTipPhPAppId:appId info:custome_error.localizedDescription code:[NSString stringWithFormat:@"%d",(int)custome_error.code] complete:complete];
        }
        
    } failure:^(NSError * _Nonnull error) {
        static int phpcount = 1;
        if (phpcount <= 3 && phpcount > 0) {
            LKLogError(@"php重试次数:%d",phpcount);
            [self fetchSDKConfigURLWithAppId:appId complete:complete];
            phpcount += 1;
        }else{
            phpcount = 1;
            complete(nil,error);
            
            NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
            
            [self alterTipPhPAppId:appId info:error.localizedDescription code:code complete:complete];
        }
    }];
    
}

+ (void)alterTipPhPAppId:(NSString *)appId info:(NSString*)info code:(NSString *)code complete:(void(^_Nullable)(NSString * _Nullable url,NSError *_Nullable error))complete{
    
    NSString *tip = [NSString stringWithFormat:@"%@(%@)，请重试",info,code];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"温馨提示" message:tip preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self fetchSDKConfigURLWithAppId:appId complete:complete];

        }];
        [alertControler addAction:confimAction];
      
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControler animated:YES completion:^{
            
        }];
    });
    

}


+ (void)fetchSDKConfigWithURL:(NSString *)url complete:(void(^_Nullable)(NSError *_Nullable error))complete{
    
    [LKNetWork getWithURLString:url success:^(id  _Nonnull responseObject) {

        LKSDKConfig *sdkConfig = [[LKSDKConfig alloc] initWithDictionary:responseObject];
        [LKSDKConfig setSDKConfig:sdkConfig];
        if (complete) {
            complete(nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
        static int count = 1;
        if (count <= 3 && count > 0) {
            LKLogError(@"重试次数:%d",count);
            [self fetchSDKConfigWithURL:url complete:complete];
            count += 1;
        }else{
            count = 1;
            complete(error);
            
            NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
            
            [self alterTipURL:url info:error.localizedDescription code:code complete:complete];
        }
    }];
}
+ (void)alterTipURL:(NSString *)url info:(NSString*)info code:(NSString *)code complete:(void(^_Nullable)(NSError *_Nullable error))complete{
    
    NSString *tip = [NSString stringWithFormat:@"%@(%@)，请重试",info,code];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"温馨提示" message:tip preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self fetchSDKConfigWithURL:url complete:complete];

        }];
        [alertControler addAction:confimAction];
      
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControler animated:YES completion:^{
            
        }];
    });
    

}




+ (void)fetchSDKConfigAppId:(NSString *)appId complete:(void(^_Nullable)(NSError *_Nullable error))complete{
    
    NSString *url = [self getSDKConf];
    if (url == nil) {
        if ([appId rangeOfString:@"_"].length > 0) {
            NSArray *array = [appId componentsSeparatedByString:@"_"];
            NSString *appName = array[0];
            url = [NSString stringWithFormat:@"%@%@/%@/json/%@.json",SDKConfBaseURL,SDKConfPrefix,appName, appId];
        }
    }
   
    LKLogInfo(@"request sdk config url:%@",url);

    [LKNetWork getWithURLString:url success:^(id  _Nonnull responseObject) {

        LKSDKConfig *sdkConfig = [[LKSDKConfig alloc] initWithDictionary:responseObject];
        [LKSDKConfig setSDKConfig:sdkConfig];
        if (complete) {
            complete(nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
        static int count = 1;
        if (count <= 3 && count > 0) {
            LKLogInfo(@"重试次数:%d",count);
            [self fetchSDKConfigAppId:appId complete:complete];
            count += 1;
        }else{
            count = 1;
            complete(error);
            
            NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
            
            [self alterTipAppId:appId info:error.localizedDescription code:code complete:complete];
        }
    }];
}



+ (void)fetchSDKConfigComplete:(void(^_Nullable)(NSError *_Nullable error))complete{
    
    NSString *url = [self getSDKConf];

    [LKNetWork getWithURLString:url success:^(id  _Nonnull responseObject) {

        LKSDKConfig *sdkConfig = [[LKSDKConfig alloc] initWithDictionary:responseObject];
        [LKSDKConfig setSDKConfig:sdkConfig];
        if (complete) {
            complete(nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
        static int count = 1;
        if (count <= 3 && count > 0) {
            LKLogInfo(@"重试次数:%d",count);
            [self fetchSDKConfigComplete:complete];
            count += 1;
        }else{
            count = 1;
            complete(error);
            
            NSString *code = [NSString stringWithFormat:@"%ld",(long)error.code];
            
            [self alterTipInfo:error.localizedDescription code:code complete:complete];
        }
    }];
}

+ (void)alterTipAppId:(NSString *)appId info:(NSString*)info code:(NSString *)code complete:(void(^_Nullable)(NSError *_Nullable error))complete{
    
    NSString *tip = [NSString stringWithFormat:@"%@(%@)。",info,code];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"温馨提示" message:tip preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self fetchSDKConfigAppId:appId complete:complete];

        }];
        [alertControler addAction:confimAction];
      
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControler animated:YES completion:^{
            
        }];
    });
    

}

+ (void)alterTipInfo:(NSString*)info code:(NSString *)code complete:(void(^_Nullable)(NSError *_Nullable error))complete{
    
    NSString *tip = [NSString stringWithFormat:@"%@(%@)。",info,code];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"温馨提示" message:tip preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self fetchSDKConfigComplete:complete];

        }];
        [alertControler addAction:confimAction];
      
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControler animated:YES completion:^{
            
        }];
    });
    

}

/**
 {
     code = "<null>";
     data = "4YxQAmtgaIbn+QIhuaXlAUd/HW4=";
     desc = "<null>";
     success = 1;
 }
 
 */

+ (void)fetchMQTTClientIdKey:(NSString *)clientId WithComplete:(void(^)(NSObject *result,NSError *error))complete{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"config/mqtt_client_id_key"];
    
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
    
    [parameters setObject:clientId forKey:@"clientId"];
    
   NSMutableDictionary *headers = [NSMutableDictionary dictionary];

    LKUser *user = [LKUser getUser];
    
    if (user != nil && user.token.exceptNull != nil) {
        [headers setObject:user.token forKey:@"LK_TOKEN"];

        [LKNetWork postFormDataWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            NSString *data = responseObject[@"data"];
            if ([success boolValue] == YES) {
                if (complete) {
                    complete(data,nil);
                    }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(nil,[self responserErrorMsg:desc]);
                });
            }
            } failure:^(NSError * _Nonnull error) {
                if (complete) {
                    complete(nil,error);
                }
        
            }];
    }
    

}

+ (void)fetchMQTTClientIdTokenKeyWithComplete:(void(^)(NSObject *result,NSError *error))complete{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"config/mqtt_client_id_token"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
    
   NSMutableDictionary *headers = [NSMutableDictionary dictionary];

    LKUser *user = [LKUser getUser];
    
    if (user != nil && user.token.exceptNull != nil) {
        [headers setObject:user.token forKey:@"LK_TOKEN"];

        [LKNetWork postNormalWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            NSString *data = responseObject[@"data"];
            if ([success boolValue] == YES) {
                if (complete) {
                    complete(data,nil);
                    }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(nil,[self responserErrorMsg:desc]);
                });
            }
         } failure:^(NSError * _Nullable error) {
             if (complete) {
                 complete(nil,error);
             }
       }];
//        [LKNetWork postFormDataWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {
//            NSNumber *success = responseObject[@"success"];
//            NSString *desc = responseObject[@"desc"];
//            NSString *data = responseObject[@"data"];
//            if ([success boolValue] == YES) {
//                if (complete) {
//                    complete(data,nil);
//                    }
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    complete(nil,[self responserErrorMsg:desc]);
//                });
//            }
//            } failure:^(NSError * _Nonnull error) {
//                if (complete) {
//                    complete(nil,error);
//                }
//
//            }];
    }
    
}



@end

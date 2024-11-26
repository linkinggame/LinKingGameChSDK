

#import "LKPointApi.h"
#import "LKGlobalConf.h"
#import "LKUUID.h"
#import "LKNetUtils.h"
#import "LKSystem.h"
#import "LKSDKConfig.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "LKBundleUtil.h"
#import "LKLog.h"
@implementation LKPointApi

+ (void)pointEventName:(NSString *)eventName withTp:(NSString *)tp withValues:(NSDictionary *)values complete:(void(^)(NSError *error))complete{
   
  
//    if ([self isStartSLS]) {
//
//        LKLogInfo(@"开启SLS日志收集");
//        [self sls_pointEventName:eventName withTp:tp withValues:values complete:complete];
//    }else{
//        LKLogInfo(@"使用平台日志收集");
//
//    }
    
    [self originPointEventName:eventName withTp:tp withValues:values complete:complete];

    
}

+ (void)adPointEventName:(NSString *)eventName withValues:(NSDictionary *)values complete:(void(^)(NSError *error))complete{
   
//    if ([self isStartSLS]) {
//        LKLogInfo(@"ad开启SLS日志收集");
//        [self sls_adPointEventName:eventName withValues:values complete:complete];
//    }else{
//        LKLogInfo(@"ad使用平台日志收集");
//
//    }
     
    [self originAdPointEventName:eventName withValues:values complete:complete];

    
}


+ (BOOL)isStartSLS{
    LKSDKConfig *sdkConfig =[LKSDKConfig getSDKConfig];
    
    id object = sdkConfig.point_config[@"lk"];
   
    NSDictionary *lk = (NSDictionary *)object;
    
    NSNumber *sls_enable = lk[@"sls_enable"]; // 是否启用
    LKLogInfo(@"是否开始SLS日志上报==%ld",(long)sls_enable);
    return [sls_enable boolValue];
}

// =============


+ (void)originPointEventName:(NSString *)eventName withTp:(NSString *)tp withValues:(NSDictionary *)values complete:(void(^)(NSError *error))complete{
    LKUser *user = [LKUser getUser];
    
    if ([eventName isEqualToString:@"Activation"] || [eventName isEqualToString:@"StartUp"]) {
        LKLogInfo(@"不校验用户");
    }else{
        LKUser *userTmp = [LKUser getUser];
        if (userTmp == nil) {
            LKLogInfo(@"⚠️用户信息为空⚠️");
            return;
        }
    }
    
    LKSDKConfig *sdkConfig =[LKSDKConfig getSDKConfig];
    
    if (sdkConfig == nil) {
        LKLogInfo(@"⚠️SDK未初始化成功⚠️");
        return;
    }
    
    id object = sdkConfig.point_config[@"lk"];
    if (![object isKindOfClass:[NSDictionary class]]) {
        LKLogInfo(@"⚠️数据格式错误⚠️");
        return;
    }
    
    NSDictionary *lk = (NSDictionary *)object;
    
    NSString *log_base_uri = lk[@"log_base_uri"];
    
   
    if (log_base_uri.exceptNull == nil) {
        LKLogInfo(@"⚠️SDK未初始化成功⚠️");
        return;
    }
     
     NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:values];
     NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
      
    [dictionary setObject:@"ios" forKey:@"channel"];
    [dictionary setObject:@"AppStore" forKey:@"sub_channel"];
    [dictionary setObject:[LKUUID getUUID] forKey:@"device_id"];
    [dictionary setObject:[LKNetUtils deviceInfo] forKey:@"device_info"];
    [dictionary setObject:eventName forKey:@"event"];
    
    [dictionary setObject:[LKBundleUtil getSDKVersion] forKey:@"version"];
    NSString *game_version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [dictionary setObject:game_version forKey:@"game_version"];
    
    LKSystem *system = [LKSystem getSystem];
    [dictionary setObject:system.appID forKey:@"app_id"];
    if (user != nil && user.userId.exceptNull != nil) {
           [dictionary setObject:user.userId forKey:@"user_id"];
    }
    
    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
   if ([localeLanguageCode rangeOfString:@"_"].location != NSNotFound) {
       NSArray *languages = [localeLanguageCode componentsSeparatedByString:@"_"];
       NSString *area = languages.lastObject;
        [dictionary setObject:area forKey:@"country"];
   }

 
    [parameters setObject:@"linking-sdk" forKey:@"ak"];
    [parameters setObject:tp forKey:@"tp"];
    NSString *json = [self dictionaryToJson:dictionary];
    [parameters setObject:json forKey:@"param"];
   
    LKLogInfo(@"========================");
    LKLogInfo(@"===>POINT:%@",parameters);
    LKLogInfo(@"========================");
    [LKNetWork postWithURLString:log_base_uri parameters:parameters success:^(id  _Nonnull responseObject) {
        NSNumber *success = responseObject[@"success"];
        NSString *desc = responseObject[@"desc"];
        LKLogInfo(@"==point:%@==",responseObject);
        if ([success boolValue] == YES) {
            if (complete) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete(nil);
                    });
                }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete([self responserErrorMsg:desc]);
                }
                
            });
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                 complete(error);
            }
           
        });
    }];
}
+ (void)originAdPointEventName:(NSString *)eventName withValues:(NSDictionary *)values complete:(void(^)(NSError *error))complete{
    LKUser *user = [LKUser getUser];
    if (user != nil) {
       
         LKSDKConfig *sdkConfig =[LKSDKConfig getSDKConfig];
         
         if (sdkConfig == nil) {
             LKLogInfo(@"⚠️SDK未初始化成功⚠️");
             return;
         }
         
         id object = sdkConfig.point_config[@"lk"];
         if (![object isKindOfClass:[NSDictionary class]]) {
             LKLogInfo(@"⚠️数据格式错误⚠️");
             return;
         }
         
         NSDictionary *lk = (NSDictionary *)object;
         
         NSString *log_base_uri = lk[@"log_base_uri"];
         
        
         if (log_base_uri.exceptNull == nil) {
             LKLogInfo(@"⚠️SDK未初始化成功⚠️");
             return;
         }

         NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:values];
         NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
          
        [dictionary setObject:@"ios" forKey:@"channel"];
        [dictionary setObject:@"AppStore" forKey:@"sub_channel"];
        [dictionary setObject:[LKUUID getUUID] forKey:@"device_id"];
        [dictionary setObject:[LKNetUtils deviceInfo] forKey:@"device_info"];
        LKSystem *system = [LKSystem getSystem];
        [dictionary setObject:system.appID forKey:@"app_id"];
        [dictionary setObject:eventName forKey:@"event"];
        [dictionary setObject:user.userId forKey:@"user_id"];
        
        [dictionary setObject:[LKBundleUtil getSDKVersion] forKey:@"version"];
        NSString *game_version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [dictionary setObject:game_version forKey:@"game_version"];
        
         NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
        if ([localeLanguageCode rangeOfString:@"_"].location != NSNotFound) {
            NSArray *languages = [localeLanguageCode componentsSeparatedByString:@"_"];
            NSString *area = languages.lastObject;
             [dictionary setObject:area forKey:@"country"];
        }
        

        [dictionary setObject:[NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",user.is_new_user] intValue]] forKey:@"is_new"]; // 是否是新用户

        [parameters setObject:@"linking-sdk" forKey:@"ak"];
        [parameters setObject:@"Ad" forKey:@"tp"];
        NSString *json = [self dictionaryToJson:dictionary];
        [parameters setObject:json forKey:@"param"];
        
        
          NSMutableDictionary *headers = [NSMutableDictionary dictionary];
          [headers setObject:user.token forKey:@"LK_TOKEN"];
         [LKNetWork postWithURLString:log_base_uri parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

             NSNumber *success = responseObject[@"success"];
             NSString *desc = responseObject[@"desc"];
             if ([success boolValue] == YES) {
                 if (complete) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             complete(nil);
                         });
                     }
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
    }else{
        LKLogInfo(@"⚠️用户信息为空⚠️");
    }
}

//===============
+ (void)logReportServerWithEvent:(NSString *)event eventName:(NSString *)eventName infos:(NSDictionary *_Nullable)infos WithOtherLogInfo:(NSDictionary*_Nullable)logInfors complete:(void(^_Nullable)(NSError *_Nullable error))complete{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"linking" forKey:@"__topic__"];
    [parameters setValue:@"sdk" forKey:@"__source__"];
    
    NSMutableArray *logArray = [NSMutableArray array];
    if (logInfors != nil) {
        // 转换成json字符串、
       NSString *jsonString = [self dictionaryToJson:logInfors];
        NSDictionary *content = [NSDictionary dictionaryWithObjectsAndKeys:jsonString,@"conctent", nil];
        [logArray addObject:content];
    }else{
        NSDictionary *content = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"conctent", nil];
        [logArray addObject:content];
    }
   
    [parameters setObject:logArray forKey:@"__logs__"];
    
    NSMutableDictionary *tagsParamters = [NSMutableDictionary dictionaryWithDictionary:infos];
    [tagsParamters setObject:@"linking-sdk" forKey:@"ak"];
    [tagsParamters setObject:event forKey:@"event"];
    [tagsParamters setObject:eventName forKey:@"eventName"];
    // 海外新增country字段
    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
   if ([localeLanguageCode rangeOfString:@"_"].location != NSNotFound) {
       NSArray *languages = [localeLanguageCode componentsSeparatedByString:@"_"];
       NSString *area = languages.lastObject;
        [tagsParamters setObject:area forKey:@"country"];
   }
    
    [parameters setObject:tagsParamters forKey:@"__tags__"];
    
    
    
    NSMutableDictionary *headParamters = [NSMutableDictionary dictionary];
    [headParamters setObject:@"application/json" forKey:@"Content-Type"];
    [headParamters setObject:@"0.6.0" forKey:@"x-log-apiversion"];
    [headParamters setObject:@"1234" forKey:@"x-log-bodyrawsize"];
    
    
    LKLogInfo(@"report-log-info:%@",parameters);
    
    NSString *reportedLogUR = [LKBundleUtil getReportedLogURL];
    [LKNetWork postNormalWithURLString:reportedLogUR parameters:parameters HTTPHeaderField:headParamters success:^(id  _Nonnull responseObject) {
        LKLogInfo(@"===上报结果成功===");
        } failure:^(NSError * _Nullable error) {
            LKLogInfo(@"===上报结果失败%@===",error);
    }];

}

+ (void)logReportServerWithEvent:(NSString *)event eventName:(NSString *)eventName infos:(NSDictionary *)infos complete:(void(^_Nullable)(NSError *_Nullable error))complete{

    [self logReportServerWithEvent:event eventName:eventName infos:infos WithOtherLogInfo:nil complete:complete];

}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     
}



+ (NSMutableDictionary *)getReportLogInfo{
    LKSystem *system = [LKSystem getSystem];
    LKUser *user = [LKUser getUser];
    NSString *appId = system.appID.exceptNull != nil ? system.appID : @"";
    NSString *userId = user.userId.exceptNull != nil ? user.userId : @"";
    NSString *version = [LKBundleUtil getSDKVersion].exceptNull != nil ? [LKBundleUtil getSDKVersion] : @"";
    NSString *gameVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
     
    NSMutableDictionary *infor = [NSMutableDictionary dictionary];
    [infor setObject:appId forKey:@"appId"];
    [infor setObject:userId forKey:@"userId"];
    [infor setObject:version forKey:@"version"];
    [infor setObject:gameVersion forKey:@"gameVersion"];
    [infor setObject:@"ios" forKey:@"channel"];
    [infor setObject:@"AppStore" forKey:@"subChannel"];
    [infor setObject:[LKUUID getUUID] forKey:@"deviceId"];
    [infor setObject:[LKNetUtils deviceInfo] forKey:@"deviceInfo"];
    return infor;
    
}



/*

// 获取设备当前语言和地区
 NSString *language = [NSLocale preferredLanguages].firstObject;
// 获取设备当前地区
 NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
// 获取设备选择的语言
 NSString *localeLanguageCode_d = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
//获取设备当前语言和地区
NSString *localeLanguageCode_o = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
**/




// =============

+ (void)sls_adPointEventName:(NSString *)eventName withValues:(NSDictionary *)values complete:(void(^)(NSError *error))complete{
    
    LKUser *user = [LKUser getUser];
    if (user != nil) {
             LKSDKConfig *sdkConfig =[LKSDKConfig getSDKConfig];
          
          if (sdkConfig == nil) {
              LKLogInfo(@"⚠️SDK未初始化成功⚠️");
              return;
          }
          
          id object = sdkConfig.point_config[@"lk"];
          if (![object isKindOfClass:[NSDictionary class]]) {
              LKLogInfo(@"⚠️数据格式错误⚠️");
              return;
          }
          
          NSDictionary *lk = (NSDictionary *)object;
          
          NSString *sls_base_uri = lk[@"sls_base_uri"];
          
         
          if (sls_base_uri.exceptNull == nil) {
              LKLogInfo(@"⚠️SDK未初始化成功⚠️");
              return;
          }
        
        // 封装参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"linking" forKey:@"__topic__"];
        [parameters setValue:@"sdk" forKey:@"__source__"];
        
        NSMutableDictionary *logParamters = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryValueCovertStringStyle:values]];
        [logParamters setObject:@"ios" forKey:@"channel"];
        [logParamters setObject:@"AppStore" forKey:@"sub_channel"];
        [logParamters setObject:[LKUUID getUUID] forKey:@"device_id"];
        [logParamters setObject:[LKNetUtils deviceInfo] forKey:@"device_info"];
        LKSystem *system = [LKSystem getSystem];
        [logParamters setObject:system.appID forKey:@"app_id"];
        [logParamters setObject:eventName forKey:@"event"];
        [logParamters setObject:user.userId forKey:@"user_id"];
        [logParamters setObject:[LKBundleUtil getSDKVersion] forKey:@"version"];
        NSString *game_version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [logParamters setObject:game_version forKey:@"game_version"];
        [logParamters setObject:[NSString stringWithFormat:@"%@",user.is_new_user] forKey:@"is_new"]; // 是否是新用户

        // 海外新增country字段
        NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
       if ([localeLanguageCode rangeOfString:@"_"].location != NSNotFound) {
           NSArray *languages = [localeLanguageCode componentsSeparatedByString:@"_"];
           NSString *area = languages.lastObject;
            [logParamters setObject:area forKey:@"country"];
       }

        
        
        NSMutableArray *logArray = [NSMutableArray array];
        [logArray addObject:logParamters];
       
        [parameters setObject:logArray forKey:@"__logs__"];
        
        
        NSMutableDictionary *tagsParamters = [NSMutableDictionary dictionary];
        [tagsParamters setObject:@"linking-sdk" forKey:@"ak"];
        [tagsParamters setObject:@"ad" forKey:@"tp"];
        [tagsParamters setObject:game_version forKey:@"game_version"]; //游戏版本
    
        [parameters setObject:tagsParamters forKey:@"__tags__"];
     
        
        
       // 封装请求头
        NSMutableDictionary *headParamters = [NSMutableDictionary dictionary];
        [headParamters setObject:@"application/json" forKey:@"Content-Type"];
        [headParamters setObject:@"0.6.0" forKey:@"x-log-apiversion"];
        [headParamters setObject:@"1234" forKey:@"x-log-bodyrawsize"];
      
        
        LKLogInfo(@"parameters:===>%@",parameters);
        [LKNetWork postNormalWithURLString:sls_base_uri parameters:parameters HTTPHeaderField:headParamters success:^(id  _Nonnull responseObject){
             LKLogInfo(@"===SLS日志打点===");
            if (complete) {
                complete(nil);
            }
        } failure:^(NSError * _Nullable error) {
            if (complete) {
                complete(error);
            }
        }];
        
        
    }else{
        LKLogInfo(@"用户信息为空");
    }
    
    
}

+ (void)sls_pointEventName:(NSString *)eventName withTp:(NSString *)tp withValues:(NSDictionary *)values complete:(void(^)(NSError *error))complete{
    LKUser *user = [LKUser getUser];
    if ([eventName isEqualToString:@"Activation"] || [eventName isEqualToString:@"StartUp"]) {
        LKLogInfo(@"不校验用户");
    }else{
        LKUser *userTmp = [LKUser getUser];
        if (userTmp == nil) {
            LKLogInfo(@"⚠️用户信息为空⚠️");
            return;
        }
    }

    
    LKSDKConfig *sdkConfig =[LKSDKConfig getSDKConfig];
    
    if (sdkConfig == nil) {
        LKLogInfo(@"⚠️SDK未初始化成功⚠️");
        return;
    }
    
    id object = sdkConfig.point_config[@"lk"];
    if (![object isKindOfClass:[NSDictionary class]]) {
        LKLogInfo(@"⚠️数据格式错误⚠️");
        return;
    }
    
    NSDictionary *lk = (NSDictionary *)object;
    
    NSString *sls_base_uri = lk[@"sls_base_uri"];
    
   
    if (sls_base_uri.exceptNull == nil) {
        LKLogInfo(@"⚠️SDK未初始化成功⚠️");
        return;
    }
    
    
    // 封装参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"linking" forKey:@"__topic__"];
    [parameters setValue:@"sdk" forKey:@"__source__"];
    
    NSMutableDictionary *logParamters = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryValueCovertStringStyle:values]];
    [logParamters setObject:@"ios" forKey:@"channel"];
    [logParamters setObject:@"AppStore" forKey:@"sub_channel"];
    [logParamters setObject:[LKUUID getUUID] forKey:@"device_id"];
    [logParamters setObject:[LKNetUtils deviceInfo] forKey:@"device_info"];
    [logParamters setObject:eventName forKey:@"event"];
    LKSystem *system = [LKSystem getSystem];
    
    [logParamters setObject:system.appID forKey:@"app_id"];
    if (user != nil && user.userId.exceptNull != nil) {
           [logParamters setObject:user.userId forKey:@"user_id"];
    }
    [logParamters setObject:[LKBundleUtil getSDKVersion] forKey:@"version"];
    NSString *game_version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [logParamters setObject:game_version forKey:@"game_version"];
    // 海外新增country字段
    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
   if ([localeLanguageCode rangeOfString:@"_"].location != NSNotFound) {
       NSArray *languages = [localeLanguageCode componentsSeparatedByString:@"_"];
       NSString *area = languages.lastObject;
        [logParamters setObject:area forKey:@"country"];
   }

    
    NSMutableArray *logArray = [NSMutableArray array];
    [logArray addObject:logParamters];
   
    [parameters setObject:logArray forKey:@"__logs__"];
    
    NSMutableDictionary *tagsParamters = [NSMutableDictionary dictionary];
    [tagsParamters setObject:@"linking-sdk" forKey:@"ak"];
    [tagsParamters setObject:tp forKey:@"tp"];
    [tagsParamters setObject:game_version forKey:@"game_version"]; //游戏版本

    [parameters setObject:tagsParamters forKey:@"__tags__"];
 
    
   // 封装请求头
    NSMutableDictionary *headParamters = [NSMutableDictionary dictionary];
    [headParamters setObject:@"0.6.0" forKey:@"x-log-apiversion"];
    [headParamters setObject:@"1234" forKey:@"x-log-bodyrawsize"];
    
    
    
    LKLogInfo(@"parameters:===>%@",parameters);
    [LKNetWork postNormalWithURLString:sls_base_uri parameters:parameters HTTPHeaderField:headParamters success:^(id  _Nonnull responseObject){
         LKLogInfo(@"===SLS日志打点===");
        if (complete) {
            complete(nil);
        }
    } failure:^(NSError * _Nullable error) {
        if (complete) {
            complete(error);
        }
    }];

    
    
}


+ (NSDictionary *)dictionaryValueCovertStringStyle:(NSDictionary *)dict{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *key in dict.allKeys) {
        NSString *val = [NSString stringWithFormat:@"%@",dict[key]];
        [result setObject:val forKey:key];
        
    }
    return  result;
    
}



@end

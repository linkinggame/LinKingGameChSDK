
#import "LKBaseApi.h"
#import "LKUUID.h"
#import "LKNetUtils.h"
#import "LKSystem.h"
#import "LKGlobalConf.h"
#import "LKSDKConfig.h"
#import <AdSupport/AdSupport.h>
#import "NSObject+LKUserDefined.h"
#import "LKBundleUtil.h"
#import "LKLog.h"
@implementation LKBaseApi

+ (NSString *)baseURL{
      LKSDKConfig *configSDK = [LKSDKConfig getSDKConfig];
    if (configSDK != nil) {
           NSString *base_ser_url = configSDK.auth_config[@"base_ser_url"];
           LKSystem *system =  [LKSystem getSystem];
           if (system != nil && system.appID != nil) {
               NSString *base = [NSString stringWithFormat:@"%@%@/",base_ser_url,system.appID];
               return base;
           }else{
                NSString *appId = [[NSUserDefaults standardUserDefaults] objectForKey:@"SDK_APPID"];
                if (appId != nil) {
                    NSString *base = [NSString stringWithFormat:@"%@%@/",base_ser_url,appId];
                    return base;
                }else{
                    LKLogInfo(@"⚠️appID不能为空⚠️");
                }
           }
    }else{
        LKLogInfo(@"⚠️SDK未初始化成功⚠️");
    }
     
    
    return nil;
    
}

+ (NSString *)baseCheckTokenURL{
      LKSDKConfig *configSDK = [LKSDKConfig getSDKConfig];
    if (configSDK != nil) {
           NSString *check_token_url = configSDK.auth_config[@"check_token_url"];
          if (check_token_url.exceptNull == nil) {
             check_token_url = configSDK.auth_config[@"base_ser_url"];
          }
           NSString *base_ser_url = check_token_url;
           LKSystem *system =  [LKSystem getSystem];
           if (system != nil && system.appID.exceptNull != nil && base_ser_url.exceptNull != nil) {
               NSString *base = [NSString stringWithFormat:@"%@%@/",base_ser_url,system.appID];
               return base;
           }else{
                NSString *appId = [[NSUserDefaults standardUserDefaults] objectForKey:@"SDK_APPID"];
                if (appId != nil && base_ser_url != nil) {
                    NSString *base = [NSString stringWithFormat:@"%@%@/",base_ser_url,appId];
                    return base;
                }else{
                    LKLogInfo(@"⚠️appID不能为空⚠️");
                }
           }
    }else{
        LKLogInfo(@"⚠️SDK未初始化成功⚠️");
    }
    return nil;
}


+ (NSDictionary *)defaultParames{
       NSMutableDictionary *parames = [NSMutableDictionary dictionary];
       [parames setObject:@"ios" forKey:@"channel"];
       [parames setObject:@"AppStore" forKey:@"sub_channel"];
       [parames setObject:[LKUUID getUUID] forKey:@"device_id"];
       [parames setObject:[LKNetUtils deviceInfo] forKey:@"device_info"];
       // NSString* userPhoneName = [[UIDevice currentDevice] name];  //手机别名： 用户定义的名称
       [parames setObject:@"iOS" forKey:@"os"];//设备名称
       [parames setObject:[LKBundleUtil getSDKVersion] forKey:@"version"];
       NSString *game_version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
       [parames setObject:game_version forKey:@"game_version"]; //游戏版本
       
       // 获取随机字符串
       NSString *randString = [LKNetUtils randomString];
       // 加密类型
       NSString *sign_type = @"MD5";
       
       [parames setObject:sign_type forKey:@"sign_type"];
       [parames setObject:randString forKey:@"nonce_str"];
     
    return parames;
}
+ (NSDictionary *)defaultParamesSimple{
       NSMutableDictionary *parames = [NSMutableDictionary dictionary];
       // 获取随机字符串
       NSString *randString = [LKNetUtils randomString];
       // 加密类型
       NSString *sign_type = @"MD5";
       
       [parames setObject:sign_type forKey:@"sign_type"];
       [parames setObject:randString forKey:@"nonce_str"];
     
    return parames;
}
+ (NSError *)responserErrorMsg:(NSString *)msg{
    if (msg.exceptNull == nil) {
        msg = @"系统错误";
    }
    NSString *domain = @"com.linking.sdk.ErrorDomain";
        NSString *errorDesc = NSLocalizedString(msg, @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDesc };
        NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
    return error;
}
+ (NSError *)responserErrorMsg:(NSString *)msg code:(int)code{
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

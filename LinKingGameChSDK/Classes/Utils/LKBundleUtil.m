//
//  LKBundleUtil.m
//  LinKingSDK
//
//  Created by leon on 2021/5/25.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKBundleUtil.h"
#import "NSObject+LKUserDefined.h"
#import "LKLog.h"
@implementation LKBundleUtil


+ (NSDictionary *)getLinKingBundleInfo{
    NSBundle *bundle =  [NSBundle mainBundle];
    NSURL *bundleURL = [bundle bundleURL];
    NSURL *linkSDKURL = [bundleURL URLByAppendingPathComponent:@"LinKing.plist"];
   
    if (linkSDKURL == nil) {
        LKLogInfo(@"***************************");
        LKLogInfo(@"=====请将配置文件放置项目中=====");
        LKLogInfo(@"***************************");
        return nil;
    }
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfURL:linkSDKURL];
    LKLogInfo(@"info:%@",info);
    return info[@"SDKINFO"];
}

+ (NSString *)getSDKVersion{
    NSDictionary *info = [self getLinKingBundleInfo];
    NSString *game_version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (info == nil) {
        return game_version;
    }
    NSString *version = info[@"VERSION"];
    if (version.exceptNull == nil) {
        version = game_version;
    }
    return version;
}

+ (NSString *)getReportedLogURL{
    NSDictionary *info = [self getLinKingBundleInfo];
    NSString *errorLog = @"http://lk-sdk-error-ch.cn-shanghai.log.aliyuncs.com/logstores/error-log/track";
    if (info == nil) {
        return errorLog;
    }
    NSString *log_url = info[@"LOGURL"];
    if (log_url.exceptNull == nil) {
        log_url =  errorLog;
    }
    return log_url;
}




@end

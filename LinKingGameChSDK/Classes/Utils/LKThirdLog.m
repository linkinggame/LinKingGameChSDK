//
//  LKThirdLog.m
//  LinKingSDK
//
//  Created by leon on 2021/6/3.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKThirdLog.h"
#import <MQTTClient/MQTTClient.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
@implementation LKThirdLog
+ (void)setMQTTLogLevel:(LKMQTTLogLevel)logLevel{
    
    switch (logLevel) {
        case LKMQTTLogLevelOff:
        {
            [MQTTLog setLogLevel:DDLogLevelOff];
            break;
        }
        case LKMQTTLogLevelErro:
        {
            [MQTTLog setLogLevel:DDLogLevelError];
            break;
        }
        case LKMQTTLogLevelWarning:
        {
            [MQTTLog setLogLevel:DDLogLevelWarning];
            break;
        }
        case LKMQTTLogLevelInfo:
        {
            [MQTTLog setLogLevel:DDLogLevelInfo];
            break;
        }
        case LKMQTTLogLevelDebug:
        {
            [MQTTLog setLogLevel:DDLogLevelDebug];
            break;
        }
        case LKMQTTLogLevelVerbose:
        {
            [MQTTLog setLogLevel:DDLogLevelVerbose];
            break;
        }
        case LKMQTTLogLevelALL:
        {
            [MQTTLog setLogLevel:DDLogLevelAll];
            break;
        }
            
        default:
            break;
    }
    
}

+ (void)setAppsFlyerisDebug:(BOOL)isDebug{
    [AppsFlyerLib shared].isDebug = isDebug;
}

+ (void)setDefaultLog{
    [self setMQTTLogLevel:LKMQTTLogLevelDebug];
    [self setAppsFlyerisDebug:YES];
}

+ (void)setThirdLog:(LKThirdLogLevel)level{
    
    if (level == LKThirdLogLevelOn) {
        // 开启 MQTT
        [self setMQTTLogLevel:LKMQTTLogLevelDebug];
        // 开启 AppsFlyer
        [self setAppsFlyerisDebug:YES];
    } else {
        // 关闭MQTT
        [self setMQTTLogLevel:LKMQTTLogLevelOff];
        // 关闭 AppsFlyer
        [self setAppsFlyerisDebug:NO];
    }
}
@end

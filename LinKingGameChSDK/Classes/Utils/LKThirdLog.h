//
//  LKThirdLog.h
//  LinKingSDK
//
//  Created by leon on 2021/6/3.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,LKMQTTLogLevel){
    
    /* 关闭日志 */
    LKMQTTLogLevelOff     = 0,
    
    /* 仅仅是错误日志 */
    LKMQTTLogLevelErro  ,
    
    /* 错误和警告日志 */
    LKMQTTLogLevelWarning   ,
    
    /* 错误和警告，提示 日志 */
    LKMQTTLogLevelInfo  ,
    
    /* 错误和警告，提示 , debug 日志 */
    LKMQTTLogLevelDebug ,
    
    /* 错误和警告，提示 , debug,Verbose 日志 */
    LKMQTTLogLevelVerbose,
    
    /* 所有日志 */
    LKMQTTLogLevelALL   =  NSUIntegerMax
    
    
};

typedef NS_ENUM(NSUInteger,LKThirdLogLevel) {
    /* 关闭日志 */
    LKThirdLogLevelOff = 0,
    /* 开启日志 */
    LKThirdLogLevelOn = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface LKThirdLog : NSObject
+ (void)setThirdLog:(LKThirdLogLevel)level;
+ (void)setDefaultLog;
+ (void)setAppsFlyerisDebug:(BOOL)isDebug;
+ (void)setMQTTLogLevel:(LKMQTTLogLevel)logLevel;
@end

NS_ASSUME_NONNULL_END

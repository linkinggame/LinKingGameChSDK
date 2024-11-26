//
//  LKLog.m
//  LinKingSDK
//
//  Created by leon on 2021/5/26.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKLog.h"
#import <MQTTClient/MQTTClient.h>
@implementation LKLog

#ifdef DEBUG

LKLogLevel lkLogLevel = LKLogLevelVerbose;

#else

LKLogLevel lkLogLevel = LKLogLevelWarning;

#endif


+ (void)setLogLevel:(LKLogLevel)logLevel{
    lkLogLevel = logLevel;
   
}

   
/**
 #ifdef DEBUG

 #define LKLogVerbose if ( lkLogLevel & LKLogFlagVerbose ) NSLog
 #define LKLogDebug if ( lkLogLevel & LKLogFlagDebug ) NSLog
 #define LKLogWarn if ( lkLogLevel & LKLogFlagWaring ) NSLog
 #define LKLogInfo if ( lkLogLevel & LKLogFlagInfo ) NSLog
 #define LKLogError if ( lkLogLevel & LKLogFlagError ) NSLog


 #else

 #define LKLogVerbose(...)
 #define LKLogDebug(...)
 #define LKLogWarn(...)
 #define LKLogInfo(...)
 #define LKLogError(...)

 #endif
 */



@end

//
//  LKUserEntity.m
//  LinKingSDK
//
//  Created by leon on 2021/5/20.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKUserEntity.h"
#import "NSObject+LKUserDefined.h"

static LKUserEntity *_instance = nil;

@implementation LKUserEntity


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKUserEntity alloc] init];
    });
    return _instance;
}





@end

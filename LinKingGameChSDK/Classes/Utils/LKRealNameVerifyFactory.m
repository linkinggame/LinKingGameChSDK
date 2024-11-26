//
//  LKRealNameVerifyFactory.m
//  LinKingSDK
//
//  Created by leon on 2021/5/19.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKRealNameVerifyFactory.h"
#import "LKConcreteRealNameVerify.h"
#import "LKRealNameVerify.h"
@implementation LKRealNameVerifyFactory

+ (NSObject<LKRealNameVerify> *)createRealNameVerify{
    LKConcreteRealNameVerify *object = [LKConcreteRealNameVerify shared];
    return object;
}


@end

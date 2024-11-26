//
//  LKConcreteRealNameVerify.h
//  LinKingSDK
//
//  Created by leon on 2021/5/19.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKRealNameVerify.h"
NS_ASSUME_NONNULL_BEGIN

@interface LKConcreteRealNameVerify : NSObject<LKRealNameVerify>
+ (instancetype)shared;
@end

NS_ASSUME_NONNULL_END

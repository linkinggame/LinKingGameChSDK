//
//  LKAdTopOnFactory.h
//  LinKingSDK
//
//  Created by leon on 2021/5/28.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//


#import "LKTopOnContext.h"
#import "LKAdContext.h"
@class LKTopOnConcrete;
NS_ASSUME_NONNULL_BEGIN

@interface LKAdTopOnFactory : LKTopOnContext<LKTopOnContext>
+ (instancetype)shared;

- (LKTopOnConcrete*)createAdConcrete:(LKAdContext<LKAdContext>*)adContext;
@end

NS_ASSUME_NONNULL_END

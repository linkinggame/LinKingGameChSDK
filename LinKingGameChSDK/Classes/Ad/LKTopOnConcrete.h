//
//  LKTopOnConcrete.h
//  LinKingSDK
//
//  Created by leon on 2021/5/27.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAdInterface.h"

typedef NS_ENUM(NSInteger, TopOnAdStyle) {
    TopOnAdStyle_Banner = 0,
    TopOnAdStyle_Interstitial,
    TopOnAdStyle_RewardVideo,
};

NS_ASSUME_NONNULL_BEGIN

@interface LKTopOnConcrete : NSObject<LKAdInterface>
+ (instancetype)shared;
@property (nonatomic,assign) TopOnAdStyle style;
- (void)registerTopOnSDK;
- (void)setLogEnabled:(BOOL)enable;
@end

NS_ASSUME_NONNULL_END

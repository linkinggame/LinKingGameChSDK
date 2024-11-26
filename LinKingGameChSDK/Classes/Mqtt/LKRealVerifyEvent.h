//
//  LKRealVerifyEvent.h
//  LinKingSDK
//
//  Created by leon on 2021/5/18.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKTopicEvent.h"
NS_ASSUME_NONNULL_BEGIN

/// 实名认证验证
@interface LKRealVerifyEvent : LKTopicEvent<LKTopicEvent>

+ (instancetype)shared;
@property (nonatomic, copy) void(^realVerifyEventHandler)(NSString * _Nullable realVerify);

@end

NS_ASSUME_NONNULL_END

//
//  LKAntiAddictionEvent.h
//  LinKingSDK
//
//  Created by leon on 2021/5/25.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//


#import "LKTopicEvent.h"
NS_ASSUME_NONNULL_BEGIN


/// 防沉迷
@interface LKAntiAddictionEvent : LKTopicEvent<LKTopicEvent>
+ (instancetype)shared;
@property(nonatomic, assign) int code;
@end

NS_ASSUME_NONNULL_END

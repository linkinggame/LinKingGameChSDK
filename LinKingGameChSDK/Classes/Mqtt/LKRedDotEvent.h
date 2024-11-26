//
//  LKRedDotEvent.h
//  LinKingSDK
//
//  Created by leon on 2021/5/25.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//


#import "LKTopicEvent.h"
NS_ASSUME_NONNULL_BEGIN

/// 小红点事件
@interface LKRedDotEvent : LKTopicEvent<LKTopicEvent>
+ (instancetype)shared;
@property (nonatomic, copy) void(^isRedRodHandler)(BOOL isRedRod);
/// 是否有小红点
- (BOOL)getisRedRot;
@end

NS_ASSUME_NONNULL_END

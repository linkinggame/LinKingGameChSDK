//
//  LKAccountBlockedEvent.h
//  LinKingSDK
//
//  Created by leon on 2021/8/2.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKTopicEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKAccountBlockedEvent : LKTopicEvent<LKTopicEvent>
+ (instancetype)shared;
@end

NS_ASSUME_NONNULL_END

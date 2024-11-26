//
//  LKTopicEvent.h
//  LinKingSDK
//
//  Created by leon on 2021/5/17.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol LKTopicEvent

// 订阅事件
- (NSString * _Nonnull)getTopicEvent;

/// 接收订阅推送的消息
/// @param message 消息信息
/// @param topic 主体
/// @param retained 表示数据是否从服务器存储重传
- (void)receivedMessage:(NSDictionary * _Nonnull)message onTopic:(NSString * _Nullable)topic retained:(BOOL)retained;

@end

@interface LKTopicEvent : NSObject<LKTopicEvent>
- (BOOL)isMeWithUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END

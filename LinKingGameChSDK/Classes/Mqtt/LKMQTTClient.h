//
//  LKMQTTClient.h
//  LinKingSDK
//
//  Created by leon on 2021/5/18.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKTopicEvent.h"
@class MQTTSessionManager;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MQTTSessionState) {
    MQTTSessionStateStarting,
    MQTTSessionStateConnecting,
    MQTTSessionStateError,
    MQTTSessionStateConnected,
    MQTTSessionStateClosing,
    MQTTSessionStateClosed
};

@protocol LKMQTTClient

@required

/**
  初始化参数
 */
- (NSDictionary *)mqttSettings;
/**
   获取订阅主题
 */
- (NSString *)getObserverTopic;
/**
  连接MQTT 服务
 */
- (void)connectWithDisconnectHandler:(void(^)(NSError *error))connectHandler;
/**
  取消MQTT服务
 */
- (void)disconnectWithDisconnectHandler:(void(^)(NSError *error))connectHandler;
/**
  发送消息
 */
- (void)send:(NSString *)message;

@optional
// 消息回调
@property (nonatomic, copy) void(^messageHandler)(NSData *data,NSString *topic,BOOL retained);
// 状态发生改变的回调
@property (nonatomic, copy) void(^stateChangeHandler)(MQTTSessionState state);
/**
  消息回调
 */
- (void)MQTTHandleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained;
/**
   状态发生变化
 */
- (void)MQTTHandleState:(MQTTSessionState)state;
@end

@interface LKMQTTClient : NSObject<LKMQTTClient>
@property (strong, nonatomic) MQTTSessionManager *manager;
/// 添加订阅对象
/// @param obejct obejct description
- (void)addMQTTObserver:(NSObject<LKTopicEvent>*)obejct;
/// 移除订阅对象
/// @param object object description
- (void)removeMQTTObserver:(NSObject<LKTopicEvent> *)object;
/// 移除所有订阅对象
- (void)removeALLObserver;
@property (nonatomic,strong,readonly) NSMutableArray *observes;
@end

NS_ASSUME_NONNULL_END

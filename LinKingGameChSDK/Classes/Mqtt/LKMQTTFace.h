//
//  LKMQTTFace.h
//  LinKingSDK
//
//  Created by leon on 2021/5/18.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LKMQTTClient;
NS_ASSUME_NONNULL_BEGIN

@interface LKMQTTFace : NSObject
@property (nonatomic,strong) LKMQTTClient *_Nullable client;
+ (instancetype)shared;
/// 连接MQTT服务
- (void)connectMQTT;

/// 断开MQTT服务
- (void)disconnectMQTT;
@end

NS_ASSUME_NONNULL_END

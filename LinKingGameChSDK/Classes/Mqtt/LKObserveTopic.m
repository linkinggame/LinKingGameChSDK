//
//  LKObserveTopic.m
//  LinKingSDK
//
//  Created by leon on 2021/5/18.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKObserveTopic.h"
#import "LKTopicEvent.h"
#import "LKLog.h"
static LKObserveTopic *_instance = nil;

@interface LKObserveTopic ()
@property (nonatomic, copy) NSString *secretKey;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, strong) NSDictionary *settings;

@end

@implementation LKObserveTopic

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKObserveTopic alloc] init];
    });
    return _instance;
}
- (instancetype)initWithClientId:(NSString *)clientId secretKey:(NSString *)secretKey{
    self.clientId = clientId;
    self.secretKey = secretKey;
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithClientId:(NSString *_Nonnull)clientId withSecretKey:(NSString *_Nonnull)secretKey withSettings:(NSDictionary *)settings {
    self.clientId = clientId;
    self.secretKey = secretKey;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:settings];
    [dict setValue:self.secretKey forKey:@"secretKey"];
    [dict setValue:self.clientId forKey:@"clientId"];
    self.settings = dict;
    self = [super init];
    if (self) {
    }
    return self;
}


- (NSDictionary *)mqttSettings{
    
     
    NSString *instanceId = self.settings[@"instanceId"];
    NSString *rootTopic = self.settings[@"rootTopic"];
    NSString *accessKey = self.settings[@"accessKey"];
    NSString *groupId = self.settings[@"groupId"];
    NSString *host = self.settings[@"host"];
    NSNumber *port = self.settings[@"port"];

    NSDictionary *mqttSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  instanceId,@"instanceId",
                                  rootTopic,@"rootTopic" ,
                                  accessKey,@"accessKey" ,
                                  self.secretKey,@"secretKey",
                                  groupId,@"groupId",
                                  @0,@"qos",
                                  host,@"host",
                                  port,@"port",
                                  @0,@"tls",
                                  self.clientId,@"clientId",
                                  nil];
    return mqttSettings;
    
}

- (NSString *)getObserverTopic{
    
    return self.settings[@"rootTopic"];
    
}

/**
  发送消息
 */
- (void)send:(NSString *)message{
    
    LKLogInfo(@"子类实现发送消息接口");
    
}


- (void)MQTTHandleState:(MQTTSessionState)state{
    LKLogInfo(@"");
}


- (void)MQTTHandleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained{
    
    LKLogInfo(@"%s",__FUNCTION__);
    NSDictionary *result = [self parseDictionary:data];
    if (result == nil) {
        return;
    }
    NSString *event = result[@"event"];
    // 通知订阅
    for (NSObject<LKTopicEvent> *object in self.observes) {
        if ([event isEqualToString:[object getTopicEvent]]) {
            if ([object respondsToSelector:@selector(receivedMessage:onTopic:retained:)]) {
                LKLogInfo(@"===============调用次数===================%@",object);
                [object receivedMessage:result onTopic:topic retained:retained];
            }
        }
    }
    
}



///  将接受的数据转换成字典
/// @param data 二进制
- (NSDictionary *)parseDictionary:(NSData *)data{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    LKLogInfo(@"message:%@",message);
    NSDictionary *result = NULL;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([object isKindOfClass:[NSDictionary class]]) {
       result = (NSDictionary *)object;
    }
    return result;
}

@end

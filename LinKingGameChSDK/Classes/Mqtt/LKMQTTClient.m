//
//  LKMQTTClient.m
//  LinKingSDK
//
//  Created by leon on 2021/5/18.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKMQTTClient.h"
#import <CommonCrypto/CommonHMAC.h>
#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>
#import "LKUser.h"
#import "LKSystem.h"
#import "LKLog.h"

@interface LKMQTTClient ()<MQTTSessionManagerDelegate>
@property (nonatomic,strong) NSMutableArray* observes;

@property (strong, nonatomic) NSDictionary *settings;
@property (strong, nonatomic) NSString *instanceId;
@property (strong, nonatomic) NSString *rootTopic;
@property (strong, nonatomic) NSString *accessKey;
@property (strong, nonatomic) NSString *secretKey;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *clientId;
@property (nonatomic,assign) NSInteger qos;
@end

@implementation LKMQTTClient

@synthesize messageHandler;
@synthesize stateChangeHandler;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.observes = [NSMutableArray array];
        [self initParams];
    }
    return self;
}



/// 父类抽象函数
- (NSDictionary *)mqttSettings{return nil;}


- (void)initParams{
    
    // 读取配置文件参数
    NSDictionary *dictionarySettings = [self mqttSettings];
    self.settings = dictionarySettings;
    //实例 ID，购买后从控制台获取
    self.instanceId = self.settings[@"instanceId"];
    self.rootTopic = self.settings[@"rootTopic"];
    self.accessKey = self.settings[@"accessKey"];
    self.secretKey = self.settings[@"secretKey"];
    self.groupId = self.settings[@"groupId"];
    self.qos = [self.settings[@"qos"] integerValue];
    //cientId的生成必须遵循GroupID@@@前缀，且需要保证全局唯一 GID_XXXXX@@@app_id@#user_id
    // [NSString stringWithFormat:@"%@@@@%@@#%@",self.groupId,@"xxyzappcn_ios",@"1390246637677219840"];
    self.clientId= self.settings[@"clientId"];
    
}

/**
   订阅主题
 */
- (NSString *)getObserverTopic{
    return self.rootTopic;
}

/**
  连接服务
 */
- (void)connectWithDisconnectHandler:(void(^)(NSError *error))connectHandler {
    
    
//    [MQTTLog setLogLevel:DDLogLevelOff];
    
    /*
     * MQTTClient: create an instance of MQTTSessionManager once and connect
     * will is set to let the broker indicate to other subscribers if the connection is lost
     */
    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;
        NSDictionary *info = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:(int)self.qos]
                                                         forKey:[NSString stringWithFormat:@"%@", [self getObserverTopic]]];
        LKLogInfo(@"[LKMQTTClient] info = %@",info);
        self.manager.subscriptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:(int)self.qos]
                                                                 forKey:[NSString stringWithFormat:@"%@", [self getObserverTopic]]];
        
        
        //password的计算方式是，使用secretkey对clientId做hmac签名算法，具体实现参考macSignWithText方法
        NSString *passWord = [NSString stringWithFormat:@"RW|%@",self.secretKey];
        //self.secretKey;
  
        NSString *userName = [NSString stringWithFormat:@"Token|%@|%@",self.accessKey,self.instanceId];
        // [NSString stringWithFormat:@"Signature|%@|%@",self.accessKey,self.instanceId];
        //此处从配置文件导入的Host即为MQTT的接入点，该接入点获取方式请参考资源申请章节文档，在控制台上申请MQTT实例，每个实例会分配一个接入点域名
        LKLogInfo(@"passWord:%@",passWord);
        LKLogInfo(@"userName:%@",userName);
        [self.manager connectTo:self.settings[@"host"]
                           port:[self.settings[@"port"] intValue]
                            tls:[self.settings[@"tls"] boolValue]
                      keepalive:60
                          clean:true
                           auth:true
                           user:userName
                           pass:passWord
                           will:false
                      willTopic:nil
                        willMsg:nil
                        willQos:0
                 willRetainFlag:FALSE
                   withClientId:self.clientId
                 securityPolicy:nil
                   certificates:nil
                  protocolLevel:MQTTProtocolVersion311
                 connectHandler:^(NSError *error) {
            
            if (!error) {
                LKLogInfo(@"===MQTT:连接成功===");
            }else{
                LKLogInfo(@"===MQTT:连接失败:%@===",error);
            }
        }];

    } else {

        LKLogInfo(@"====重新连接======");
        [self.manager connectToLast:^(NSError *error) {
            LKLogError(@"%@",error);
        }];
    }
    /*
     * MQTTCLient: observe the MQTTSessionManager's state to display the connection status
     */
    [self observerMQTTState];
}



/// 重新连接
/// @param connectHandler <#connectHandler description#>
- (void)reconnected:(void(^ _Nullable)(NSError *_Nullable error))connectHandler{
    [self.manager connectToLast:^(NSError *error) {
        if (!error) {
            LKLogInfo(@"===MQTT:重新连接成功===");
        }else{
            LKLogError(@"===MQTT:重新连接失败:%@===",error);
        }
        if (connectHandler) {
            connectHandler(error);
        }
    }];
}


/// 监听MQTT的状态
- (void)observerMQTTState{
    
    [self.manager addObserver:self
                   forKeyPath:@"state"
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.manager.state) {
        case MQTTSessionManagerStateClosed:
            LKLogInfo( @"closed");
            break;
        case MQTTSessionManagerStateClosing:
            LKLogInfo( @"closing");
            break;
        case MQTTSessionManagerStateConnected:
            LKLogInfo( @"connected");
            break;
        case MQTTSessionManagerStateConnecting:
            LKLogInfo( @"connecting");
            break;
        case MQTTSessionManagerStateError:
            LKLogInfo( @"error");
            break;
        case MQTTSessionManagerStateStarting:
        default:
            LKLogInfo( @"not connected");
            break;
    }
    
    if ([self respondsToSelector:@selector(MQTTHandleState:)]) {
        [self MQTTHandleState:(MQTTSessionState)self.manager.state];
    }
    
    if (self.stateChangeHandler) {
        self.stateChangeHandler((MQTTSessionState)self.manager.state);
    }
    
}

/**
 断开连接
 */
- (void)disconnectWithDisconnectHandler:(void(^)(NSError *error))connectHandler; {
    if (self.manager) {
        [self.manager disconnectWithDisconnectHandler:^(NSError *error) {
            if (!error) {
                LKLogInfo(@"===断开连接成功===");
            }else{
                LKLogInfo(@"===断开连接失败===");
            }
        }];
    }
}

/**
  发送消息
 */
- (void)send:(NSString *)message {
    
    LKLogInfo(@"TODO:子类实现发行消息");
}

+ (NSString *)macSignWithText:(NSString *)text secretKey:(NSString *)secretKey
{
    NSData *saltData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA1, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    NSString *base64Hash = [hash base64EncodedStringWithOptions:0];
    return base64Hash;
}


/*
 * MQTTSessionManagerDelegate
 */
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    /*
     * MQTTClient: process received message
     */
    LKLogInfo(@"%s",__FUNCTION__);
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    LKLogInfo(@"MQTTClient: process received message = %@",dataString);
    
    if ([self respondsToSelector:@selector(MQTTHandleMessage:onTopic:retained:)]) {
        [self MQTTHandleMessage:data onTopic:topic retained:retained];
    }
    
    if (self.messageHandler) {
        self.messageHandler(data, topic, retained);
    }
    
}
    
- (void)MQTTHandleState:(MQTTSessionState)state{
    LKLogInfo(@"===抽象类实现接收回调===");
}

- (void)MQTTHandleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained{
    LKLogInfo(@"%s",__FUNCTION__);
    LKLogInfo(@"===抽象类实现接收回调===");
}


- (void)addMQTTObserver:(NSObject<LKTopicEvent>*)obejct{
    if (obejct == NULL) {
        return;
    }
    [self.observes addObject:obejct];
}


- (void)removeMQTTObserver:(NSObject<LKTopicEvent> *)object{
    if (object == NULL) {
        return;
    }
    [self.observes removeObject:object];
}

- (void)removeALLObserver{
    [self.observes removeAllObjects];
}

@end

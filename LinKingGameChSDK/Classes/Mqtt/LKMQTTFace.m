//
//  LKMQTTFace.m
//  LinKingSDK
//
//  Created by leon on 2021/5/18.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKMQTTFace.h"
#import "LKObserveTopic.h"
#import "LKUser.h"
#import "LKSystem.h"

#import "LKSDKConfigApi.h"
#import "LKRealVerifyEvent.h"
#import "LKRedDotEvent.h"
#import "LKAntiAddictionEvent.h"
#import "LKCheckTokenEvent.h"
#import "LKSDKConfig.h"
#import "LKLog.h"
#import "MQTTSessionManager.h"
#import "LKAccountBlockedEvent.h"
static LKMQTTFace *_instance = nil;

@interface LKMQTTFace ()
//@property (nonatomic,strong) LKMQTTClient *client;
@end

@implementation LKMQTTFace


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKMQTTFace alloc] init];
    });
    return _instance;
}

#define LEON
- (void)connectMQTT{

    
     BOOL isUseMQttCheck = [LKSDKConfig isMqttCheck];
    if (isUseMQttCheck == YES) {
        LKLogInfo(@"[LKMQTTFace] === 使用MQTT机制 ===");
        [self fetchSecretKeyWithComplete:^(id result, NSError *error) {
                
        }];
    }
   
   /**

    typedef NS_ENUM(int, MQTTSessionManagerState) {
        MQTTSessionManagerStateStarting,
        MQTTSessionManagerStateConnecting,
        MQTTSessionManagerStateError,
        MQTTSessionManagerStateConnected,
        MQTTSessionManagerStateClosing,
        MQTTSessionManagerStateClosed
    };

    */
}


- (void)disconnectMQTT{
    BOOL isUseMQttCheck = [LKSDKConfig isMqttCheck];
    if (isUseMQttCheck == YES) {
        [self.client disconnectWithDisconnectHandler:^(NSError * _Nonnull error) {
            self.client = nil;
        }];
        
    }
}


- (void)fetchSecretKeyWithComplete:(void(^)(id result,NSError *error))complete{
    NSString *userId = [LKUser getUser].userId;
    NSString *appId = [LKSystem getSystem].appID;
    
    // 获取MQTT --- groupId
    NSDictionary *mqttConfig = [LKSDKConfig getMQttSettingFromConfig];
    NSString *groupId = mqttConfig[@"groupId"];
    
    NSString*clientId= [NSString stringWithFormat:@"%@@@@%@@#%@",groupId,appId,userId];
    //[NSString stringWithFormat:@"%@@@@%@@#%@",@"GID_app_sdk",appId,userId];
    // [NSString stringWithFormat:@"%@@@@%@@#%@",@"GID_app_sdk",@"test",@"1394555113224744960"];
    
    [LKSDKConfigApi fetchMQTTClientIdTokenKeyWithComplete:^(NSObject * _Nonnull result, NSError * _Nullable error) {
        LKLogInfo(@"result:%@",result);
        if (complete) {
            complete(result,error);
        }
        
        if ([result isKindOfClass:[NSString class]]) {
            NSString *secretKey = (NSString *)result;
            [self connectMQTTWithClientId:clientId secretKey:secretKey];
            
        }
    }];
    
    
}



- (void)connectMQTTWithClientId:(NSString *)clientId secretKey:(NSString *)secretKey{
    

    NSDictionary *mqtt = [LKSDKConfig getMQttSettingFromConfig];
    
    // 创建客户端连接对象
    self.client = [[LKObserveTopic alloc] initWithClientId:clientId withSecretKey:secretKey withSettings:mqtt];
    
    
    // 连接
    [self.client connectWithDisconnectHandler:^(NSError * _Nonnull error) {

    }];
    // 添加事件
    [self addTopicEvent];
    // 回调
    self.client.messageHandler = ^(NSData * _Nonnull data, NSString * _Nonnull topic, BOOL retained) {
        LKLogInfo(@"block === MQTT消息接收到回调");
    };
    self.client.stateChangeHandler = ^(MQTTSessionState state) {
        LKLogInfo(@"block === MQTT状态接收到回调");
    };
}


- (void)addTopicEvent{
    // 实名认证验证
    LKRealVerifyEvent *realVerifyEvent = [LKRealVerifyEvent shared];
    // 发送小红点
    LKRedDotEvent *redDotEvent = [LKRedDotEvent shared];
    // 发送防沉迷
    LKAntiAddictionEvent *antiAddictionEvent = [LKAntiAddictionEvent shared];
    // token检查
    LKCheckTokenEvent *checkTokenEvent = [LKCheckTokenEvent shared];
    // 封号事件
    LKAccountBlockedEvent *accountBlockedEvent = [LKAccountBlockedEvent shared];
    [self.client addMQTTObserver:realVerifyEvent];
    [self.client addMQTTObserver:redDotEvent];
    [self.client addMQTTObserver:antiAddictionEvent];
    [self.client addMQTTObserver:checkTokenEvent];
    [self.client addMQTTObserver:accountBlockedEvent];
}




@end

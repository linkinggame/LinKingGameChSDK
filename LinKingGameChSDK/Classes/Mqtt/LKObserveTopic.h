//
//  LKObserveTopic.h
//  LinKingSDK
//
//  Created by leon on 2021/5/18.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKMQTTClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface LKObserveTopic : LKMQTTClient<LKMQTTClient>
- (instancetype)initWithClientId:(NSString *)clientId secretKey:(NSString *)secretKey;

/// TODO:使用这个
/// @param clientId <#clientId description#>
/// @param secretKey <#secretKey description#>
/// @param settings <#settings description#>
- (instancetype)initWithClientId:(NSString *_Nonnull)clientId withSecretKey:(NSString *_Nonnull)secretKey withSettings:(NSDictionary *)settings;
@end

NS_ASSUME_NONNULL_END

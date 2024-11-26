
#import "LKBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKSDKConfigApi : LKBaseApi
+ (void)fetchSDKConfigComplete:(void(^_Nullable)(NSError *_Nullable error))complete;
+ (void)fetchSDKConfigAppId:(NSString *)appId complete:(void(^_Nullable)(NSError *_Nullable error))complete;
+ (void)fetchMQTTClientIdKey:(NSString *)clientId WithComplete:(void(^)(NSObject *result,NSError *_Nullable error))complete;
+ (void)fetchMQTTClientIdTokenKeyWithComplete:(void(^)(NSObject *result,NSError *_Nullable error))complete;
+ (void)fetchSDKConfigURLWithAppId:(NSString *)appId complete:(void(^_Nullable)(NSString * _Nullable url,NSError *_Nullable error))complete;
+ (void)fetchSDKConfigWithURL:(NSString *)url complete:(void(^_Nullable)(NSError *_Nullable error))complete;
@end

NS_ASSUME_NONNULL_END

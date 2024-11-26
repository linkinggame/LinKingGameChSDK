

#import "LKBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKAuthApi : LKBaseApi
+ (void)authWithName:(NSString *)name IdNumber:(NSString *)number complete:(void(^_Nullable)(NSDictionary *_Nullable result,NSError *_Nullable error))complete;

/// 校验实名认证信息
/// @param complete complete description
+ (void)checkRealNameInfoWithComplete:(void(^)(NSDictionary *result,NSError *error))complete;


/// 检查token
/// @param complete complete description
+ (void)checkSessionTokenWithComplete:(void(^)(NSDictionary *result,NSError *error))complete;

/// 检查防沉迷
/// @param complete complete description
+ (void)checkAntiAddictionWithComplete:(void(^)(NSDictionary *result,NSError *error))complete;
@end

NS_ASSUME_NONNULL_END

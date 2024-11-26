

#import "LKBaseApi.h"

NS_ASSUME_NONNULL_BEGIN
@interface LKAlterLoginApi : LKBaseApi
+ (void)fetchCheckCodeByPhone:(NSString *)phone isNewUserComplete:(void(^_Nullable)(BOOL isNewUser,NSError *error))complete;
+ (void)fetchCheckCodeBindingByPhone:(NSString *)phone complete:(void(^)(NSError *error))complete;
+ (void)loginWithIphone:(NSString *)iphone checkCode:(NSString *)code password:(NSString *)password complete:(void(^_Nullable)(NSError *error))complete;
+ (void)quickLoginComplete:(void(^_Nullable)(NSError *error))complete;
+ (void)appleLoginWithToken:(NSString *)token Complete:(void(^_Nullable)(NSError *error))complete;
+ (void)accountLoginWithIphone:(NSString *)iphone withPassword:(NSString *)password Complete:(void(^_Nullable)(NSError *error))complete;
+ (void)autoLoginComplete:(void(^_Nullable)(NSError *error))complete;
+ (void)checkUserInfoWithTime:(int)second complete:(void(^_Nullable)(NSDictionary *result,NSError *error))complete;
@end

NS_ASSUME_NONNULL_END

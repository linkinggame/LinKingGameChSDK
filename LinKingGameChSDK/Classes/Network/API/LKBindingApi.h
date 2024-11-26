

#import "LKBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKBindingApi : LKBaseApi
+ (void)bindAccountWithType:(NSString *)type phone:(NSString *)phone thirdToken:(NSString *)thirdToken complete:(void(^_Nullable)(NSError *error))complete;
@end

NS_ASSUME_NONNULL_END

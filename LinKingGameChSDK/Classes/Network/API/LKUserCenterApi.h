

#import "LKBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKUserCenterApi : LKBaseApi
+ (void)fetchUserIconcomplete:(void(^_Nullable)(NSError *error,NSArray *data,NSString *icon))complete;
+ (void)sureFixUserIconWithIconId:(NSString *)iconId Complete:(void(^_Nullable)(NSError *error))complete;
@end

NS_ASSUME_NONNULL_END

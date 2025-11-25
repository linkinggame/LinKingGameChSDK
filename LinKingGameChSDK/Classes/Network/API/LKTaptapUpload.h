
#import "LKBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKTaptapUpload : LKBaseApi

+ (void)uploadTaptapType:(NSString *)event_type withAmount:(NSString *)amount withPayType:(NSString *)pay_type complete:(void(^_Nullable)(NSError *_Nullable error))complete;


+ (void)uploadLoginTaptapType:(NSString *)event_type complete:(void(^_Nullable)(NSError *_Nullable error))complete;



@end

NS_ASSUME_NONNULL_END

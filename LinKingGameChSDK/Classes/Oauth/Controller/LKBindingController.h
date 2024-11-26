
#import "LKBaseViewController.h"
@class LKUser;
NS_ASSUME_NONNULL_BEGIN

@interface LKBindingController : LKBaseViewController
@property (nonatomic,copy)void(^appleLoginCallBack)(NSError *error);
@property (nonatomic,copy)void(^bindingAccountCompleteCallBack)(LKUser * _Nullable user,NSError * _Nullable error);
@end

NS_ASSUME_NONNULL_END



#import "LKBaseViewController.h"
@class LKUser;
NS_ASSUME_NONNULL_BEGIN

@interface LKWecomeViewController : LKBaseViewController
@property (nonatomic,copy)void(^loginCompleteCallBack)(LKUser * _Nullable user,NSError * _Nullable error);
@end

NS_ASSUME_NONNULL_END

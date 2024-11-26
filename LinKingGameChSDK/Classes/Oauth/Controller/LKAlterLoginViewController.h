

#import "LKBaseViewController.h"
@class LKUser;
NS_ASSUME_NONNULL_BEGIN

@interface LKAlterLoginViewController : LKBaseViewController
@property (nonatomic, assign) BOOL agreement;
@property (nonatomic,copy)void(^appleLoginCallBack)(NSError *error);
@property (nonatomic,copy)void(^changeAccountCallBack)(void);
@property(nonatomic, copy)void(^thirdLoginAction)(UIButton *sender);
@property (nonatomic,copy)void(^loginCompleteCallBack)(LKUser *_Nullable user,NSError * _Nullable error);
- (void)setCloseView:(BOOL)isclose;
@end

NS_ASSUME_NONNULL_END

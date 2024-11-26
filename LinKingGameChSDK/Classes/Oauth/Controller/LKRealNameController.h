

#import "LKBaseViewController.h"
@class LKUser;
NS_ASSUME_NONNULL_BEGIN

@interface LKRealNameController : LKBaseViewController
@property (nonatomic,copy)void(^loginCompleteCallBack)(LKUser * _Nullable user,NSError * _Nullable error);
@property (nonatomic,copy)void(^closePayCallBack)(void);
@property (nonatomic,copy)void(^closeCallBack)(void);
// 防沉迷结果回调
@property (nonatomic,copy)void(^realNameCompeleteCallBack)(BOOL isCancel,NSError * _Nullable error);
@property (nonatomic, assign) BOOL isShowClose;

// 认证失败弹出一个提示
@property (nonatomic, assign) BOOL isRealNameFail;

@end

NS_ASSUME_NONNULL_END

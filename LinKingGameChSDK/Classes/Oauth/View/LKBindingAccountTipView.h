

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKBindingAccountTipView : UIView
@property (nonatomic, copy)void(^closeAlterViewCallBack)(void);
@property (nonatomic, copy)void(^quickGameCallBack)(void);
@property (nonatomic, copy)void(^bindingAcccountCallBack)(void);
+ (instancetype)instanceBindingAccountTipView;
@end

NS_ASSUME_NONNULL_END

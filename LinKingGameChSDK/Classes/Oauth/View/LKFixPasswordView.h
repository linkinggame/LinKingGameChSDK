

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKFixPasswordView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textfield_oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textfield_newPassword;
@property (weak, nonatomic) IBOutlet UITextField *testfield_surePassword;
@property (weak, nonatomic) IBOutlet UIButton *button_sure;
@property (nonatomic, copy) void(^closeAlterViewCallBack)(void);
@property (nonatomic, copy) void(^surePasswordCallBack)(void);
@property (nonatomic, copy) void(^restPasswordCallBack)(void);
+ (instancetype)instanceFixPasswordView;
- (void)setLKSuperView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

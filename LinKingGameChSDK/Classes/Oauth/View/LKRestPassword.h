
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKRestPassword : UIView
@property (weak, nonatomic) IBOutlet UITextField *textfield_iphone;
@property (weak, nonatomic) IBOutlet UITextField *textfield_code;
@property (weak, nonatomic) IBOutlet UITextField *textfield_newPassword;
@property (weak, nonatomic) IBOutlet UITextField *textfield_surePassword;
@property (weak, nonatomic) IBOutlet UIButton *button_sureFix;
@property (weak, nonatomic) IBOutlet UIButton *button_getCode;
@property(nonatomic, copy)void(^getCheckCodeAction)(UIButton *sender);
@property(nonatomic, copy)void(^fixPasswordAction)(UIButton *sender);
@property(nonatomic, copy)void(^closeView)(UIButton *sender);
@property(nonatomic, copy)void(^fixPasswordCallBack)(UIButton *sender);
+ (instancetype)instanceRestPasswordView;
- (void)setLKSuperView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END

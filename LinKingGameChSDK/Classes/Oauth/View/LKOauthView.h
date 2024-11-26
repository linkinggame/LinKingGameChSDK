
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,SignInStyle) {
    SignInStyle_PWD = 10,
    SignInStyle_Code = 20,
    SignInStyle_Quick = 30,
    SignInStyle_Apple = 40,

};

NS_ASSUME_NONNULL_BEGIN

@interface LKOauthView : UIView

@property(nonatomic, copy)void(^getCheckCodeAction)(UIButton *sender);
@property(nonatomic, copy)void(^switchAction)(UIButton *sender);
@property(nonatomic, copy)void(^iphoneLoginAction)(UIButton *sender,SignInStyle signInStyle);
@property(nonatomic, copy)void(^forgetPwdAction)(UIButton *sender);
@property(nonatomic, copy)void(^readProtocolAction)(UIButton *sender);
@property(nonatomic, copy)void(^thirdLoginAction)(UIButton *sender);
@property(nonatomic, copy)void(^closeAlterViewCallBack)(void);
@property(nonatomic, copy)void(^useAgreementCallBack)(BOOL isAgreement,UIButton *sender);
@property(nonatomic, copy)void(^textFieldBenginEditCallBack)(CGFloat startRealHeight);
@property (weak, nonatomic) IBOutlet UIView *view_switch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHeader;
@property (weak, nonatomic) IBOutlet UITextField *textfield_iphone;
@property (weak, nonatomic) IBOutlet UIButton *button_pwd;
@property (weak, nonatomic) IBOutlet UIButton *button_code;
@property (weak, nonatomic) IBOutlet UITextField *textfield_code;
@property (weak, nonatomic) IBOutlet UIButton *button_get_code;
@property (weak, nonatomic) IBOutlet UITextField *textfield_pwd;


@property (weak, nonatomic) IBOutlet UIView *view_checkCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_checkCode_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_checkCode_top;
@property (weak, nonatomic) IBOutlet UIView *view_checkout_line_one;
@property (weak, nonatomic) IBOutlet UIView *view_checkout_line_two;

@property (weak, nonatomic) IBOutlet UIView *view_pwd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_pwd_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_pwd_top;
@property (weak, nonatomic) IBOutlet UILabel *label_pwd;
@property (weak, nonatomic) IBOutlet UIView *view_pwd_line_one;
@property (weak, nonatomic) IBOutlet UIView *view_pwd_line_two;

@property (weak, nonatomic) IBOutlet UIView *view_phone;
@property (weak, nonatomic) IBOutlet UIView *view_phone_line_one;
@property (weak, nonatomic) IBOutlet UIView *view_phone_line_two;
@property (weak, nonatomic) IBOutlet UILabel *label_phone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_phone_height;



@property (weak, nonatomic) IBOutlet UILabel *label_otherLogin;
@property (weak, nonatomic) IBOutlet UIView *label_otherLogin_line_one;
@property (weak, nonatomic) IBOutlet UIView *lable_otherLogin_line_two;

@property (weak, nonatomic) IBOutlet UIButton *button_protocol;
@property (weak, nonatomic) IBOutlet UIView *view_apple;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_quick_login_top;


@property (weak, nonatomic) IBOutlet UIView *view_third_oauth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_third_oauth_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_third_oauth_height_top;
@property (weak, nonatomic) IBOutlet UIButton *button_check;
@property (weak, nonatomic) IBOutlet UIButton *button_login;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_login_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_login_top;


@property (weak, nonatomic) IBOutlet UIButton *button_quick;


@property (nonatomic, assign) NSInteger switchIndex;
@property (assign, nonatomic) BOOL isNewUser;
@property (assign, nonatomic) SignInStyle signInStyle;
@property (nonatomic, assign) CGFloat deductionHeight; // 扣减高度
@property (nonatomic, assign) CGFloat totalHeight; //
@property (nonatomic, assign) CGFloat startRealHeight;
+ (instancetype)instanceOauthView;
- (void)showViewPassword;
//- (void)hiddenViewPassword;
- (void)hiddenViewPasswordIsInitState:(BOOL)state;
- (void)setLKSuperView:(UIView *)superView;
- (void)updatePasswordView;
- (void)updateCodeView;

- (void)showButtonLogin;
- (void)hiddenButtonLogin;

- (void)showViewChechView;
- (void)hiddenViewChechView;
@end

NS_ASSUME_NONNULL_END

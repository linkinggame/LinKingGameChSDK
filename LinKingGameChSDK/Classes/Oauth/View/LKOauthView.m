

#import "LKOauthView.h"
#import "UIButton+LKCountDown.h"
#import "LKGlobalConf.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "LKSDKConfig.h"
#import "LKControlUtil.h"
@interface LKOauthView ()<UITextFieldDelegate>
@property (nonatomic,weak) UIView *contentView;
//@property (nonatomic,assign) CGFloat fixRealHeight;
@property (nonatomic, assign) BOOL isCountDowning; // 是否正在倒计时
@end
@implementation LKOauthView

+ (instancetype)instanceOauthView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    
    LKOauthView *view = [[bundle loadNibNamed:@"LKOauthView" owner:nil options:nil] firstObject];
    

    view.textfield_pwd.clearButtonMode = UITextFieldViewModeAlways;
    view.textfield_iphone.clearButtonMode = UITextFieldViewModeAlways;
    view.textfield_code.clearButtonMode = UITextFieldViewModeAlways;
    
    view.textfield_iphone.delegate = view;
    
    view.button_get_code.layer.borderColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1].CGColor;
    view.button_get_code.layer.borderWidth = 1;
    view.button_get_code.layer.cornerRadius = 8;
    view.button_get_code.clipsToBounds = YES;
    view.button_get_code.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    view.view_switch.layer.borderWidth = 1;
    view.view_switch.layer.borderColor = [UIColor colorWithRed:202/255.0 green:201/255.0 blue:201/255.0 alpha:1].CGColor;
    view.view_switch.layer.cornerRadius = 5;
    view.view_switch.clipsToBounds = YES;
    view.button_code.layer.cornerRadius = 4;
    view.button_code.clipsToBounds = YES;
    view.button_pwd.layer.cornerRadius = 4;
    view.button_pwd.clipsToBounds = YES;
    
    view.button_login.layer.cornerRadius = 40 * 0.5;
    view.button_login.clipsToBounds = YES;
    view.button_login.layer.borderColor = [UIColor colorWithRed:219/255.0 green:78/255.0 blue:78/255.0 alpha:1].CGColor;
    view.button_login.layer.borderWidth = 1;
    view.button_login.backgroundColor = [UIColor colorWithRed:219/255.0 green:78/255.0 blue:78/255.0 alpha:1];
    [view.button_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    view.button_quick.layer.cornerRadius = 40 * 0.5;
    view.button_quick.clipsToBounds = YES;
    view.button_quick.layer.borderColor = [UIColor colorWithRed:219/255.0 green:78/255.0 blue:78/255.0 alpha:1].CGColor;
    view.button_quick.layer.borderWidth = 1;
    

    
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
   
    [view hiddenViewPasswordIsInitState:YES];
    [view hiddenViewChechView];
    [view hiddenButtonLogin];
    
    
    CGFloat phoneViewHeight = 0;
    // 防沉迷控制
    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
     NSNumber *phoneShow = config.auth_config[@"phone_show"];
    if (phoneShow != nil) {
        if ([phoneShow boolValue] == YES) {
            [view showViewIphone];
        }else{
            [view hiddenViewIphone];
            phoneViewHeight = 40;
        }

    }else{
        [view hiddenViewIphone];
        phoneViewHeight = 40;
    }
    view.deductionHeight = 5 + 40 + 5 + 40 + 20 + 40 + phoneViewHeight;
   

    
    view.textfield_pwd.secureTextEntry = YES;
    view.switchIndex = 20;
    
    CGFloat width =  [UIScreen mainScreen].bounds.size.width - 40;
    if ([UIScreen mainScreen].bounds.size.width > 350 + 20 + 20) {
        width = 350 + 20 + 20;
    }
    
    
    if (@available(iOS 13.0, *)) {
        
        ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
        [button addTarget:view action:@selector(appleLoginAction) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 19;
        button.clipsToBounds = YES;
        [view.view_apple addSubview:button];

        button.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view.view_apple attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];

        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view.view_apple attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];

        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.view_apple attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];

        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.view_apple attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];

        [view.view_apple addConstraints:@[left,right,top,bottom]];

    }else{
        [view hiddenAppleView];
        view.deductionHeight =  view.deductionHeight + 64;
        
    }
    
    CGFloat deductionImageHeight = (17 * 1.0 / 43) * width;
    
    view.totalHeight = deductionImageHeight + 40 + 5 + 40 + 5 + 40 + 20 + 40 + 20 + 40  +  64 + 40;
    // deductionImageHeight + 40 + 5 + 40 + 5 + 40 + 20 + 40 + 20 + 40 + 72 + 40;
    
    [view controllerAuthShow];
    
    view.startRealHeight = view.totalHeight - view.deductionHeight;
    
    return view;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.textFieldBenginEditCallBack) {
        self.textFieldBenginEditCallBack(self.startRealHeight);
    }
}

- (void)controllerAuthShow{
    LKSDKConfig *config =  [LKSDKConfig getSDKConfig];
     
     if (config.auth_config.exceptNull != nil) {
         NSString *auth_type = config.auth_config[@"auth_type"];
         if ([auth_type rangeOfString:@","].location != NSNotFound) {
             
         }else{
             if (auth_type.exceptNull != nil) {
                 NSString *firstStr = auth_type;
                if ([firstStr isEqualToString:@"guest"]){
                    if ( self.view_third_oauth.hidden == YES) {
                        return;
                    }
                    [self hiddenAppleView];
                     self.deductionHeight =  self.deductionHeight + 64;

                 }
             }
         }
         
     }
}






- (void)appleLoginAction{
    if (self.button_check.selected == NO) {
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.contentView makeToast:@"未勾选协议" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 20;
     self.signInStyle = SignInStyle_Apple;

    if(self.thirdLoginAction){
        self.thirdLoginAction(button);
    }
}

- (void)setLKSuperView:(UIView *)superView{
    self.contentView = superView;
}

- (IBAction)getCheckCode:(UIButton *)sender {
    
    
    if (self.switchIndex == 20) { // 获取验证码
        if (self.textfield_iphone.text.exceptNull == nil) {
            [self endEditing:YES];
//            [self.contentView.superview makeToast:@"手机号码不能为空"];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.contentView makeToast:@"手机号码不能为空" duration:2 position:CSToastPositionCenter style:style];
            return;
           }

           NSString *randomKey = [NSString stringWithFormat:@"login-%ld",time(0)];
//           [sender startWithScheduledCountDownWithKey:randomKey WithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:[UIColor whiteColor] countColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]];
        
        [sender startWithScheduledCountDownWithKey:randomKey WithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:[UIColor whiteColor] countColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1] complete:^{
            // 倒计时结束
            self.isCountDowning = NO;
        }];
            // 正在倒计时
           self.isCountDowning = YES;
           if (self.getCheckCodeAction) {
               self.getCheckCodeAction(sender);
           }
    }else{ // 忘记密码
        if (self.textfield_iphone.text.exceptNull == nil) {
              [self endEditing:YES];
//            [self.contentView.superview makeToast:@"手机号码不能为空"];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.contentView makeToast:@"手机号码不能为空" duration:2 position:CSToastPositionCenter style:style];
            return;
        }
        
        if (self.forgetPwdAction) {
            self.forgetPwdAction(sender);
        }
    }
    
       
}


- (IBAction)iphoneLogin:(UIButton *)sender {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    if (self.textfield_iphone.text.exceptNull == nil) {
          [self endEditing:YES];
//        [self.contentView.superview makeToast:@"手机号码不能为空"];
        
        [self.contentView makeToast:@"手机号码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.textfield_code.text.exceptNull == nil) {
         [self endEditing:YES];
        
        if(self.switchIndex == 20){
            [self.contentView makeToast:@"验证码不能为空" duration:2 position:CSToastPositionCenter style:style];
        }else{
          
            [self.contentView makeToast:@"密码不能为空" duration:2 position:CSToastPositionCenter style:style];
        }

        return;
    }
    
    if (self.isNewUser == YES && self.view_pwd.hidden == NO && self.textfield_pwd.hidden == NO) {
        if (self.textfield_pwd.text.exceptNull == nil) {
             [self endEditing:YES];
            [self.contentView makeToast:@"密码不能为空" duration:2 position:CSToastPositionCenter style:style];
            return;
        }
    }
    
    if (self.button_check.selected == NO) {
          [self endEditing:YES];
        [self.contentView makeToast:@"未勾选协议" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    
    if (self.switchIndex == 20) {
        self.signInStyle = SignInStyle_Code;
        
    }else{
        self.signInStyle = SignInStyle_PWD;
    }
    
    if (self.iphoneLoginAction) {
        self.iphoneLoginAction(sender,self.signInStyle);
    }
    
}

- (IBAction)switchAction:(UIButton *)sender {
    if (self.button_check.selected == NO) {
          [self endEditing:YES];
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.contentView makeToast:@"未勾选协议" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
  
    if (self.isCountDowning) {
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.contentView makeToast:@"正在获取验证码,请稍后" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (sender.tag == 10) {
        self.switchIndex = sender.tag;
//        self.textfield_code.text = @"";
        [self updatePasswordView];

    }else{
        self.switchIndex = sender.tag;
//        self.textfield_code.text = @"";
        [self updateCodeView];
        
       
    }
    
    if (self.switchAction) {
        self.switchAction(sender);
    }
    
}



- (void)updatePasswordView{
    self.button_pwd.backgroundColor = [UIColor colorWithRed:222/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    [self.button_pwd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.button_code.backgroundColor = [UIColor whiteColor];
    [self.button_code setTitleColor:[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1] forState:UIControlStateNormal];
     self.textfield_code.keyboardType = UIKeyboardTypeDefault;
    self.textfield_code.placeholder = @"请输入密码";
      self.textfield_code.secureTextEntry = YES;
    [self.button_get_code setTitle:@"忘记密码" forState:UIControlStateNormal];
    
    LKUser *user = [LKUser getUser];
    if (user != nil) {
       NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERPASSWORD"];
         NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERPHONE"];
        if (phone.exceptNull != nil && password.exceptNull != nil) {
            self.textfield_iphone.text = phone;
            self.textfield_code.text  = password;
            self.switchIndex = 10;
        }
    }
}

- (void)updateCodeView{
    self.button_code.backgroundColor = [UIColor colorWithRed:222/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    [self.button_code setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.button_pwd.backgroundColor = [UIColor whiteColor];
    [self.button_pwd setTitleColor:[UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1] forState:UIControlStateNormal];
     self.textfield_code.keyboardType = UIKeyboardTypeNumberPad;
    self.textfield_code.placeholder = @"请输入验证码";
    self.textfield_code.secureTextEntry = NO;
     [self.button_get_code setTitle:@"获取验证码" forState:UIControlStateNormal];
}



- (IBAction)checkProtocol:(UIButton *)sender {
    
    if (self.button_check.isSelected) {
        [self.button_check setBackgroundImage:[UIImage lk_ImageNamed:@"frame"] forState:UIControlStateNormal];
        
    }else{
        [self.button_check setBackgroundImage:[UIImage lk_ImageNamed:@"checkmark"] forState:UIControlStateNormal];
    }

    self.button_check.selected = !sender.selected;
}

- (IBAction)readProtocol:(UIButton *)sender {
    if (self.readProtocolAction) {
        self.readProtocolAction(sender);
    }
}

- (IBAction)thirdLogin:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
            self.signInStyle = SignInStyle_Quick;
            break;
        case 20:
            self.signInStyle = SignInStyle_Apple;
            break;
        case 30:
            
            break;
        case 40:
            
            break;
        default:
            break;
    }
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    if (self.button_check.selected == NO) {
          [self endEditing:YES];
        [self.contentView makeToast:@"未勾选协议" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    
    if(self.thirdLoginAction){
        self.thirdLoginAction(sender);
    }
}

- (IBAction)closeAlterViewAction:(UIButton *)sender {
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}

- (IBAction)useAgreementAction:(UIButton *)sender {
    
    if (self.useAgreementCallBack) {
        self.useAgreementCallBack(self.button_check.isSelected,sender);
    }
    
}

- (void)showButtonLogin{
    if (self.button_login.hidden == NO) {
        return;
    }
     self.startRealHeight = self.startRealHeight + 40 + 20;
     self.button_login.hidden = NO;
     self.layout_login_height.constant = 40;
    self.layout_login_top.constant = 20;
}

- (void)hiddenButtonLogin{
     self.button_login.hidden = YES;
      self.layout_login_height.constant = 0;
      self.layout_login_top.constant = 0;
}

- (void)showViewPassword{
    if (self.view_pwd.hidden == NO) {
        return;
    }
     self.startRealHeight = self.startRealHeight + 40 + 5;
     self.view_pwd.hidden = NO;
     self.label_pwd.hidden = NO;
     self.view_pwd_line_one.hidden = NO;
     self.view_pwd_line_two.hidden = NO;
     self.textfield_pwd.hidden = NO;
     self.layout_pwd_height.constant = 40;
     self.layout_pwd_top.constant = 5;
}



- (void)hiddenViewPasswordIsInitState:(BOOL)state{
    
    if (self.view_pwd.hidden == YES) { // 如果已经隐藏状态直接返回否则会累计
        return;
    }
    if (state == NO) {
        self.startRealHeight = self.startRealHeight - 40 - 5;
    }
     self.view_pwd.hidden = YES;
     self.label_pwd.hidden = YES;
     self.view_pwd_line_one.hidden = YES;
     self.view_pwd_line_two.hidden = YES;
     self.textfield_pwd.hidden = YES;
     self.layout_pwd_height.constant = 0;
     self.layout_pwd_top.constant = 0;
}

- (void)showViewChechView{
    if (self.view_checkCode.hidden == NO) {
        return;
    }
     self.startRealHeight = self.startRealHeight + 40 + 5;
     self.view_checkCode.hidden = NO;
     self.view_checkout_line_one.hidden = NO;
     self.view_checkout_line_two.hidden = NO;
     self.textfield_code.hidden = NO;
     self.layout_checkCode_height.constant = 40;
     self.layout_checkCode_top.constant = 5;
     self.button_code.hidden = NO;
}




- (void)hiddenViewChechView{
    self.view_checkCode.hidden = YES;
    self.view_checkout_line_one.hidden = YES;
    self.view_checkout_line_two.hidden = YES;
    self.textfield_code.hidden = YES;
    self.layout_checkCode_height.constant = 0;
    self.layout_checkCode_top.constant = 0;
    self.button_code.hidden = YES;
    
}


- (void)showViewIphone{
    if (self.view_phone.hidden == NO) {
        return;
    }
    self.view_phone.hidden = NO;
    self.view_phone_line_one.hidden = NO;
    self.view_phone_line_two.hidden = NO;
    self.textfield_iphone.hidden = NO;
    self.layout_phone_height.constant = 40;
}

- (void)hiddenViewIphone{
    self.view_phone.hidden = YES;
    self.view_phone_line_one.hidden = YES;
    self.view_phone_line_two.hidden = YES;
    self.textfield_iphone.hidden = YES;
    self.layout_phone_height.constant = 0;
}
- (void)hiddenAppleView{
    self.view_third_oauth.hidden = YES;
    self.view_apple.hidden = YES;
    self.layout_third_oauth_height.constant = 0;
    self.layout_third_oauth_height_top.constant = 0;
}
@end

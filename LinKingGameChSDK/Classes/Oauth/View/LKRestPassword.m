

#import "LKRestPassword.h"
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
@interface LKRestPassword ()
@property (nonatomic,weak) UIView *contentView;
@end

@implementation LKRestPassword


+ (instancetype)instanceRestPasswordView{
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKRestPassword *view = [[bundle loadNibNamed:@"LKRestPassword" owner:nil options:nil] firstObject];
    view.button_getCode.layer.borderColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1].CGColor;
    view.button_getCode.layer.borderWidth = 1;
    view.button_getCode.layer.cornerRadius = 8;
    view.button_getCode.clipsToBounds = YES;
    
    view.textfield_newPassword.secureTextEntry = YES;
    view.textfield_surePassword.secureTextEntry = YES;
    view.textfield_surePassword.clearButtonMode = UITextFieldViewModeAlways;
    view.textfield_newPassword.clearButtonMode = UITextFieldViewModeAlways;
       
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    
    return view;
}
- (void)setLKSuperView:(UIView *)superView;{
    self.contentView = superView;
}
- (IBAction)getCheckCode:(UIButton *)sender {
    
    if (self.textfield_iphone.text.exceptNull == nil) {
         [self endEditing:YES];
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.contentView makeToast:@"手机号码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    NSString *randomKey = [NSString stringWithFormat:@"fix-%ld",time(0)];
    [sender startWithScheduledCountDownWithKey:randomKey WithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:[UIColor whiteColor] countColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]];
    
    if (self.getCheckCodeAction) {
        self.getCheckCodeAction(sender);
    }
    
}

- (IBAction)sureFix:(id)sender {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    if (self.textfield_iphone.text.exceptNull == nil) {
         [self endEditing:YES];


        [self.contentView makeToast:@"手机号码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.textfield_code.text.exceptNull == nil) {
         [self endEditing:YES];

        [self.contentView makeToast:@"验证码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.textfield_newPassword.text.exceptNull == nil) {
         [self endEditing:YES];
        [self.contentView makeToast:@"新密码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.textfield_surePassword.text.exceptNull == nil) {
         [self endEditing:YES];
        [self.contentView makeToast:@"确认密码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    
    if (![self.textfield_newPassword.text isEqualToString:self.textfield_surePassword.text]) {
         [self endEditing:YES];
        [self.contentView makeToast:@"两次密码不一致" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.fixPasswordAction) {
        self.fixPasswordAction(sender);
    }
    
    
 
}
- (IBAction)closeAction:(id)sender {
    
    if (self.closeView) {
        self.closeView(sender);
    }
}
- (IBAction)fixPassword:(UIButton *)sender {
    
    if (self.fixPasswordCallBack) {
        self.fixPasswordCallBack(sender);
    }
    
}


@end

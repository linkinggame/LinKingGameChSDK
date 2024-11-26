

#import "LKFixPasswordView.h"
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
@interface LKFixPasswordView ()
@property (nonatomic,weak) UIView *contentView;
@end
@implementation LKFixPasswordView


+ (instancetype)instanceFixPasswordView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKFixPasswordView *view = [[bundle loadNibNamed:@"LKFixPasswordView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.textfield_oldPassword.clearButtonMode = UITextFieldViewModeAlways;
    view.textfield_newPassword.clearButtonMode = UITextFieldViewModeAlways;
    view.testfield_surePassword.clearButtonMode = UITextFieldViewModeAlways;
    view.textfield_oldPassword.secureTextEntry = YES;
    view.textfield_newPassword.secureTextEntry = YES;
    view.testfield_surePassword.secureTextEntry = YES;
    view.clipsToBounds = YES;
    
    
    return view;
}

- (void)setLKSuperView:(UIView *)superView{
    self.contentView = superView;
}

- (IBAction)surePasswordAction:(UIButton *)sender {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    
    if (self.textfield_oldPassword.text.exceptNull == nil) {
         [self endEditing:YES];
//        [self.contentView makeToast:@"原始密码不能为空"];
        [self.contentView makeToast:@"原始密码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    if (self.textfield_newPassword.text.exceptNull == nil) {
         [self endEditing:YES];
//        [self.contentView makeToast:@"新密码不能为空"];
        [self.contentView makeToast:@"新密码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (![self.textfield_newPassword.text isEqualToString:self.testfield_surePassword.text]) {
         [self endEditing:YES];
//        [self.contentView makeToast:@"新密码与确认密码不一致"];
        [self.contentView makeToast:@"新密码与确认密码不一致" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.surePasswordCallBack) {
        self.surePasswordCallBack();
    }
    
}

- (IBAction)restPasswordAction:(UIButton *)sender {
    if (self.restPasswordCallBack) {
        self.restPasswordCallBack();
    }
}

- (IBAction)closeAlterViewAction:(UIButton *)sender {
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}

@end

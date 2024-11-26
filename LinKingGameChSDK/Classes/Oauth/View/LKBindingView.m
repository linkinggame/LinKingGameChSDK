

#import "LKBindingView.h"
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
@interface LKBindingView ()
@property (nonatomic,weak) UIView *contentView;
@end

@implementation LKBindingView

+ (instancetype)instanceBindingView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKBindingView *view = [[bundle loadNibNamed:@"LKBindingView" owner:nil options:nil] firstObject];
    view.button_getCode.layer.borderColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1].CGColor;
    view.button_getCode.layer.borderWidth = 1;
    view.button_getCode.layer.cornerRadius = 8;
    view.button_getCode.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    
    return view;
}

- (void)setLKSuperView:(UIView *)superView{
    self.contentView = superView;
}

- (IBAction)selectItemAction:(UIButton *)sender {
    
    if (self.selectItemCallBack) {
        self.selectItemCallBack(sender);
    }
    
    if (sender.tag == 10) {

    }else if (sender.tag == 20){
        self.bindingStyle = BinDingStyle_Apple;
    }
}
- (IBAction)bindingAction:(id)sender {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    if (self.textfield_iphone.text.exceptNull == nil) {
        [self endEditing:YES];
//        [self.contentView makeToast:@"手机号码不能为空"];
    
        [self.contentView makeToast:@"手机号码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.textfield_code.text.exceptNull == nil) {
        [self endEditing:YES];
//        [self.contentView makeToast:@"验证码不能为空"];
        [self.contentView makeToast:@"验证码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.bindingCallBack) {
        self.bindingCallBack(sender,self.textfield_iphone.text,self.textfield_code.text);
    }
    self.bindingStyle = BinDingStyle_Iphone;
    
}

- (IBAction)closeAction:(id)sender {
    if (self.closeAlterViewCallback) {
        self.closeAlterViewCallback(sender);
    }
}
- (IBAction)getCheckCode:(UIButton *)sender {
    
    if (self.textfield_iphone.text.exceptNull == nil) {
        [self endEditing:YES];
//        [self.contentView makeToast:@"手机号码不能为空"];
        
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.contentView makeToast:@"手机号码不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    NSString *randomKey = [NSString stringWithFormat:@"binding-%ld",time(0)];
    [sender startWithScheduledCountDownWithKey:randomKey WithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:[UIColor whiteColor] countColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]];
    if (self.getCheckCodeCallBack) {
        self.getCheckCodeCallBack(sender,self.textfield_iphone.text);
    }
    
}


@end

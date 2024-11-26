

#import "LKRealNameView.h"
#import "LKUser.h"
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
@interface LKRealNameView ()
@property (nonatomic,weak) UIView *contentView;
@end
@implementation LKRealNameView

+ (instancetype)instanceRealNameView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKRealNameView *view = [[bundle loadNibNamed:@"LKRealNameView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    view.textfield_name.clearButtonMode = UITextFieldViewModeAlways;
    view.textfield_code.clearButtonMode = UITextFieldViewModeAlways;
    view.button_auth.layer.cornerRadius = 5;
    view.button_auth.clipsToBounds = YES;
    [view.button_auth setBackgroundColor:[UIColor colorWithRed:225/255.0 green:83/255.0 blue:83/255.0 alpha:1]];
    return view;
}

- (void)setLKSuperView:(UIView *)superView{
    self.contentView = superView;
}

- (IBAction)realAuthAction:(UIButton *)sender {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];

    
    
    if (self.textfield_code.text.length == 15 || self.textfield_code.text.length == 18 ) {
        if (self.textfield_name.text.exceptNull == nil) {
             [self endEditing:YES];
            [self.contentView makeToast:@"真实姓名不能为空" duration:2 position:CSToastPositionCenter style:style];
            return;
        }
        
        if (self.textfield_code.text.exceptNull == nil) {
             [self endEditing:YES];
            [self.contentView makeToast:@"身份证号不能为空" duration:2 position:CSToastPositionCenter style:style];
            return;
        }
        
        if (self.authAction) {
            self.authAction(sender,self.textfield_name.text,self.textfield_code.text);
        }
    }else{
        [self endEditing:YES];
        [self.contentView makeToast:@"请输入合法的身份证号" duration:2 position:CSToastPositionCenter style:style];
    }
    
    
    
}

- (IBAction)closeAction:(id)sender {
    
    if (self.closeAlterViewAction) {
        self.closeAlterViewAction(sender);
    }
}

@end

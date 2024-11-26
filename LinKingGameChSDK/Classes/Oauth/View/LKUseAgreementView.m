

#import "LKUseAgreementView.h"
#import "LKGlobalConf.h"
#import "NSBundle+LKResources.h"
#import "UIImage+LKAdditions.h"
@interface LKUseAgreementView ()

@end

@implementation LKUseAgreementView

+ (instancetype)instanceUseAgreementView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKUseAgreementView *view = [[bundle loadNibNamed:@"LKUseAgreementView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    
    view.label_agree.text = @"我已阅读并同意";
    return view;
}
- (IBAction)checkBox:(UIButton *)sender {
     if (self.button_checkBox.isSelected) {
        [self.button_checkBox setBackgroundImage:[UIImage lk_ImageNamed:@"frame"] forState:UIControlStateNormal];
      }else{
         [self.button_checkBox setBackgroundImage:[UIImage lk_ImageNamed:@"checkmark"] forState:UIControlStateNormal];
      }
     self.button_checkBox.selected = !sender.selected;
}
- (IBAction)sureAction:(id)sender {
    if (self.sureCallBack) {
        self.sureCallBack(self.button_checkBox.isSelected);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

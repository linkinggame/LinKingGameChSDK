

#import "LKBindingAccountTipView.h"

@implementation LKBindingAccountTipView

+ (instancetype)instanceBindingAccountTipView{
    
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKBindingAccountTipView *view = [[bundle loadNibNamed:@"LKBindingAccountTipView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    return view;
}
- (IBAction)closeAlterViewAction:(id)sender {
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}


- (IBAction)quickGameAction:(UIButton *)sender {
    if (self.quickGameCallBack) {
        self.quickGameCallBack();
    }
    
}
- (IBAction)bindingAccountAction:(UIButton *)sender {
    if (self.bindingAcccountCallBack) {
        self.bindingAcccountCallBack();
    }
    
}


@end

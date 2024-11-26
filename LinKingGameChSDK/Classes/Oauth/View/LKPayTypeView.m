

#import "LKPayTypeView.h"
#import "LKSDKConfig.h"

@implementation LKPayTypeView

+ (instancetype)instancePayTypeView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKPayTypeView *view = [[bundle loadNibNamed:@"LKPayTypeView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    view.label_name.adjustsFontSizeToFitWidth = YES;
    view.label_price.adjustsFontSizeToFitWidth = YES;
    view.label_game_orderNum.adjustsFontSizeToFitWidth = YES;
   LKSDKConfig *configSDK = [LKSDKConfig getSDKConfig];
    
    if ([configSDK.pay_type isEqualToString:@"ios"]) {
        view.view_left.hidden = YES;
        view.view_right.hidden = YES;
    }else{
        view.view_left.hidden = NO;
        view.view_right.hidden = NO;
    }
    return view;
}

- (IBAction)payStyleAction:(UIButton *)sender {
    
    if (self.selectPayTypeCallBack) {
        self.selectPayTypeCallBack(sender);
    }
    
    
}
- (IBAction)closeAction:(id)sender {
    
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}

@end

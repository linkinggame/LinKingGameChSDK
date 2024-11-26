

#import "LKCrazyTipView.h"

@implementation LKCrazyTipView

+ (instancetype)instanceCrazyTipView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKCrazyTipView *view = [[bundle loadNibNamed:@"LKCrazyTipView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    return view;
}

- (IBAction)closeAlterViewAction:(UIButton *)sender {
    
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
    
}

@end

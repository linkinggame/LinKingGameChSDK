

#import "LKPayResultView.h"

@implementation LKPayResultView

+ (instancetype)instancePayResultView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKPayResultView *view = [[bundle loadNibNamed:@"LKPayResultView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    return view;
}

- (IBAction)closeAction:(id)sender {
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}

@end

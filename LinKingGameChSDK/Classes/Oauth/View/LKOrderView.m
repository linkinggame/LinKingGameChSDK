

#import "LKOrderView.h"
#import "LKOrderTableView.h"
@interface LKOrderView ()

@end

@implementation LKOrderView

+ (instancetype)instanceOrderView{
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKOrderView *view = [[bundle loadNibNamed:@"LKOrderView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    return view;
}
- (IBAction)downAction:(UIButton *)sender {
    
    if (self.selectDateCallBack) {
        self.selectDateCallBack(sender);
    }
    
}
- (IBAction)closeAction:(UIButton *)sender {
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack(sender);
    }
}

@end

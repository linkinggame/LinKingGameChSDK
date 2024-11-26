

#import "LKIssueStyleView.h"
#import "LKIssueStyleTableView.h"
@implementation LKIssueStyleView

+ (instancetype)instanceIssueStyleView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKIssueStyleView *view = [[bundle loadNibNamed:@"LKIssueStyleView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    return view;
}
- (IBAction)closeAlterViewAction:(id)sender {
    
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}

@end

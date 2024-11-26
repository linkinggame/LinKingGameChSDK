

#import "LKIssueServiceView.h"
#import "LKIssueServiceTableView.h"
@implementation LKIssueServiceView

+ (instancetype)instanceIssueServiceView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKIssueServiceView *view = [[bundle loadNibNamed:@"LKIssueServiceView" owner:nil options:nil] firstObject];
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

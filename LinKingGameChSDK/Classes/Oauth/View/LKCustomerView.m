

#import "LKCustomerView.h"

@implementation LKCustomerView

+ (instancetype)instanceCustomerView{
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKCustomerView *view = [[bundle loadNibNamed:@"LKCustomerView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    return view;
}

- (IBAction)onlineCommitQuestionAction:(UIButton *)sender {
    
    if (self.commitIssueCallBack) {
        self.commitIssueCallBack();
    }
}

- (IBAction)readQuestionAction:(UIButton *)sender {
    
    if (self.readIssueCallBack) {
        self.readIssueCallBack();
    }
}

- (IBAction)customerAction:(UIButton *)sender {
    if (self.copyCustomerIdCallBack) {
        self.copyCustomerIdCallBack();
    }
}

- (IBAction)closeAlterViewAction:(UIButton *)sender {
    
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}


@end

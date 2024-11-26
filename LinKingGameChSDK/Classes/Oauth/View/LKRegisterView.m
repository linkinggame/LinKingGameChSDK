

#import "LKRegisterView.h"

@implementation LKRegisterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)instanceRegisterView{
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKRegisterView *view = [[bundle loadNibNamed:@"LKRegisterView" owner:nil options:nil] firstObject];
    
  
    
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    
    return view;
}

- (IBAction)closeAlterViewAction:(id)sender {
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}
- (IBAction)skipAction:(id)sender {
    if (self.skipCallBack) {
        self.skipCallBack();
    }
}
- (IBAction)registerAction:(id)sender {
    if (self.registerCallBack) {
        self.registerCallBack();
    }
}

@end

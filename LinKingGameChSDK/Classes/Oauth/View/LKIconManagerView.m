

#import "LKIconManagerView.h"


@interface LKIconManagerView ()

@end

@implementation LKIconManagerView

+ (instancetype)instanceIconManagerView{
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKIconManagerView *view = [[bundle loadNibNamed:@"LKIconManagerView" owner:nil options:nil] firstObject];

    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    
    view.button_cancel.layer.borderColor = [UIColor colorWithRed:116/255.0 green:113/255.0 blue:116/255.0 alpha:1].CGColor;
    view.button_cancel.layer.borderWidth = 1;
    view.button_cancel.layer.cornerRadius = 5;
    view.button_cancel.clipsToBounds = YES;
    view.button_sure.layer.borderColor = [UIColor colorWithRed:82/255.0 green:162/255.0 blue:247/255.0 alpha:1].CGColor;
    view.button_sure.layer.borderWidth = 1;
    view.button_sure.layer.cornerRadius = 5;
    view.button_sure.clipsToBounds = YES;
    
    
    view.view_icon.layer.cornerRadius = 69 * 0.5;
    view.view_icon.clipsToBounds = YES;
    return view;
}


- (IBAction)closeAction:(id)sender {
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack(sender);
    }
}


- (IBAction)cancelAction:(id)sender {
    if (self.cancelCallBack) {
        self.cancelCallBack(sender);
    }
}

- (IBAction)sureAction:(id)sender {
    if (self.sureCallBack) {
        self.sureCallBack(sender);
    }
}



@end

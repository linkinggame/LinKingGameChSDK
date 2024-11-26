
#import "LKRegisterController.h"
#import "LKRegisterView.h"
@interface LKRegisterController ()

@end

@implementation LKRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showRegisterView];
 
}
- (void)showRegisterView{

    LKRegisterView *registerView = [LKRegisterView instanceRegisterView];
    [self.view insertSubview:registerView atIndex:self.view.subviews.count];
    registerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:registerView];
    CGFloat width = 300;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:192];
    [self layoutConstraint];
    
    
    
    registerView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    registerView.skipCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    registerView.registerCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:^{
            [self registerAction];
        }];
        
    };
    
}

- (void)registerAction{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthenticationTip" object:@"show"];
}

@end

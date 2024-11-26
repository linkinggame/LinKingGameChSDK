

#import "LKBindingTipController.h"
#import "LKBindingAccountTipView.h"
#import "LKAlterLoginApi.h"
@interface LKBindingTipController ()

@end

@implementation LKBindingTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBindingAccountTipView];
}
- (void)showBindingAccountTipView{

    LKBindingAccountTipView *bindingAccountTipView = [LKBindingAccountTipView instanceBindingAccountTipView];
    [self.view insertSubview:bindingAccountTipView atIndex:self.view.subviews.count];
    bindingAccountTipView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:bindingAccountTipView];
    CGFloat width = 300;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:182];
    [self layoutConstraint];
    
    
    bindingAccountTipView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    bindingAccountTipView.quickGameCallBack = ^{
        [self quickGame];
    };
    
    bindingAccountTipView.bindingAcccountCallBack = ^{
        [self bindingAccount];
    };
    
}


- (void)quickGame{
//    [LKAlterLoginApi quickLoginComplete:^(NSError * _Nonnull error) {
//           if (error == nil) {
//               [self dismissViewControllerAnimated:NO completion:nil];
//           }else{
//               [self.view makeToast:error.localizedDescription];
//           }
//       }];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)bindingAccount{
    
    [self dismissViewControllerAnimated:NO completion:^{
         [[NSNotificationCenter defaultCenter] postNotificationName:@"BindingAccount" object:nil];
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

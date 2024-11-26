

#import "LKFixPwdViewController.h"
#import "LKFixPasswordView.h"
#import "LKPasswordApi.h"
#import "LKGlobalConf.h"
#import <Toast/Toast.h>
@interface LKFixPwdViewController ()
@property (nonatomic, strong)   LKFixPasswordView *fixPasswordView;
@property (nonatomic, strong)  NSArray *constraints;
@property (nonatomic) UIDeviceOrientation orientation;
@end

#define WIDTH 339
#define HEIGHT 318

@implementation LKFixPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    [self showFixPwdView];
}

- (void)showFixPwdView{

   LKFixPasswordView *fixPasswordView = [LKFixPasswordView instanceFixPasswordView];
    self.fixPasswordView = fixPasswordView;
    //self.fixPasswordView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    //self.fixPasswordView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 310);
    [self.view insertSubview:fixPasswordView atIndex:self.view.subviews.count];
    
    fixPasswordView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setAlterWidth:300];
    [self setAlterHeight:318];
    [self setAlterContentView:fixPasswordView];
    
    [self layoutConstraint];

    [fixPasswordView setLKSuperView:self.view];
    

    
   fixPasswordView.closeAlterViewCallBack = ^{
       [self dismissViewControllerAnimated:NO completion:^{
          
           [[NSNotificationCenter defaultCenter] postNotificationName:@"FixPasswordClose" object:nil];
       }];
    };
    
    fixPasswordView.surePasswordCallBack = ^{
        [self sureFixPassword];
    };
    
    
    fixPasswordView.restPasswordCallBack = ^{
      
        [self dismissViewControllerAnimated:NO completion:^{
           
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RestPassword" object:nil];
        }];
    };
    
}

- (void)sureFixPassword{

    [LKPasswordApi fixPasswordWithOldPassword:self.fixPasswordView.textfield_oldPassword.text newPassword:self.fixPasswordView.textfield_newPassword.text complete:^(NSError * _Nonnull error) {
      
        if (error == nil) {
            [self dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FixPasswordClose" object:nil];
            }];
        }else{
            [self.view makeToast:error.localizedDescription];
        }
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

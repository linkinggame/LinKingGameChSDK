

#import "LKRestPwdViewController.h"
#import "LKRestPassword.h"
#import "LKPasswordApi.h"
#import "LKGlobalConf.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>

@interface LKRestPwdViewController ()
@property (nonatomic, strong) LKRestPassword * restPasswordView;
@end

@implementation LKRestPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showRestPwdView];
    
}



#pragma mark -- 获取验证码
- (void)getCheckCode:(NSString *)iphone{
    
    [LKPasswordApi fetchRestPwdCheckCodeByPhone:iphone isNewUserComplete:^(NSError * _Nonnull error) {

        if (error == nil) {
            
        }
    }];
}


#pragma mark -- 修改密码
- (void)fixPassword:(NSString *)iphone code:(NSString *)code nPwd:(NSString *)nPwd sPwd:(NSString *)sPwd{
    
    [LKPasswordApi resetPasswordWithIphone:iphone code:code newPassword:nPwd surePassword:sPwd complete:^(NSError * _Nonnull error) {
        
        if (error == nil) {
            [self dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RestPasswordClose" object:nil];
            }];
        }else{
//            [self.view makeToast:error.localizedDescription];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
        }
        
    }];
}



- (void)showRestPwdView{

    
    LKRestPassword *restPasswordView = [LKRestPassword instanceRestPasswordView];
    [self.view insertSubview:restPasswordView atIndex:self.view.subviews.count];
    self.restPasswordView = restPasswordView;
    restPasswordView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:restPasswordView];
    
    CGFloat width = 300;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:344];
    [self layoutConstraint];
    
    [restPasswordView setLKSuperView:self.view];
    
   
   __weak typeof(self)weakSelf = self;
    /// 获取验证码
    restPasswordView.getCheckCodeAction = ^(UIButton * _Nonnull sender) {
        NSString *phone = weakSelf.restPasswordView.textfield_iphone.text;
        [weakSelf getCheckCode:phone];
    };
    /// 修改密码
    restPasswordView.fixPasswordAction = ^(UIButton * _Nonnull sender) {
        NSString *phone = weakSelf.restPasswordView.textfield_iphone.text;
        NSString *code = weakSelf.restPasswordView.textfield_code.text;
        NSString *newPassword = weakSelf.restPasswordView.textfield_newPassword.text;
        NSString *surePassword = weakSelf.restPasswordView.textfield_newPassword.text;
        [weakSelf fixPassword:phone code:code nPwd:newPassword sPwd:surePassword];
    };
    
    
    restPasswordView.closeView = ^(UIButton * _Nonnull sender) {
      
        [self dismissViewControllerAnimated:NO completion:^{
           
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RestPasswordClose" object:nil];
        }];
    };
    
    restPasswordView.fixPasswordCallBack = ^(UIButton * _Nonnull sender) {
      
        [self dismissViewControllerAnimated:NO completion:^{
           
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FixPassword" object:nil];
        }];
        
    };
    
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



#import "LKWecomeViewController.h"
#import "LKWelcomeView.h"
#import "LKAlterLoginApi.h"
#import "LKUser.h"
#import "LKPointManager.h"
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
#import "LKRealNameVerifyFactory.h"
#import "LKControlUtil.h"
@interface LKWecomeViewController ()
@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) LKWelcomeView *wecomeView;
 
@end

@implementation LKWecomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showWecomeView];
    self.isChange = NO;
    /// 延迟处理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isChange == NO) {
            self.wecomeView.button_change_account.userInteractionEnabled = NO;
             [self autoLogin];
        }
       
    });
  
}


#pragma mark -- 自动登录
- (void)autoLogin{

    [LKAlterLoginApi autoLoginComplete:^(NSError * _Nonnull error) {
         self.wecomeView.button_change_account.userInteractionEnabled = YES;
        [self basePoint];
         LKUser *user = [LKUser getUser];
        if (error == nil) {
            [self dismissViewControllerAnimated:NO completion:^{
              
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:user];
      
                if ( [user.login_type isEqualToString:@"Phone"] || [user.login_type isEqualToString:@"Ios"]  ) {
                    if ([[LKRealNameVerifyFactory createRealNameVerify] isRealName] == NO) {
                        // 防沉迷控制
                        if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthenticationCanClose" object:nil];
                        }else{
                            if (self.loginCompleteCallBack) {
                                self.loginCompleteCallBack(user, error);
                            }
                        }
                        
                    }else{
                        if (self.loginCompleteCallBack) {
                            self.loginCompleteCallBack(user, error);
                        }
                    }
                    
                }else{
                    if (self.loginCompleteCallBack) {
                        self.loginCompleteCallBack(user, error);
                    }
                }
            }];
        }else{
            [self dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AutoLoginFail" object:error];
            }];
            if (self.loginCompleteCallBack) {
                self.loginCompleteCallBack(nil, error);
            }
        }
    }];

}


- (void)changeAccount{
    self.isChange = YES;
    [self dismissViewControllerAnimated:NO completion:^{
           [[NSNotificationCenter defaultCenter] postNotificationName:@"WecomeChangeAccount" object:nil];
    }];
}


- (void)showWecomeView{

    LKWelcomeView *wecomeView = [LKWelcomeView instanceWecomeView];
    [self.view insertSubview:wecomeView atIndex:self.view.subviews.count];
    self.wecomeView = wecomeView;
    wecomeView.translatesAutoresizingMaskIntoConstraints = NO;
    
     CGFloat width = 300;
      CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
      if (width > screen_width) {
          width = screen_width - 40;
      }

    [self setAlterContentView:wecomeView];
    [self setAlterHeight:353];
    [self setAlterWidth:width];
    [self layoutConstraint];
    
    
    // 切换账号
    wecomeView.changeAccountAction = ^(UIButton * _Nonnull sender) {
        [self changeAccount];
    };
    
    
    
}
#pragma mark -- 打点
- (void)basePoint{
    // 打点
    //[[LKPointManager shared] standardLogEventName:@"Login" complete:nil];
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

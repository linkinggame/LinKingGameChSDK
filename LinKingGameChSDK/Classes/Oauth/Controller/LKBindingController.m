

#import "LKBindingController.h"
#import "LKBindingView.h"
#import "LKBindingApi.h"
#import "LKAlterLoginApi.h"
#import "LKSignInApple.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "LKAlterLoginApi.h"
#import "LKUser.h"
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
#import "MMMaterialDesignSpinner.h"
@interface LKBindingController ()
@end

@implementation LKBindingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBindingView];
    
}

- (void)showBindingView{
    
    LKBindingView *bindingView  = [LKBindingView instanceBindingView];
    [self.view insertSubview:bindingView atIndex:self.view.subviews.count];
   // 使用autoLayout约束，禁止将AutoresizingMask转换为约束
    bindingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:bindingView];

    CGFloat width = 320;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:340];
    [self layoutConstraint];

    [bindingView setLKSuperView:self.view];

    bindingView.closeAlterViewCallback = ^(UIButton * _Nonnull sender) {
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    bindingView.getCheckCodeCallBack = ^(UIButton * _Nonnull sender, NSString * _Nonnull phone) {
      
        [self getCheckCode:phone];
    };
    
    
    bindingView.bindingCallBack = ^(UIButton * _Nonnull sender, NSString * _Nonnull phone, NSString * _Nonnull code) {
       [self bindingAcctount:@"Phone" token:code phone:phone];
    };
    
    
    
    bindingView.selectItemCallBack = ^(UIButton * _Nonnull sender) {
        if (sender.tag == 10) { // apple
            [self appleLoginBinding];
        }else if (sender.tag == 20){
            [self appleLoginBinding];
        }
    };
    
}


#pragma mark -- apple 登录
- (void)appleLoginBinding{

      // 登录失败
     
      /**
       ASAuthorizationErrorUnknown = 1000,
       ASAuthorizationErrorCanceled = 1001,
       ASAuthorizationErrorInvalidResponse = 1002,
       ASAuthorizationErrorNotHandled = 1003,
       ASAuthorizationErrorFailed = 1004,
       */
        // 登录失败
        [LKSignInApple instance].didCompleteWithError = ^(NSError * _Nonnull error) {
            
            NSError *errRes = nil;
            
            if (@available(iOS 13.0, *)) {
                
                if (error.code == ASAuthorizationErrorCanceled) { // 用户取消了登录
                    errRes = [self responserErrorMsg:@"取消登陆" code:1001];
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCancel" object:@"apple"];
                    if (self.appleLoginCallBack) {
                        self.appleLoginCallBack(errRes);
                    }
//                    [self.view makeToast:@"取消登录"];
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                    [self.view makeToast:@"取消登录" duration:2 position:CSToastPositionCenter style:style];
                }else{
                    errRes = [self responserErrorMsg:@"登录失败" code:1004];
                    if (self.appleLoginCallBack) {
                        self.appleLoginCallBack(errRes);
                    }
                }
                if (self.bindingAccountCompleteCallBack) {
                    self.bindingAccountCompleteCallBack(nil, errRes);
                }

            } else {
                // Fallback on earlier versions
               
            }
        };
      
      // 登录成功
      [LKSignInApple instance].didCompleteWithAuthorization = ^(NSInteger type, NSString * _Nullable user, NSString * _Nullable token, NSString * _Nullable code, NSString * _Nullable password) {
          if (type == 1) { //appID 登录
              // 发起请求
              [self bindingAcctount:@"Ios" token:token phone:nil];
          
          }else{// 账号密码登录
          }
          
          
      };

    [[LKSignInApple instance] loginAppleWithComplete:^(BOOL success) {
        if (success == NO) {
//            [self.view makeToast:@"系统版本过低，请先升级，继续使用Sign In With Apple"];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:@"系统版本过低，请先升级，继续使用Sign In With Apple" duration:2 position:CSToastPositionCenter style:style];
        }
    }];
    
}


#pragma mark -- 获取验证码
- (void)getCheckCode:(NSString *)phone{
    
    [LKAlterLoginApi fetchCheckCodeBindingByPhone:phone complete:^(NSError * _Nonnull error) {
        if (error != nil) {
//             [self.view makeToast:error.localizedDescription];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
        }
    }];
}


- (void)bindingAcctount:(NSString *)style token:(NSString *)token phone:(NSString *)phone{
    if (![style isEqualToString:@"Ios"]) {
        [self showMaskView];
    }
    [LKBindingApi bindAccountWithType:style phone:phone thirdToken:token complete:^(NSError * _Nonnull error) {
        LKUser*user =  [LKUser getUser];
        if (self.bindingAccountCompleteCallBack) {
            self.bindingAccountCompleteCallBack(user, error);
        }
        if (error == nil) {
//            [self.view makeToast:@"绑定成功"];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:@"绑定成功" duration:2 position:CSToastPositionCenter style:style];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hiddenMaskView];
                [self dismissViewControllerAnimated:NO completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BindingSuccess" object:nil];
                }];
            });
            

            
        }else{
            [self hiddenMaskView];
//            [self.view makeToast:error.localizedDescription];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BindingSuccess" object:error];
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

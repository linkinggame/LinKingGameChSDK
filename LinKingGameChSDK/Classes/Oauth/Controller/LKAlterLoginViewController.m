

#import "LKAlterLoginViewController.h"
#import "LKOauthView.h"
#import "LKAlterLoginApi.h"
#import "LKGlobalConf.h"
#import "LKSignInApple.h"
#import <AuthenticationServices/AuthenticationServices.h>

#import "LKUser.h"
#import "LKPointManager.h"
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
//#import "MMMaterialDesignSpinner.h"
@interface LKAlterLoginViewController ()
@property (nonatomic, strong)  LKOauthView * oauthView;
@property (nonatomic, assign) BOOL isNewUser;
//@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
//@property (nonatomic, strong) UIView *maskView;
@end

@implementation LKAlterLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoginView];
    [self actionEvent];
}


#pragma mark -- 执行事件
- (void)actionEvent{
    [self getCheckCode];
    [self iphoneLogin];
    [self thirdLogin];
    [self switchStyleAction];
   
}

- (void)setCloseView:(BOOL)isclose{
//    self.oauthView.button_close.hidden =isclose;
//    self.oauthView.imageView_close.hidden = isclose;
}


- (void)switchStyleAction{
    __weak typeof(self)weakSelf = self;
    self.oauthView.switchAction = ^(UIButton * _Nonnull sender) {
        
        if (sender.tag == 10) { // 密码
            if (weakSelf.oauthView.view_pwd.hidden == NO) { // 非隐藏状态，显示的时候，切换进行位置调整，非显示状态无需进行位置调整
                [weakSelf.oauthView hiddenViewPasswordIsInitState:NO];
                [weakSelf setAlterHeight:weakSelf.oauthView.startRealHeight];
            }
        }
        
        [weakSelf readInfo:sender];
        
    };
}

- (void)readInfo:(UIButton *)sender{
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERPASSWORD"];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERPHONE"];
    
    if (sender.tag == 10) {
        if (phone.exceptNull != nil && password.exceptNull != nil) {
            self.oauthView.textfield_iphone.text = phone;
            self.oauthView.textfield_code.text  = password;
        }
    }else{
        if (phone.exceptNull != nil) {
            self.oauthView.textfield_iphone.text = phone;
            self.oauthView.textfield_code.text = @"";
        }
    }
}





#pragma mark -- 获取验证码
- (void)getCheckCode{
    __weak typeof(self)weakSelf = self;
    self.oauthView.getCheckCodeAction = ^(UIButton * _Nonnull sender) {
        NSString *iphone = weakSelf.oauthView.textfield_iphone.text;
        [LKAlterLoginApi fetchCheckCodeByPhone:iphone isNewUserComplete:^(BOOL isNewUser, NSError * _Nonnull error) {
            weakSelf.isNewUser = isNewUser;
            weakSelf.oauthView.isNewUser = isNewUser;
            if (error == nil) {
                if (isNewUser == YES) {
                    if (weakSelf.oauthView.view_pwd.hidden == YES) {
                        [weakSelf.oauthView showViewPassword];
                        [weakSelf setAlterHeight:weakSelf.oauthView.startRealHeight];
                    }else{
                        [weakSelf setAlterHeight:weakSelf.oauthView.startRealHeight];
                    }
                }
            }else{
//                [weakSelf.view makeToast:error.localizedDescription];
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                [weakSelf.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
            }
            
        }];
    };
    
}



#pragma mark -- 手机号码登录
- (void)iphoneLogin{
      __weak typeof(self)weakSelf = self;
    
 
    self.oauthView.iphoneLoginAction = ^(UIButton * _Nonnull sender, SignInStyle signInStyle) {
    
        NSString *iphone = weakSelf.oauthView.textfield_iphone.text;
        NSString *pwd = weakSelf.oauthView.textfield_code.text;
        if (signInStyle == SignInStyle_PWD) { // 账号密码登录
            [weakSelf showMaskView];
            [LKAlterLoginApi accountLoginWithIphone:iphone withPassword:pwd Complete:^(NSError * _Nonnull error) {
                 LKUser * user =[LKUser getUser];
                if (error ==nil) {

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:user];
//                    [weakSelf.view makeToast:@"登录成功"];
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                    [weakSelf.view makeToast:@"登录成功" duration:2 position:CSToastPositionCenter style:style];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf hiddenMaskView];
                        [weakSelf dismissViewControllerAnimated:NO completion:^{
                            if (user != nil ) {
                                if ([[LKRealNameVerifyFactory createRealNameVerify] isRealName] == NO) {
                                
                                    if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthenticationCanClose" object:nil];
                                    }else{
                                        if (weakSelf.loginCompleteCallBack) {
                                            weakSelf.loginCompleteCallBack(user, error);
                                        }
                                    }
                                   
                                }else{
                                    if (weakSelf.loginCompleteCallBack) {
                                        weakSelf.loginCompleteCallBack(user, error);
                                    }
                                }
                            }else{
                                if (weakSelf.loginCompleteCallBack) {
                                    weakSelf.loginCompleteCallBack(nil, error);
                                }
                            }
                        }];
                    });


 
                }else{
                    [weakSelf hiddenMaskView];
                     if (error.code == 2234) {
                                                            
                        [weakSelf dismissViewControllerAnimated:NO completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthentication" object:error];
                        }];
                        
                    }else if (error.code == 2235){ // 未成年人固定时间段不可玩
                        [weakSelf dismissViewControllerAnimated:NO completion:^{
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEFORBIDPLAYGAME" object:error];
                       }];
                    }else if (error.code == 2236){ // 未成年人累计时间超出不可玩
                        [weakSelf dismissViewControllerAnimated:NO completion:^{
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEPLAYTIMEEXPIRE" object:error];
                       }];
                    }else{
                        
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFail" object:error];
                        if (weakSelf.loginCompleteCallBack) {
                            weakSelf.loginCompleteCallBack(nil, error);
                        }
                    }
//                     [weakSelf.view makeToast:error.localizedDescription];
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                    [weakSelf.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
                }
                
            }];
            
        }else if (signInStyle == SignInStyle_Code){ // 验证码登录
             NSString *iphone = weakSelf.oauthView.textfield_iphone.text;
             NSString *code = weakSelf.oauthView.textfield_code.text;
             NSString *pwd = nil;
            if (self.isNewUser == YES) {
                pwd = weakSelf.oauthView.textfield_pwd.text;
            }
            [weakSelf showMaskView];
            [LKAlterLoginApi loginWithIphone:iphone checkCode:code password:pwd complete:^(NSError * _Nonnull error) {
                LKUser * user =[LKUser getUser];
                if (error ==nil) {
                
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:user];
//                    [weakSelf.view makeToast:@"登录成功"];
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                    [weakSelf.view makeToast:@"登录成功" duration:2 position:CSToastPositionCenter style:style];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf hiddenMaskView];
                            [weakSelf dismissViewControllerAnimated:NO completion:^{
                            
                            if (user != nil ) {
                                if ([[LKRealNameVerifyFactory createRealNameVerify] isRealName] == NO) {
                                    
                                    if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthenticationCanClose" object:nil];
                                    }else{
                                        if (weakSelf.loginCompleteCallBack) {
                                            weakSelf.loginCompleteCallBack(user, error);
                                        }
                                    }
                                   
                                }else{
                                    if (weakSelf.loginCompleteCallBack) {
                                        weakSelf.loginCompleteCallBack(user, error);
                                    }
                                }
                            }else{
//                                [weakSelf.view makeToast:error.localizedDescription];
                                
                                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                                style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                                [weakSelf.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
                                
                                if (weakSelf.loginCompleteCallBack) {
                                     weakSelf.loginCompleteCallBack(nil, error);
                                 }
                            }
                        }];
                    });

                }else{
                    [weakSelf hiddenMaskView];
                    if (error.code == 2234) {
                                                           
                       [weakSelf dismissViewControllerAnimated:NO completion:^{
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthentication" object:error];
                       }];
                       
                   }else if (error.code == 2235){ // 未成年人固定时间段不可玩
                       [weakSelf dismissViewControllerAnimated:NO completion:^{
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEFORBIDPLAYGAME" object:error];
                      }];
                   }else if (error.code == 2236){ // 未成年人累计时间超出不可玩
                       [weakSelf dismissViewControllerAnimated:NO completion:^{
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEPLAYTIMEEXPIRE" object:error];
                      }];
                   }else{
                      
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFail" object:error];
                       if (weakSelf.loginCompleteCallBack) {
                           weakSelf.loginCompleteCallBack(nil, error);
                       }
                   }
                    //[weakSelf.view makeToast:error.localizedDescription];
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                    [weakSelf.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
                }
      
            }];
        }
        
        // 打点
        [weakSelf basePoint];

        
    };
}


#pragma mark -- 打点
- (void)basePoint{
    // 打点
//    LKUser * user =[LKUser getUser];
//    if ([user.is_new_user boolValue] == YES) { // 新用户
//        [[LKPointManager shared] standardLogEventName:@"Reg" complete:nil];
//    }else{ // 老用户
//        [[LKPointManager shared] standardLogEventName:@"Login" complete:nil];
//    }
}



#pragma mark -- 第三方登录
- (void)thirdLogin{
    __weak typeof(self)weakSelf = self;
    self.oauthView.thirdLoginAction = ^(UIButton * _Nonnull sender) {
        if (weakSelf.thirdLoginAction) {
            weakSelf.thirdLoginAction(sender);
        }
        if (sender.tag == 10) {
            [weakSelf quickLogin];
        }else if (sender.tag == 20){
            [weakSelf appleLogin];
        }else if (sender.tag == 30){
           // TODO:DELETE
        }else if (sender.tag == 40){
            // TODO:DELETE
        }
    };
}


#pragma mark -- 快速登录
- (void)quickLogin{
    [self showMaskView];
    [LKAlterLoginApi quickLoginComplete:^(NSError * _Nonnull error) {
           [self basePoint];
           LKUser * user =[LKUser getUser];
        if (error ==nil) {
            [self hiddenMaskView];

//            [self.view makeToast:@"登录成功"];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:@"登录成功" duration:2 position:CSToastPositionCenter style:style];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:user];
                }];
            });
        }else{
            // 2234 游客模式时间到 提示去实名
            // 2235 未成年模式休息时间  禁止游戏
            // 2236 未成年模式游玩是游戏时间到 禁止游戏
            [self hiddenMaskView];
            if (error.code == 2234) {
                
                [self dismissViewControllerAnimated:NO completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthentication" object:error];
                }];
                
            }else if (error.code == 2235){ // 未成年人固定时间段不可玩
                [self dismissViewControllerAnimated:NO completion:^{
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEFORBIDPLAYGAME" object:error];
               }];
            }else if (error.code == 2236){ // 未成年人累计时间超出不可玩
                [self dismissViewControllerAnimated:NO completion:^{
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEPLAYTIMEEXPIRE" object:error];
               }];
            }else{
//                [self.view makeToast:error.localizedDescription];
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFail" object:error];
            }
            
        }
        if (self.loginCompleteCallBack) {
            self.loginCompleteCallBack(user, error);
        }
   
    }];
}

#pragma mark -- 苹果登录
- (void)appleLogin{
    
  /**
   ASAuthorizationErrorUnknown = 1000,
   ASAuthorizationErrorCanceled = 1001,
   ASAuthorizationErrorInvalidResponse = 1002,
   ASAuthorizationErrorNotHandled = 1003,
   ASAuthorizationErrorFailed = 1004,
   */
    // 登录失败
    [LKSignInApple instance].didCompleteWithError = ^(NSError * _Nonnull error) {
        NSError *errorRes =nil;
        if (@available(iOS 13.0, *)) {
            if (error.code == ASAuthorizationErrorCanceled) { // 用户取消了登录
               [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCancel" object:@"apple"];
               errorRes = [self responserErrorMsg:@"取消登陆" code:1001];
                if (self.appleLoginCallBack) {
                    self.appleLoginCallBack(errorRes);
                }
//                [self.view makeToast:errorRes.localizedDescription];
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                [self.view makeToast:errorRes.localizedDescription duration:2 position:CSToastPositionCenter style:style];
            }else{
                errorRes = [self responserErrorMsg:error.localizedDescription code:1004];
                if (self.appleLoginCallBack) {
                    self.appleLoginCallBack( errorRes);
                }
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFail" object:error];
            }

            if (self.loginCompleteCallBack) {
                self.loginCompleteCallBack(nil, errorRes);
            }
        } else {
            // Fallback on earlier versions
           
        }
    };
    
    // 登录成功
    [LKSignInApple instance].didCompleteWithAuthorization = ^(NSInteger type, NSString * _Nullable user, NSString * _Nullable token, NSString * _Nullable code, NSString * _Nullable password) {

        if (type == 1) { //appID 登录
            // 发起请求
            [LKAlterLoginApi appleLoginWithToken:token Complete:^(NSError * _Nonnull error) {
                [self basePoint];
                 LKUser * user =[LKUser getUser];
               if (error ==nil) {

                          [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:user];
                   
                           UIViewController *vc = self.presentingViewController != nil?self.presentingViewController : self;
                           [vc dismissViewControllerAnimated:NO completion:^{
                           
                           if (user != nil ) {
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
//                               [self.view makeToast:error.localizedDescription];
                               CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                               style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                               [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
                               if (self.loginCompleteCallBack) {
                                    self.loginCompleteCallBack(user, error);
                               }
                           }
                       }];
                }else{
                    
                    if (error.code == 2234) {
                        UIViewController *vc = self.presentingViewController != nil?self.presentingViewController : self;
                         [vc dismissViewControllerAnimated:NO completion:^{
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthentication" object:error];
                         }];
                         
                     }else if (error.code == 2235){ // 未成年人固定时间段不可玩
                         UIViewController *vc = self.presentingViewController != nil?self.presentingViewController : self;
                         [vc dismissViewControllerAnimated:NO completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEFORBIDPLAYGAME" object:error];
                        }];
                     }else if (error.code == 2236){ // 未成年人累计时间超出不可玩
                         UIViewController *vc = self.presentingViewController != nil?self.presentingViewController : self;
                         [vc dismissViewControllerAnimated:NO completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"NONAGEPLAYTIMEEXPIRE" object:error];
                        }];
                     }else{
                         NSError *errorRes = [self responserErrorMsg:error.localizedDescription code:1004];
                       
                         if (self.appleLoginCallBack) {
                             self.appleLoginCallBack(errorRes);
                         }
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFail" object:errorRes];
                         if (self.loginCompleteCallBack) {
                             self.loginCompleteCallBack(nil, errorRes);
                         }
                     }
                    
//                      [self.view makeToast:error.localizedDescription];
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                    [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
                    

                }
                
               
                
            }];
        
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



#pragma mark -- 忘记密码
- (void)forgetPasspwrd{
    [self dismissViewControllerAnimated:NO completion:^{
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ForgetPassword" object:nil];
        
    }];
}


#pragma mark -- 布局子视图
- (void)showLoginView{

    LKOauthView *oauthView = [LKOauthView instanceOauthView];
    self.oauthView = oauthView;
    [self.view insertSubview:oauthView atIndex:self.view.subviews.count];
    [oauthView setLKSuperView:self.view];
 

    oauthView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setAlterContentView:oauthView];
    [self setAlterHeight:oauthView.startRealHeight];
    [self setAlterWidth:350];
    [self layoutConstraint];
    
   __weak  typeof(self)weakSelf = self;
    self.deviceOrientationHander = ^(UIDeviceOrientation orientation) {
        [weakSelf deviceOrientation:orientation];
    };
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    UIDeviceOrientation deviceOrientation = (UIDeviceOrientation)orientation;
    
    [self deviceOrientation:deviceOrientation];
    
    
    // 忘记密码
    oauthView.forgetPwdAction = ^(UIButton * _Nonnull sender) {
        
        [self forgetPasspwrd];
        
    };
    
    oauthView.textFieldBenginEditCallBack = ^(CGFloat realHeight) {
        [weakSelf.oauthView showViewChechView];
        [weakSelf.oauthView showButtonLogin];
        [weakSelf setAlterHeight:weakSelf.oauthView.startRealHeight];
    };

    
    oauthView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    oauthView.useAgreementCallBack = ^(BOOL isAgreement, UIButton * _Nonnull sender) {
       [self useAgreementAction:isAgreement type:sender.tag];
    };
    
    

       if (self.agreement == YES) {
           [oauthView.button_check setBackgroundImage:[UIImage lk_ImageNamed:@"checkmark"] forState:UIControlStateNormal];
       }else{
            [oauthView.button_check setBackgroundImage:[UIImage lk_ImageNamed:@"frame"] forState:UIControlStateNormal];
           
       }
    oauthView.button_check.selected = self.agreement;



    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERPASSWORD"];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERPHONE"];
   
   if (phone != nil && password.exceptNull != nil) {
       if (oauthView.view_phone.hidden == NO) {
           [oauthView showViewChechView];
           [oauthView showButtonLogin];
           [self setAlterHeight:oauthView.startRealHeight];
           oauthView.switchIndex = 10;
           [oauthView updatePasswordView];
           oauthView.textfield_iphone.text = phone;
           oauthView.textfield_code.text  = password;
       }
       



   }else{
       if(phone != nil){
           if (oauthView.view_phone.hidden == NO) {
               [oauthView showViewChechView];
               [oauthView showButtonLogin];
               [self setAlterHeight:oauthView.startRealHeight];
               oauthView.switchIndex = 20;
               [oauthView updateCodeView];
               oauthView.textfield_iphone.text = phone;
           }

       }
   }
    
}







- (void)useAgreementAction:(BOOL)isAgreement type:(NSInteger)type {
    [self dismissViewControllerAnimated:NO completion:^{
         NSNumber *agreement = [NSNumber numberWithBool:isAgreement];
         NSNumber *typeNumber = [NSNumber numberWithInteger:type];
       
         NSDictionary *result = @{@"isAgreement":agreement,@"type":typeNumber};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"USEAGREEMENT" object:result];
    }];
}



/// 设备监听回调
/// @param orientation <#orientation description#>
- (void)deviceOrientation:(UIDeviceOrientation)orientation{
//    switch (orientation) {
//              case UIDeviceOrientationFaceUp:
//                  break;
//              case UIDeviceOrientationFaceDown:
//                  break;
//              case UIDeviceOrientationUnknown:
//                  break;
//              case UIDeviceOrientationLandscapeLeft:
//                  self.oauthView.layoutHeight.constant = 0;
////                  self.oauthView.button_close_two.hidden = YES;
////                  self.oauthView.imageView_close_two.hidden = YES;
//                  [self setAlterHeight:300];
//                  break;
//              case UIDeviceOrientationLandscapeRight:
////                self.oauthView.button_close_two.hidden = YES;
////                self.oauthView.imageView_close_two.hidden = YES;
//                 self.oauthView.layoutHeight.constant = 0;
//                [self setAlterHeight:300];
//                  break;
//              case UIDeviceOrientationPortrait:
//                {
////                    self.oauthView.button_close_two.hidden = YES;
////                    self.oauthView.imageView_close_two.hidden = YES;
//                    self.oauthView.layoutHeight.constant = 136;
//                      if (self.oauthView.view_pwd.hidden == YES) {
//                         [self setAlterHeight:400];
//                      }else{
//                          [self setAlterHeight:433];
//                      }
//                }
//
//                  break;
//              case UIDeviceOrientationPortraitUpsideDown:
//                  break;
//              default:
//                  break;
//          }
//
//    [self layoutConstraint];
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

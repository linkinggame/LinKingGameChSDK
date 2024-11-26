

#import "LKRealNameController.h"
#import "LKRealNameView.h"
#import "LKAuthApi.h"
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
#import "LKUserEntity.h"
#import "LKMQTTFace.h"
#import "MQTTSessionManager.h"
#import "LKMQTTClient.h"
#import "LKLog.h"
@interface LKRealNameController ()

@end

@implementation LKRealNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showRealNameView];
}


#pragma mark -- 认证
- (void)authAction:(NSString *)name idNumber:(NSString *)number{
    
    // 如果已经断开连接
//    if ( [LKMQTTFace shared].client.manager.state == MQTTSessionManagerStateClosed) {
//        LKLogInfo(@"===主动连接===");
//        // 主动连接
//        [[LKMQTTFace shared] connectMQTT];
//    }
//   
    
    [self showMaskView];
    [LKAuthApi authWithName:name IdNumber:number complete:^(NSDictionary *result,NSError *error) {

        
        if (error == nil) {
            // 接口成功
           NSNumber *success = result[@"success"];
           NSString *desc = result[@"desc"];
            NSString *code = result[@"code"];
           NSDictionary *data = result[@"data"];
            NSError *err = nil;
            if ([success boolValue] == YES) {
                   LKUser *user = [[LKUser alloc] initWithDictionary:data];
                   if (user != nil) {
                       // 将用户信息存储到本地
                       [LKUser setUser:user];
                       // 实名认证成功将userId 设置为nil
                       [LKUserEntity shared].userId = nil;

                       // 更新实名认证状态
                       //[[LKRealNameVerifyFactory createRealNameVerify] saveUserRealVerifyState:user.real_verify];
                   }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"REALNAMESTATUS"];
                    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                    style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                    if ([user.real_verify isEqualToString:@"2"]) { // 认证成功
                        // 如果认证库中有，并且认证成功过的，后台直接返回 real_verify = 2
                        [self.view makeToast:@"认证成功" duration:2 position:CSToastPositionCenter style:style];
                    }else{
                        [self.view makeToast:@"认证中" duration:2 position:CSToastPositionCenter style:style];
                    }
                   
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self hiddenMaskView];
                        [self dismissViewControllerAnimated:NO completion:^{
                            if (self.loginCompleteCallBack) {
                                 LKUser*user = [LKUser getUser];
                                if (self.loginCompleteCallBack) {
                                     self.loginCompleteCallBack(user, error);
                                }
                            }
                        }];
                    });
                 });
                
            }else{
                if (code.exceptNull != nil) {
                      err= [self responserErrorMsg:desc code:[code intValue]];
                     // 请求失败
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self hiddenMaskView];
                         CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                         style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                        
                         [self.view makeToast:err.localizedDescription duration:2 position:CSToastPositionCenter style:style];
                     });
                }
              
 
            }
            
            if (self.realNameCompeleteCallBack) {
                self.realNameCompeleteCallBack(NO, err);
            }
            
        
            
            
        }else{
            // 接口失败
            [self hiddenMaskView];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
            
            
            if (self.realNameCompeleteCallBack) {
                self.realNameCompeleteCallBack(NO, error);
            }
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameResult" object:error userInfo:@{@"name":name}];
            
        }
        

        
    }];
}
- (void)showRealNameView{
    
    
    if (self.isRealNameFail == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:@"认证失败" duration:2 position:CSToastPositionCenter style:style];
        });
    }
    

    LKRealNameView *realNameView = [LKRealNameView instanceRealNameView];
    [self.view insertSubview:realNameView atIndex:self.view.subviews.count];
    realNameView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:realNameView];
    CGFloat width = 300;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:342];
    [self layoutConstraint];
    
    [realNameView setLKSuperView:self.view];

    
     // 认证
    realNameView.authAction = ^(UIButton * _Nonnull sender, NSString * _Nonnull name, NSString * _Nonnull number) {
         [self authAction:name idNumber:number];
    };
 
    if (self.isShowClose) {
        realNameView.button_close.hidden = NO;
        realNameView.imageView_close.hidden = NO;
    }else{
        realNameView.button_close.hidden = YES;
        realNameView.imageView_close.hidden = YES;
    }
    realNameView.closeAlterViewAction = ^(UIButton * _Nonnull sender) {
        [self dismissViewControllerAnimated:NO completion:^{
            
            if (self.closePayCallBack) {
                self.closePayCallBack();
            }
            if (self.closeCallBack) {
                self.closeCallBack();
            }
            
            if (self.realNameCompeleteCallBack) {
                self.realNameCompeleteCallBack(YES, nil);
            }
            
            if (self.closeCallBack) {
                self.closeCallBack();
            }
            
        }];
    };
    

    [self changeViewStateWithView:realNameView];
 
}



- (void)changeViewStateWithView:(LKRealNameView *)view{
    LKUser *user = [LKUser getUser];
    RealVerifyState state = [[LKRealNameVerifyFactory createRealNameVerify] getRealVerifyState];
    switch (state) {
        case RealVerifyStateUnverified:
        {
            view.button_auth.hidden = NO;
            break;
        }
        case RealVerifyStateAuthenticating:
        {
            if (user.real_name.exceptNull != nil && user.id_card.exceptNull != nil) {
                [self commonViewSettingWithView:view withName:user.real_name withIdCard:user.id_card];
                 view.button_auth.userInteractionEnabled = NO;
                [view.button_auth setTitle:@"认证中" forState:UIControlStateNormal];
                [view.button_auth setBackgroundColor:[UIColor grayColor]];
            }
            view.button_auth.hidden = NO;
           
            break;
        }
        case RealVerifyStateVerified:
        {
            [self commonViewSettingWithView:view withName:user.real_name withIdCard:user.id_card];
            view.button_auth.hidden = YES;
            break;
        }
        default:
            break;
    }
}

- (void)commonViewSettingWithView:(LKRealNameView *)view withName:(NSString *)name withIdCard:(NSString *)idCard{
    view.textfield_name.text = name;
    view.textfield_code.text = idCard;
    view.textfield_code.userInteractionEnabled = NO;
    view.textfield_name.userInteractionEnabled = NO;
    view.textfield_code.clearButtonMode =  UITextFieldViewModeNever;
    view.textfield_name.clearButtonMode =  UITextFieldViewModeNever;
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

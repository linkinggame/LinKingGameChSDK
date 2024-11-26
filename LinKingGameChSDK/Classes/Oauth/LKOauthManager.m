

#import "LKOauthManager.h"
#import "LKBaseViewController.h"
#import "LKAlterLoginViewController.h"
#import "LKWecomeViewController.h"
#import "LKRestPwdViewController.h"
#import "LKFixPwdViewController.h"
#import "LKUserCenterViewController.h"
#import "LKIconCenterViewController.h"
#import "LKPayResultController.h"
#import "LKBindingTipController.h"
#import "LKPayTypeController.h"
#import "LKCustomerController.h"
#import "LKRealNameController.h"
#import "LKCrazyTipController.h"
#import "LKSubmitIssueController.h"
#import "LKIssueStyleController.h"
#import "LKIssueServiceController.h"
#import "LKUseAgreementController.h"
#import "LKOrderController.h"
#import "LKAlterLoginApi.h"
#import "LKUser.h"
#import "LKBindingController.h"
#import "LKSDKConfigApi.h"
#import "LKFloatView.h"
#import "LKGlobalConf.h"
#import "LKSDKManager.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "LKRegisterController.h"
#import "LKVersion.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "LKPointApi.h"
#import "LKMQTTFace.h"
#import "LKRealNameVerifyFactory.h"
#import "LKControlUtil.h"
#import "LKControlUtil.h"
#import "LKLog.h"
#import "LKVisibleControllerUtil.h"
static LKOauthManager *instance = nil;

@interface LKOauthManager (){
    dispatch_source_t _dispatchTimer;
    dispatch_source_t _dispatchRequestTimer;
}
@property (nonatomic, assign) int second;
@property (nonatomic, assign) int lastSecond;
@property (nonatomic, strong) LKBaseViewController *alterBaseViewController;
@property (nonatomic, strong)  LKAlterLoginViewController *alterLoginViewController;

@property (nonatomic, assign) BOOL isEnterBackground;
@property (nonatomic, assign) BOOL isAuto;
@property (nonatomic,strong) LKFloatView *floatView;
@property (nonatomic,copy)void(^loginCompleteCallBack)(LKUser *user,NSError *error);
@property (nonatomic, assign) BOOL isChangeAccount;
@property (nonatomic, assign) BOOL isStopRequest;
@property (nonatomic, assign) NSString *realVerifyState;
@end

@implementation LKOauthManager

+ (instancetype)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LKOauthManager alloc] init];
        [instance addCustomeObserver];
        
    });
    return instance;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 是否已经实名
- (BOOL)isRealName{
    NSObject<LKRealNameVerify>*object = [LKRealNameVerifyFactory createRealNameVerify];
    return [object isRealName];
}

- (void)initializationAuthorizationRootViewController:(UIViewController *)viewController autoLogin:(BOOL)isAuto{
    self.viewController = viewController;
    self.isAuto = isAuto;
    [self addObserverNotification];
    // 启动打点
    [LKPointApi pointEventName:@"StartUp" withTp:@"StartUp" withValues:nil complete:^(NSError * _Nonnull error) {
        
        LKLogInfo(@"启动打点");
    }];
    if (self.isAuto == YES) {
         [self autoLogin];
    }else{
        [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
    }
}


- (void)showFloatViewDashboard:(UIViewController *)viewController{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = CGRectZero;
        rect = CGRectMake(-23, [UIScreen mainScreen].bounds.size.height * 0.5, 46, 46);
        [self floatViewDashboard:viewController withFrame:rect];
    });

}

- (void)hiddenFloatViewDashboard{
    self.floatView.hidden = YES;
    [self.floatView removeFromSuperview];
}

- (void)floatViewDashboard:(UIViewController *_Nullable)viewController withFrame:(CGRect)frame{
        if (self.floatView != nil) {
            [self.floatView removeFromSuperview];
        }
      self.viewController = viewController;
      LKFloatView *floatView = [[LKFloatView alloc] initWithFrame:CGRectZero];
      self.floatView  = floatView;
      [floatView setImageWithName:@"float"];
      floatView.stayMode = STAYMODE_LEFTANDRIGHT;
     __weak typeof(self)weakSelf = self;

      [floatView setTapActionWithBlock:^{
           LKUser *user = [LKUser getUser];
          if (user != nil && user.userId.exceptNull != nil) { // 用户已经登录展示用户中心
              [weakSelf showUserCenterAlterViewRootViewController:viewController];
          }else{ // 未登录展示登录界面
              [weakSelf showLoginAlterViewRootViewController:viewController withAgreement:YES];
          }

      }];
    UIViewController *rootViewController = nil;
    if (viewController == nil) {
        rootViewController = [UIApplication sharedApplication].windows.lastObject.rootViewController;
    }else{
        rootViewController = viewController;
    }
    
  
    [rootViewController.view addSubview:floatView];

     floatView.translatesAutoresizingMaskIntoConstraints = NO;
    
     NSLayoutConstraint *centY = [NSLayoutConstraint constraintWithItem:floatView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
     NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:floatView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-23];
       
     NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:floatView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:46];
     
     NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:floatView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:46];
     
     [rootViewController.view addConstraints:@[centY,left,width,height]];
}

- (void)loginApiWithRootViewController:(UIViewController *_Nullable)viewController complete:(void(^)(LKUser * _Nullable user,NSError * _Nullable error))complete{
    self.viewController = viewController;
    [self addObserverNotification];
    LKUser *user = [LKUser getUser];
    if (user != nil && user.userId.exceptNull != nil) { // 用户已经登录展示用户中心
        [self showWecomeAlterViewRootViewController:viewController];
    }else{ // 未登录展示登录界面
        [self showLoginAlterViewRootViewController:viewController withAgreement:YES];
    }
    self.loginCompleteCallBack = complete;
    
  
    
}


- (void)loginWithDashboardRootViewController:(UIViewController *)viewController autoLogin:(BOOL)isAuto complete:(void(^)(LKUser *user,NSError *error))complete{
    [self initializationAuthorizationRootViewController:viewController autoLogin:isAuto];
    self.loginCompleteCallBack = complete;
}



- (void)loginWithDashboardRootViewController:(UIViewController *)viewController complete:(void(^)(LKUser *user,NSError *error))complete{

    [self loginWithDashboardRootViewController:viewController autoLogin:YES complete:complete];
}



- (void)logOutSDK{
   
    [self logOutSDKPrivate:YES];

}
- (void)logOutSDKPrivate:(BOOL)isDelegate{
    [self removeSysObserverNotification];
    [self stopRequestTime];
    self.isStopRequest = YES;
    [self hiddenFloatViewDashboard];
    
    // 断开
    [[LKMQTTFace shared] disconnectMQTT];
    
    // 移除用户信息
    [LKUser removeUserInfo];
    
    if (isDelegate) {
        if ([self.delegate respondsToSelector:@selector(logoutSDKCallback)]) {
            [self.delegate logoutSDKCallback];
        }
    }

}



-(UIViewController *)topMostController {
    UIViewController *topController = [UIApplication sharedApplication].windows.lastObject.rootViewController;
//    UIViewController*topController = [UIApplication sharedApplication].delegate.window.rootViewController;
  while(topController == nil){
      [self topMostController];
  }
  return topController;
}
#pragma mark -- 添加监听
- (void)addCustomeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AutoLoginFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autologinFailAction:) name:@"AutoLoginFail" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailAction:) name:@"LoginFail" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WecomeChangeAccount" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wecomeChangeAccountAction) name:@"WecomeChangeAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeAccount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAccountAction) name:@"ChangeAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ForgetPassword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forgetPasswordAction) name:@"ForgetPassword" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserCenterBinDingAccount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCenterBinDingAccount) name:@"UserCenterBinDingAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FixUserIcon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixUserIconAction) name:@"FixUserIcon" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectItemAction:) name:@"SelectItem" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RealNameAuthentication" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameAutheAction:) name:@"RealNameAuthentication" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RealNameAuthenticationCanClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameAuthenticationCanClose:) name:@"RealNameAuthenticationCanClose" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RealNameAuthenticationTip" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameAutheTipAction) name:@"RealNameAuthenticationTip" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FixPasswordClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixPasswordCloseAlterViewAction) name:@"FixPasswordClose" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RestPasswordClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restPasswordCloseAlterViewAction) name:@"RestPasswordClose" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FixPassword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixPasswordAction) name:@"FixPassword" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RestPassword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restPasswordAction) name:@"RestPassword" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommitIssueStyle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commitIssueStyleAction) name:@"CommitIssueStyle" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReadIssue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readIssueAction) name:@"ReadIssue" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommitIssue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commitIssueAction:) name:@"CommitIssue" object:nil];
    // 登陆成功后的回调
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction:) name:@"LoginSuccess" object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TryPlayGameTime" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryPlayGameTimeAction:) name:@"TryPlayGameTime" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BindingAccount" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingAccountAcction) name:@"BindingAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCancelAcction:) name:@"LoginCancel" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BindingSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingSuccessAction:) name:@"BindingSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USEAGREEMENT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useAgreementAction:) name:@"USEAGREEMENT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BACKUSEAGREEMENT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backUseAgreementAction:) name:@"BACKUSEAGREEMENT" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RealNameResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameResult:) name:@"RealNameResult" object:nil];
    
    
    /// token 失效
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TOKENINVALID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenInvalidWithNotification:) name:@"TOKENINVALID" object:nil];
    
    
    // 未成年禁止游戏 --- 未成年人固定点不可玩
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NONAGEFORBIDPLAYGAME" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nonageForbidPlayGameWithErrorNotification:) name:@"NONAGEFORBIDPLAYGAME" object:nil];
    
    
    /// 未成年游玩时间到 ---- 累计时长不可玩
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NONAGEPLAYTIMEEXPIRE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nonagePlayTimeExpireWithNotification:) name:@"NONAGEPLAYTIMEEXPIRE" object:nil];
    
    /// 游客游玩时间到
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VISITORPLAYTIMEEXPIRE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visitorPlayTimeExpireWithNotification:) name:@"VISITORPLAYTIMEEXPIRE" object:nil];
    
    
    // 封号
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLOCKEDACCOUNT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blockedAccountNotification:) name:@"BLOCKEDACCOUNT" object:nil];
    
    
    
}
- (void)addObserverNotification{
    
    // 监听程序进入前后台
    // app启动或者app从后台进入前台都会调用这个方法
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];

}

- (void)removeSysObserverNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

// 使用协议
- (void)useAgreementAction:(NSNotification *)noti{
    
    NSDictionary *result = noti.object;
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSNumber *isAgreement = result[@"isAgreement"];
        NSNumber *type = result[@"type"];
         [self showUseAgreementViewRootViewController:self.viewController withAgreement:[isAgreement boolValue] withType:[type intValue]];
    }

}

- (void)backUseAgreementAction:(NSNotification *)noti{
    NSNumber *number = noti.object;
    
    LKAlterLoginViewController *alterBaseViewController = [[LKAlterLoginViewController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;


    
    alterBaseViewController.agreement = [number boolValue];
    alterBaseViewController.loginCompleteCallBack = ^(LKUser * _Nonnull user, NSError * _Nonnull error) {
        if (self.loginCompleteCallBack) {
            if (error == nil) {
                [self showFloatViewDashboard:self.viewController];
            }
            self.loginCompleteCallBack(user, error);
            // 更新版本
            [self versionSDKUpdate];
        }
    };
    [self.viewController presentViewController:alterBaseViewController animated:NO completion:nil];
    

    
}
- (void)bindingSuccessAction:(NSNotification *)noti{
    
    NSError *error = noti.object;
    if (error == nil) {
//        if ([self.delegate respondsToSelector:@selector(lkbindingAccountSuccess:WithFaile:)]) {
//            [self.delegate lkbindingAccountSuccess:[LKUser getUser] WithFaile:nil];
//        }else{
//            [self.delegate lkbindingAccountSuccess:[LKUser getUser] WithFaile:error];
//        }
    }
}

// 取消登陆
- (void)loginCancelAcction:(NSNotification *)noti{

    NSString *style = (NSString *)noti.object;
    
    if ([style isEqualToString:@"apple"]) {
        LKLogInfo(@"苹果登陆取消");
    }else if ([style isEqualToString:@"wexin"]){
  
    }
}

- (void)bindingAccountAcction{
    [self showBindingAlterViewRootViewController:self.viewController];
}


- (void)realNameResult:(NSNotification *)noti{
    
    NSError *error =(NSError *)noti.object;
    LKUser*user = [LKUser getUser];

    BOOL isRealName = [[LKRealNameVerifyFactory createRealNameVerify] isRealName];
    // 是否已实名
    if (self.realNameCompleteCallBack) {
        self.realNameCompleteCallBack(isRealName, user, error);
    }

}

- (void)tryPlayGameTimeAction:(NSNotification *)noti{
    NSError *error = (NSError *)noti.object;
    [self showCrazyTipAlterViewRootViewController:self.viewController withTitle:@"未成年人防沉谜保护提示" withTip:error.localizedDescription isShowClose:NO];
}

- (BOOL)oneDayOnceWithKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *now = [NSDate date];
    NSDate *agoDate = [userDefault objectForKey:key]; // nowDate
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
    NSString *ageDateString = [dateFormatter stringFromDate:agoDate];
    NSString *nowDateString = [dateFormatter stringFromDate:now];

    if ([ageDateString isEqualToString:nowDateString]) {
        return NO;
     }else{
        // 需要执行的方法写在这里

        NSDate *nowDate = [NSDate date];
        NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
        [dataUser setObject:nowDate forKey:key];
        [dataUser synchronize];
         return YES;
     }
}

- (void)loginSuccessAction:(NSNotification *)noti{
    
    
    // 连接MQTT
    [[LKMQTTFace shared] connectMQTT];
    
    self.isStopRequest = NO;
    LKUser *user = (LKUser  *)noti.object;
    

    
    // 游客实名提示
    [self guestRealNameTipWithUser:user];

    // 绑定提示
    [self showBindingTip:user];
    
    // 开始轮询请求接口
    if (_dispatchRequestTimer == nil) {
        [self startRequestTime];
    }

    // 打点
    [self loginPoint:user];
    
}





- (void)loginPoint:(LKUser *)user
{
    if (user.is_new_user.exceptNull != nil ) {
        // 判断是否是新用户
        if ([user.is_new_user boolValue]) { // 注册
            // 注册成功后AF打点
            [[AppsFlyerLib shared] logEvent:AFEventCompleteRegistration withValues:@{
                @"af_registration_method":(user.login_type.exceptNull != nil) ?user.login_type:@""
            }];
            
        }else{ // 登录
            // 登录成功后AF打点
            [[AppsFlyerLib shared] logEvent:AFEventLogin withValues:@{
              @"af_registration_method":(user.login_type.exceptNull != nil) ?user.login_type:@""
            }];
       
        }
    }
    
}


- (void)guestRealNameTipWithUser:(LKUser *)user{
       if (user != nil) {
           // 游客没有实名
           if ([user.login_type isEqualToString:@"Guest"]&& [[LKRealNameVerifyFactory createRealNameVerify] isRealName] == NO) {
               // 弹出实名提示（一天触发一次）
               BOOL res =  [self oneDayOnceWithKey:@"nowDate"];
               if (res == YES) {
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [self showRegisterTipAlterViewRootViewController:self.viewController];
                   });
               }
               
           }
       }
}

- (void)applicationBecomeActive{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEnterBackground = NO;
        self.isStopRequest = NO;
        LKUser *user = [LKUser getUser];
       if (user != nil) {

           // 开始轮询请求接口
           if (self->_dispatchRequestTimer == nil) {
               [self startRequestTime];
           }
       }
        
        // 重新连接
        [[LKMQTTFace shared] connectMQTT];
    });
}

- (void)applicationEnterBackground{
    self.isEnterBackground = YES;
    
    [self stopRequestTime];
    
    // 断开连接
    [[LKMQTTFace shared] disconnectMQTT];
}

- (void)showBindingTip:(LKUser *)user{
    if (user == nil) {return;}
    NSString *flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"REALNAMESTATUS"];
    if ([flag isEqualToString:@"1"]) {
        // 用户已经实名未绑定
        if ([user.login_type isEqualToString:@"Guest"] && [[LKRealNameVerifyFactory createRealNameVerify] isRealName] && user.third_id.exceptNull == nil) {
              // 弹出绑定账号提示（一天触发一次）
            BOOL res =  [self oneDayOnceWithKey:@"BinDingNowDate"];
            if (res == YES) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showBindingTipAlterViewRootViewController:self.viewController];
                });
                
            }
        }
    }
}



- (void)startTime{
    LKLogInfo(@"======开始计时=====");
    if (_dispatchTimer) {
        dispatch_source_cancel(_dispatchTimer);
        _dispatchTimer = nil;
    }
    
    // 读取存入的时间
    LKUser *user = [LKUser getUser];
    if (user == nil) {
        return;
    }
    NSString *second =  [self readUserPlayTime];
    if (second != nil) {
        self.second = [second intValue];
    }
    
    
     _dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0,0));
    dispatch_source_set_timer(_dispatchTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_dispatchTimer, ^{
        self.second += 1;
//        LKLogInfo(@"======≥================>%d(秒)",self.second);
        if (self.second % 4 == 0) {
//            LKLogInfo(@"==保存一次== %d",self.second);
            [self saveUserPlayTime];
        }
    });
    dispatch_resume(_dispatchTimer);
}

- (NSString *)readUserPlayTime{
    LKUser *user = [LKUser getUser];
    if (user.userId.exceptNull != nil) {
        NSString *key = [NSString stringWithFormat:@"userSecond_%@",user.userId];
        NSString *second =  [[NSUserDefaults standardUserDefaults] objectForKey:key];
        return  second;
    }
    return nil;
   
}

- (void)saveUserPlayTime{
    
    LKUser *user = [LKUser getUser];
    if (user.userId.exceptNull != nil) {
        NSString *key = [NSString stringWithFormat:@"userSecond_%@",user.userId];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.second] forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)stopTime{
    if (_dispatchTimer) {
        dispatch_source_cancel(_dispatchTimer);
        _dispatchTimer = nil;
    }
}

// 每个20秒请求一次
- (void)startRequestTime{
    
    
    BOOL isUseMQttCheck = [LKSDKConfig isMqttCheck];
    
    // 如果使用MQTT 停止调用接口轮询
    if (isUseMQttCheck == YES) {
        LKLogInfo(@"=== 停止接口轮询检测 ===");
        return;
    }
    
    
    LKLogInfo(@"======开始请求计时=====");
    if (_dispatchRequestTimer) {
        dispatch_source_cancel(_dispatchRequestTimer);
        _dispatchRequestTimer = nil;
    }
    
    int time = 30;
    LKSDKConfig *sdkConfig = [LKSDKConfig getSDKConfig];
    if (sdkConfig != nil) {
        NSString *timeStr = sdkConfig.auth_config[@"check_time"];
        if (timeStr.exceptNull != nil) {
            int num = [timeStr intValue];
            if (num <= 30) {
                time = 30;
            }else if(num > 30){
                time = num;
            }
        }
    }
    // 设置多少秒之后触发
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);

    _dispatchRequestTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0,0));
    dispatch_source_set_timer(_dispatchRequestTimer, startTime, time * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_dispatchRequestTimer, ^{
        LKLogInfo(@"每隔%lds请求一次",(long)time);
        [self requestCheckUserInfoWithTime:time complete:nil];
    });
    dispatch_resume(_dispatchRequestTimer);
}

- (void)stopRequestTime{
    if (_dispatchRequestTimer) {
        dispatch_source_cancel(_dispatchRequestTimer);
        _dispatchRequestTimer = nil;
    }
}

/**
  获取当前实名状态
 */
- (RealVerifyState)getRealVerifyState{

    NSObject<LKRealNameVerify>*object = [LKRealNameVerifyFactory createRealNameVerify];
    return  [object getRealVerifyState];;
}

/**
 {
     code = "<null>";
     data =     {
         limit = "<null>";
         ok = 1;
         "question_red_dot" = 0;  未认证  1 认证中 2 已认证
         "real_verify" = 0;  0 未认证  1 认证中 2 已认证
         time = "<null>";
         "user_id" = "<null>";
     };
     desc = "<null>";
     success = 1;
 }
 */
- (void)requestCheckUserInfoWithTime:(int)time complete:(void(^_Nullable)(BOOL success))complete{
    
    if (time < 0) {
        time = 1;
    }
//    LKLogInfo(@"========>time:%ld",(long)time);

    [LKAlterLoginApi checkUserInfoWithTime:time complete:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
           
          id data = result[@"data"];

           if (error == nil) {
         
               if ([data isKindOfClass:[NSDictionary class]]) {
                  // NSNumber *limit = data[@"limit"];
                   NSNumber *time = data[@"time"];
                   NSNumber *ok = data[@"ok"];
                   NSString *realVerify = data[@"real_verify"];
                   if (realVerify.exceptNull != nil) {
                       // 保存用户实名状态
                       [[LKRealNameVerifyFactory createRealNameVerify] saveUserRealVerifyState:realVerify];
                   }
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"REDDOTUPDATE" object:data userInfo:data];
                   if ([ok boolValue] == YES) { // 成年
                       
                   }else{// 未成年
                       [self nonagePlayTimeExpireWithTime:[time intValue]];
                   }
               }
               if (complete) {
                   complete(YES);
               }
           }else{
               self.isStopRequest = YES;

               // 2234 游客模式时间到 提示去实名
               // 2235 未成年模式休息时间  禁止游戏
               // 2236 未成年模式游玩是游戏时间到 禁止游戏
               // 2101 用户不存在
                 if (error.code == 2234) {
                     
                     [self visitorPlayTimeExpire];
                 
                 }else if(error.code == 2235 ){ // 固定时间不可玩
                     [self nonageForbidPlayGameWithError:error];
                 }else if(error.code == 2236 ){ // 类型时长超出
                     [self nonagePlayTimeExpireWithTime:3610];
                 }else{
                     
                     if (error.code == 2101) {
                         self.isStopRequest = NO;
                         // token 失效
                         [self tokenInvalid];
                     }
                     
                 }
 
                 if (complete) {
                     complete(NO);
                 }
           }
           
       }];
}


- (void)nonageForbidPlayGameWithErrorNotification:(NSNotification *)noti{
    
    NSError *error = noti.object;
    [self nonageForbidPlayGameWithError:error];
    [[LKMQTTFace shared] disconnectMQTT];
}

- (void)nonagePlayTimeExpireWithNotification:(NSNotification *)noti{
    
    NSNumber *time = noti.userInfo[@"time"];
    [self nonagePlayTimeExpireWithTime:[time intValue]];
    // 断开连接
    [[LKMQTTFace shared] disconnectMQTT];
}

- (void)tokenInvalidWithNotification:(NSNotification *)noti{
    [self tokenInvalid];
    // 断开连接
   [[LKMQTTFace shared] disconnectMQTT];
}

- (void)visitorPlayTimeExpireWithNotification:(NSNotification *)noti{
    [self visitorPlayTimeExpire];
    // 断开连接
   [[LKMQTTFace shared] disconnectMQTT];
}

- (void)visitorPlayTimeExpire{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 防沉迷控制
        if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
            
            
         
            [self showRealNameAlterViewRootViewController:self.viewController isUserCenter:NO];
        }
    });
}
/// 未成年游玩时间
- (void)nonagePlayTimeExpireWithTime:(int)time{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([LKControlUtil isOpenStopAddiction] == YES){  // 防沉迷状态开启
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未成年人防沉谜保护提示" message:@"根据实名验证信息，您是未成年人，按照有关规定，您今日只能使用90分钟游戏时间，目前累计在线90分钟,无法继续游戏。为了您的身体健康，请控制游戏时间。" preferredStyle:UIAlertControllerStyleAlert];
                                      
             [self.viewController presentViewController:alertController animated:YES completion:nil];
            
        }
    });
    

}

/// 未成年禁止游戏
- (void)nonageForbidPlayGameWithError:(NSError *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([LKControlUtil isOpenStopAddiction] == YES) { // 防沉迷状态开启
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未成年人防沉谜保护提示" message:@"根据实名验证信息，您是未成年人，按照有关规定，每日22点-次日8点无法使用游戏。为了您的身体健康，请控制游戏时间。" preferredStyle:UIAlertControllerStyleAlert];
                                      
             [self.viewController presentViewController:alertController animated:YES completion:nil];
        }
    });

}

/// token 失效通知
- (void)tokenInvalid{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登录失败或账号在其他设备登录" preferredStyle:UIAlertControllerStyleAlert];

         [alertController addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
             [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
         }]];
                                  
         [self.viewController presentViewController:alertController animated:YES completion:nil];
    });
    
}

- (void)commitIssueAction:(NSNotification *)noti{
    NSString *string = noti.object;
    [self showSubmitIssueViewTipAlterViewRootViewController:self.viewController withIssueStyle:string];
}

- (void)commitIssueStyleAction{
    
    [self showIssueStyleViewTipAlterViewRootViewController:self.viewController];
}

- (void)readIssueAction{
    [self showIssueServiceViewTipAlterViewRootViewController:self.viewController];
}

- (void)restPasswordAction{
    [self showRestPwdAlterViewRootViewController:self.viewController];
}

- (void)fixPasswordCloseAlterViewAction{
    [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
}
- (void)restPasswordCloseAlterViewAction{
    [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
}

- (void)fixPasswordAction{
    [self showFixPwdAlterViewRootViewController:self.viewController];
}

- (void)realNameAutheAction:(NSNotification *)noti{

     NSError *error  = noti.object;
    
    if (error != nil) {
        
        if (error.code == 2234) {
            // 认证失败
             if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
                 [self showRealNameAlterViewRootViewController:self.viewController isUserCenter:NO isRealNameFail:YES];
             }
        }else{
            
            if (error.code  == -113) {
                [self showRealNameAlterViewRootViewController:self.viewController isUserCenter:YES isRealNameFail:YES];
            }else{
                // 原来的逻辑保持不变
                // 防沉迷控制
                if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
                    [self showRealNameAlterViewRootViewController:self.viewController isUserCenter:YES];
                }
            }
            
            
        }
        
    }
    
    

    
}

- (void)realNameAutheTipAction{
    
    // 防沉迷控制
    if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
        [self showRealNameAlterViewRootViewController:self.viewController isUserCenter:YES];
    }
     
}

- (void)realNameAuthenticationCanClose:(NSNotification *)noti{
    // 防沉迷控制
    if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
        [self showVerifyRealNameAlterViewRootViewController:self.viewController];
    }
}


- (void)selectItemAction:(NSNotification *)noti{
    
    NSString *string = noti.object;
    
    switch ([string intValue]) {
        case 10:
            [self showRealNameAlterViewRootViewController:self.viewController isUserCenter:YES];
            break;
        case 20:
            [self showOrderViewTipAlterViewRootViewController:self.viewController];
            break;
        case 30:
            [self showCustomerAlterViewRootViewController:self.viewController];
            break;
        default:
            break;
    }
   
    
    
}

- (void)userCenterBinDingAccount{
    [self showBindingAlterViewRootViewController:self.viewController];


}

- (void)fixUserIconAction{
    [self showIconCenterAlterViewRootViewController:self.viewController];
}
- (void)loginFailAction:(NSNotification *)noti{
    NSError *error = noti.object;
    if (error != nil) {
        if (error.code == 2234) {
            // 防沉迷控制
            if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
                [self showRealNameAlterViewRootViewController:self.viewController isUserCenter:NO];
            }
        }else if(error.code == 2235 ){ // 固定时间不可玩
            if ([LKControlUtil isOpenStopAddiction] == YES){
                [self nonageForbidPlayGameWithError:error];
            }
            
        }else if(error.code == 2236 ){ // 类型时长超出
            if ([LKControlUtil isOpenStopAddiction] == YES){
                [self nonagePlayTimeExpireWithTime:3610];
            }
        }else{
            [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
        }
    }

}
- (void)autologinFailAction:(NSNotification *)noti{
    NSError *error = noti.object;
    if (error.code == 2234) {
        // 防沉迷控制
   
        if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
            [self showRealNameAlterViewRootViewController:self.viewController isUserCenter:NO];
        }
        
    }else if(error.code == 2235 ){ // 固定时间不可玩
        if ([LKControlUtil isOpenStopAddiction] == YES){
            [self nonageForbidPlayGameWithError:error];
        }
        
    }else if(error.code == 2236 ){ // 类型时长超出
        if ([LKControlUtil isOpenStopAddiction] == YES){
            [self nonagePlayTimeExpireWithTime:3610];
        }
    }else{
        [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
    }

}


- (void)blockedAccountNotification:(NSNotification *)noti {
    NSDictionary *info =  noti.userInfo;
    NSString *message = info[@"desc"];
    [self showAlterBlockedAccountWithMessage:message];
}


- (void)showAlterBlockedAccountWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
         [self.viewController presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)wecomeChangeAccountAction{

    [self stopRequestTime];
    self.isStopRequest = YES;
    [self hiddenFloatViewDashboard];
    // 移除用户信息
    [LKUser removeUserInfo];
    [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
    
}


- (void)changeAccountAction{
    
    [self logOutSDKPrivate:NO];
    if ([self.delegate respondsToSelector:@selector(changeAccountCallBack)]) {
        [self.delegate changeAccountCallBack];
    }

}


- (void)forgetPasswordAction{
    [self showRestPwdAlterViewRootViewController:self.viewController];
}







#pragma mark -- 展现控制器

- (void)showLoginAlterViewRootViewController:(UIViewController *)viewController withAgreement:(BOOL)agreement{

    LKAlterLoginViewController *alterBaseViewController = [[LKAlterLoginViewController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    alterBaseViewController.agreement = agreement;
    alterBaseViewController.loginCompleteCallBack = ^(LKUser * _Nonnull user, NSError * _Nonnull error) {
        if (self.loginCompleteCallBack) {
            if (error == nil) {
                [self showFloatViewDashboard:self.viewController];
            }
            self.loginCompleteCallBack(user, error);
            // 更新版本
            [self versionSDKUpdate];
        }
    };
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}
- (void)showWecomeAlterViewRootViewController:(UIViewController *)viewController{
    LKWecomeViewController *alterBaseViewController = [[LKWecomeViewController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    alterBaseViewController.loginCompleteCallBack = ^(LKUser * _Nonnull user, NSError * _Nonnull error) {
        if (self.loginCompleteCallBack) {
            if (error == nil) {
                [self showFloatViewDashboard:self.viewController];
            }
            self.loginCompleteCallBack(user, error);
            // 更新版本
            [self versionSDKUpdate];
        }
    };
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}

- (void)showRestPwdAlterViewRootViewController:(UIViewController *)viewController{
    
    LKRestPwdViewController *restPwdController = [[LKRestPwdViewController alloc] init];
    restPwdController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:restPwdController animated:NO completion:nil];
}

- (void)showFixPwdAlterViewRootViewController:(UIViewController *)viewController{
    
    self.alterBaseViewController = [[LKFixPwdViewController alloc] init];
    self.alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:self.alterBaseViewController animated:NO completion:nil];
}

- (void)showUserCenterAlterViewRootViewController:(UIViewController *)viewController{
    
    LKUserCenterViewController *alterBaseViewController = [[LKUserCenterViewController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}


- (void)showIconCenterAlterViewRootViewController:(UIViewController *)viewController{
    
    self.alterBaseViewController = [[LKIconCenterViewController alloc] init];
    self.alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:self.alterBaseViewController animated:NO completion:nil];
}

- (void)showPayResultAlterViewRootViewController:(UIViewController *)viewController{
    
    self.alterBaseViewController = [[LKPayResultController alloc] init];
    self.alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:self.alterBaseViewController animated:NO completion:nil];
}
- (void)showBindingTipAlterViewRootViewController:(UIViewController *)viewController{
    
    LKBindingTipController *alterBaseViewController = [[LKBindingTipController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}

- (void)showRegisterTipAlterViewRootViewController:(UIViewController *)viewController{
    // 防沉迷控制
//      LKSDKConfig *config = [LKSDKConfig getSDKConfig];
      if ([LKControlUtil isOpenStopAddiction] == NO) { // 关闭了
          return;
      }
    LKRegisterController *alterBaseViewController = [[LKRegisterController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}

- (void)showPayTypeAlterViewRootViewController:(UIViewController *)viewController{
    
    self.alterBaseViewController = [[LKPayTypeController alloc] init];
    self.alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:self.alterBaseViewController animated:NO completion:nil];
}
- (void)showCustomerAlterViewRootViewController:(UIViewController *)viewController{
    
    self.alterBaseViewController = [[LKCustomerController alloc] init];
    self.alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:self.alterBaseViewController animated:NO completion:nil];
}


- (void)showRealNameViewRootViewController:(UIViewController *)viewController complete:(void(^)(BOOL isCancel,NSError * _Nullable error))complete{
    
    if ([LKVisibleControllerUtil alreadyVisibleWithRootViewController:viewController]) {
        return;
    }
    
//    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
    if ([LKControlUtil isOpenStopAddiction] == YES){ // 防沉迷状态开启
        if ([self isRealName] == NO) { // 未实名去实名
            LKRealNameController *realNameController = [[LKRealNameController alloc] init];
            realNameController.modalPresentationStyle = UIModalPresentationCustom;
            if (complete) {
                realNameController.realNameCompeleteCallBack = complete;
            }
            // 显示关闭按钮
            realNameController.isShowClose = YES;
            [self.viewController presentViewController:realNameController animated:NO completion:nil];
        }else{ // 已经实名
            if (complete) {
                complete(NO,nil);
            }
        }
    }else{ // 防沉迷状态关闭
        NSError *error = [self responserErrorMsg:@"防沉迷已关闭" code:-103];
        if (complete) {
            complete(NO,error);
        }
    }
    

}

- (NSError *)responserErrorMsg:(NSString *)msg code:(int)code{
    if (msg.exceptNull == nil) {
        msg = @"系统错误";
    }
    NSString *domain = @"com.linking.sdk.ErrorDomain";
        NSString *errorDesc = NSLocalizedString(msg, @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDesc };
        NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    return error;
}


- (void)showVerifyRealNameAlterViewRootViewController:(UIViewController *)viewController{
    
    if ([LKVisibleControllerUtil alreadyVisibleWithRootViewController:viewController]) {
        return;
    }
    
    LKRealNameController *realNameController = [[LKRealNameController alloc] init];
    realNameController.modalPresentationStyle = UIModalPresentationCustom;
    realNameController.loginCompleteCallBack = ^(LKUser * _Nonnull user, NSError * _Nonnull error) {
        if (self.loginCompleteCallBack) {
            if (error == nil) {
                [self showFloatViewDashboard:self.viewController];
            }
            self.loginCompleteCallBack(user, error);
        }
    };
    realNameController.closeCallBack = ^{
        [self showFloatViewDashboard:self.viewController];
        LKUser *user = [LKUser getUser];
        self.loginCompleteCallBack(user, nil);
    };
    // 可以关闭弹框
    realNameController.isShowClose = YES;
    [viewController presentViewController:realNameController animated:NO completion:nil];
}


// 认证失败再次弹出并且携带提示
- (void)showRealNameAlterViewRootViewController:(UIViewController *)viewController isUserCenter:(BOOL)isUserCenter isRealNameFail:(BOOL)isRealNameFail{
    if ([LKVisibleControllerUtil alreadyVisibleWithRootViewController:viewController]) {
        return;
    }
    
    LKRealNameController *realNameController = [[LKRealNameController alloc] init];
    realNameController.modalPresentationStyle = UIModalPresentationCustom;
    // 认证失败
    realNameController.isRealNameFail = isRealNameFail;
    realNameController.loginCompleteCallBack = ^(LKUser * _Nonnull user, NSError * _Nonnull error) {
        if (isUserCenter == NO) {
            if (self.loginCompleteCallBack) {
                if (error == nil) {
                    [self showFloatViewDashboard:self.viewController];
                }
                self.loginCompleteCallBack(user, error);
                // 更新版本
                [self versionSDKUpdate];
            }
        }
    };

    if (isUserCenter == YES) {
        realNameController.isShowClose = YES;
    }else{
        realNameController.isShowClose = NO;
    }
    [viewController presentViewController:realNameController animated:NO completion:nil];
}

- (void)showRealNameAlterViewRootViewController:(UIViewController *)viewController isUserCenter:(BOOL)isUserCenter{
    
    if ([LKVisibleControllerUtil alreadyVisibleWithRootViewController:viewController]) {
        return;
    }
    
    LKRealNameController *realNameController = [[LKRealNameController alloc] init];
    realNameController.modalPresentationStyle = UIModalPresentationCustom;
    realNameController.loginCompleteCallBack = ^(LKUser * _Nonnull user, NSError * _Nonnull error) {
        if (isUserCenter == NO) {
            if (self.loginCompleteCallBack) {
                if (error == nil) {
                    [self showFloatViewDashboard:self.viewController];
                }
                self.loginCompleteCallBack(user, error);
                // 更新版本
                [self versionSDKUpdate];
            }
        }
    };

    if (isUserCenter == YES) {
        realNameController.isShowClose = YES;
    }else{
        realNameController.isShowClose = NO;
    }
    [viewController presentViewController:realNameController animated:NO completion:nil];
}


- (void)showCrazyTipAlterViewRootViewController:(UIViewController *)viewController withTitle:(NSString *)title withTip:(NSString *)tip isShowClose:(BOOL)isShowClose{
    
    
    LKCrazyTipController *alterBaseViewController = [[LKCrazyTipController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    alterBaseViewController.tip = tip;
    alterBaseViewController.isShowClose = isShowClose;
    alterBaseViewController.titleStr = title;
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}





- (void)showSubmitIssueViewTipAlterViewRootViewController:(UIViewController *)viewController withIssueStyle:(NSString *)issueType{
    LKSubmitIssueController *alterBaseViewController = [[LKSubmitIssueController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    alterBaseViewController.issueType = issueType;
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}
- (void)showIssueStyleViewTipAlterViewRootViewController:(UIViewController *)viewController{
    LKIssueStyleController *alterBaseViewController = [[LKIssueStyleController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}
- (void)showIssueServiceViewTipAlterViewRootViewController:(UIViewController *)viewController{
    self.alterBaseViewController = [[LKIssueServiceController alloc] init];
    self.alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:self.alterBaseViewController animated:NO completion:nil];
}
- (void)showOrderViewTipAlterViewRootViewController:(UIViewController *)viewController{
    self.alterBaseViewController = [[LKOrderController alloc] init];
    self.alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:self.alterBaseViewController animated:NO completion:nil];
}
- (void)showBindingAlterViewRootViewController:(UIViewController *)viewController{
    
    LKBindingController *alterBaseViewController = [[LKBindingController alloc] init];
    
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    alterBaseViewController.bindingAccountCompleteCallBack = ^(LKUser * _Nullable user, NSError * _Nullable error) {
      
        if (self.bindingAccountCompleteCallBack) {
            self.bindingAccountCompleteCallBack(user, error);
        }
    };
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}

- (void)showUseAgreementViewRootViewController:(UIViewController *)viewController withAgreement:(BOOL)agreement withType:(NSInteger)type{
    LKUseAgreementController *alterBaseViewController = [[LKUseAgreementController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    alterBaseViewController.agreement = agreement;
    alterBaseViewController.type = type;
    [viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}


- (void)autoLogin{

    LKUser *user = [LKUser getUser];
    if (user != nil) {
         [self showWecomeAlterViewRootViewController:self.viewController];
    }else{
       
        [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
    }
 
}

- (void)versionSDKUpdate{
    LKSDKConfig *sdkConfig = [LKSDKConfig getSDKConfig];
    BOOL flag =  [sdkConfig.updateGame[@"cancelFlag"] boolValue];
    if (flag == true) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LKVersion shared] checkVersion];
        });
    }
    
    [LKVersion shared].goUpdateCallback = ^{
        LKUser *user = [LKUser getUser];
        if (user == nil && user.userId.exceptNull == nil) {
            [self showLoginAlterViewRootViewController:self.viewController withAgreement:YES];
        }
    };
}



//- (UIViewController *)topMostController{
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    UIViewController * topController = window.rootViewController;
////    while (topController.presentedViewController != nil) {
////        topController = topController.presentedViewController;
//;
//    return topController;
//}
@end

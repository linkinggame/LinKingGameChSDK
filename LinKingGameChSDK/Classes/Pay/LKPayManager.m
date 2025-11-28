
#import "LKPayManager.h"
#import "LKOrderApi.h"

#import "LKPayTypeController.h"
#import "LKPayResultController.h"
#import "LKApplePayManager.h"
#import "LKRealNameController.h"
#import "LKUser.h"
#import "NSObject+LKUserDefined.h"
#import "LKSDKConfig.h"
#import "LKRealNameVerifyFactory.h"
#import "LKControlUtil.h"
#import "LKRealVerifyEvent.h"
#import "LKConcreteRealNameVerify.h"
#import "LKWebPayViewController.h"
#import "LKLog.h"
#import "LKSDKManager.h"
#import "LKTaptapUpload.h"

@interface LKPayManager ()
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) UIViewController *viewController;
@end

static LKPayManager *_instance = nil;
@implementation LKPayManager {
    LKWebPayViewController *_webPayVC;
}


- (void)showPayTypeAlterViewRootViewController:(UIViewController *)viewController parameters:(NSDictionary *)parames complete:(void(^)(NSDictionary * _Nullable result,NSError * _Nullable error ))complete{
    
    self.viewController = viewController;
    
    if ([[LKRealNameVerifyFactory createRealNameVerify] isRealName] == NO) {

        [self alterShowParameters:parames complete:complete];
        
    }else{ // 去支付
        [self goToPayParameters:parames complete:complete];
    }

}

// =====================================
- (void)showPayViewRootViewController:(UIViewController *)viewController productId:(NSString *)productId parameters:(NSDictionary *)parames complete:(INAPPPurchCompletionHandle)complete{
    self.viewController = viewController;
    
    if ([[LKRealNameVerifyFactory createRealNameVerify] isRealName] == NO) { // 未实名
        
        if ([LKControlUtil payLimintSwitch] == YES) {
            [self startPurchWithID:productId parames:parames completeHandle:complete];
        }else{
            // 去实名
            // 弹框
            [self alterNewShowParameters:parames productId:productId complete:complete];
        }
        
    }else{ // 去支付
        [self startPurchWithID:productId parames:parames completeHandle:complete];
    }
}

- (void)alterNewShowParameters:(NSDictionary *)parames productId:(NSString *)productId complete:(INAPPPurchCompletionHandle)complete{
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"提示" message:@"应监管部门要求，为保障您的权益，请你进行实名注册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if (complete) {
            complete(INAPPPurchCancle,[self responserErrorMsg:@"取消支付" code:-100]);
        }
    }];
    UIAlertAction *confimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self goToNewRealNameParameters:parames productId:productId complete:complete];
        
    }];
    [alertControler addAction:cancelAction];
    [alertControler addAction:confimAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControler animated:YES completion:^{
        
    }];
}
- (void)goToNewRealNameParameters:(NSDictionary *)parames productId:(NSString *)productId complete:(INAPPPurchCompletionHandle)complete{
    LKRealNameController *realNameController = [[LKRealNameController alloc] init];
    realNameController.modalPresentationStyle = UIModalPresentationCustom;
    realNameController.loginCompleteCallBack = ^(LKUser * _Nonnull user, NSError * _Nonnull error) {
        if (error == nil) {
//            [self startPurchWithID:productId parames:parames completeHandle:complete];
            // 重新去点击支付
        }else{
            if (complete != nil) {
                complete(INAPPPurchFailed,error);
            }
        }
    };
    
    realNameController.closePayCallBack = ^{
        if (complete) {
            complete(INAPPPurchCancle,[self responserErrorMsg:@"取消支付" code:-100]);
        }
    };
    
    realNameController.isShowClose = YES;
    [self.viewController presentViewController:realNameController animated:NO completion:nil];
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

// =====================================
- (void)alterShowParameters:(NSDictionary *)parames complete:(void(^)(NSDictionary * _Nullable result,NSError * _Nullable error ))complete{
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"提示" message:@"应监管部门要求，为保障您的权益，请你进行实名注册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *confimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self goToRealNameParameters:parames complete:complete];
    }];
    [alertControler addAction:cancelAction];
    [alertControler addAction:confimAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControler animated:YES completion:^{
        
    }];
}


- (void)goToRealNameParameters:(NSDictionary *)parames complete:(void(^)(NSDictionary * _Nullable result,NSError * _Nullable error ))complete{
    LKRealNameController *realNameController = [[LKRealNameController alloc] init];
    realNameController.modalPresentationStyle = UIModalPresentationCustom;
    realNameController.loginCompleteCallBack = ^(LKUser * _Nonnull user, NSError * _Nonnull error) {

        [self goToPayParameters:parames complete:complete];
        
    };
    realNameController.isShowClose = YES;
    [self.viewController presentViewController:realNameController animated:NO completion:nil];
}


- (void)goToPayParameters:(NSDictionary *)parames complete:(void(^)(NSDictionary * _Nullable result,NSError * _Nullable error ))complete{
    NSString *cp_order_no =  parames[@"cp_order_no"];
    

    LKPayTypeController *alterBaseViewController = [[LKPayTypeController alloc] init];
    alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
    alterBaseViewController.parameters = parames;
    alterBaseViewController.completeCallBack = ^(UIViewController * _Nonnull viewController, NSDictionary * _Nonnull reult, NSError * _Nullable error) {
        if (complete) {
            
            complete(reult,error);

            NSString *errorStr = error.localizedDescription;
            NSMutableDictionary *result_Dict = [NSMutableDictionary dictionary];
            if (error == nil) {
                [result_Dict setObject:@"YES" forKey:@"result"];
                [result_Dict setObject:@"" forKey:@"error"];
                [result_Dict setObject:cp_order_no forKey:@"orderNum"];
            
            }else{
                [result_Dict setObject:@"NO" forKey:@"result"];
                [result_Dict setObject:errorStr forKey:@"error"];
                [result_Dict setObject:cp_order_no forKey:@"orderNum"];
             
            }
            [viewController dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYRESULT" object:result_Dict];
            }];
        }
    };

 
    [self.viewController presentViewController:alterBaseViewController animated:NO completion:nil];
}





+ (instancetype)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKPayManager alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(payResult:) name:@"PAYRESULT" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(htmlPayment:) name:@"htmlPaymentNotification" object:nil];
    });
    return _instance;
}


- (void)htmlPayment:(NSNotification *)notificationt {
    if (_webPayVC != nil) {
        [_webPayVC.navigationController dismissViewControllerAnimated:YES completion:nil];
        _webPayVC = nil;
    }
}

- (void)payResult:(NSNotification *)notification{
    
    
    NSDictionary *dict = notification.object;
    NSString *result = dict[@"result"];
    NSString *error = dict[@"error"];
    NSString *orderNum = dict[@"orderNum"];
    if ([result isEqualToString:@"YES"]) {
        LKPayResultController *alterBaseViewController = [[LKPayResultController alloc] init];
        alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
        alterBaseViewController.error = @"";
        alterBaseViewController.result = result;
        alterBaseViewController.orderNum = orderNum;
        [self.viewController presentViewController:alterBaseViewController animated:NO completion:nil];
    }else{
        LKPayResultController *alterBaseViewController = [[LKPayResultController alloc] init];
        alterBaseViewController.modalPresentationStyle = UIModalPresentationCustom;
        alterBaseViewController.error = error;
        alterBaseViewController.orderNum = orderNum;
        alterBaseViewController.result = result;
        [self.viewController presentViewController:alterBaseViewController animated:NO completion:nil];
    }
}


///拉取所有商品信息(适用于苹果内购)
- (void)requestProductDatasComplete:(void(^_Nullable)(NSError * _Nullable error, NSArray*_Nullable products))complete;{
//     [[LKApplePay shared] requestProductDatasComplete:complete];
    [[LKApplePayManager shared] requestProductDatasComplete:complete];
    
}

/**
 国内IOS SDK切支付功能需求：
 1）常规时间隐藏切支付功能
 2）有功能开关，开启时打开支付切换功能，关闭时走正常支付流程（IOS支付），该功能由后台控制  third_open_pay  第三方支付是否开启
 3）切支付功能开启后有显示条件，即玩家账号达到条件时才显示给该玩家
 显示条件：当玩家账号充值金额累计达到 XXX 金额时（金额可后台设置，当设置为0时，就是对所有账号开放），点击发起充值时会自动切换支付   recharge_pay  重置金额
 4）切支付后为网页支付形式，接入现有官包支付（微信支付，支付宝支付，银联）
 */
///开始内购(适用于苹果内购)
- (void)startPurchWithID:(NSString *)purchID parames:(NSDictionary *)parames completeHandle:(INAPPPurchCompletionHandle)handle{
    
    // TODO:这里判断是否需要web支付
    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
    
    LKUser *user = [LKUser getUser];
//    if (config.rechargePay.exceptNull == nil) {
//        config.rechargePay = [NSNumber numberWithInt:0];
//    }
//    if (user.payAmount.exceptNull == nil) {
//        user.payAmount = @"0";
//    }
  
    LKLogInfo(@">>>>rechargePay:%@",config.rechargePay);
    LKLogInfo(@">>>>payAmount:%@",user.payAmount);
  
    //config.thirdOpenPay = [NSNumber numberWithBool:YES];
    
    
    if ([config.thirdOpenPay boolValue]) { // 开启web 支付
        LKLogInfo(@">>>>支付进入=============webview");
        if (user.payAmount.exceptNull == nil || config.rechargePay.exceptNull == nil) {
//            [self startSystemPurchWithID:purchID parames:parames completeHandle:handle];
            [self startWebPurchWithID:purchID parames:parames completeHandle:handle];
        } else {
            NSDecimalNumber *limtPayAmount = [[NSDecimalNumber alloc] initWithString:[config.rechargePay stringValue]];
            NSDecimalNumber *userPayAmount = [[NSDecimalNumber alloc] initWithString:user.payAmount];
            
            if ([userPayAmount compare:limtPayAmount] == NSOrderedDescending) { // 用户金额大于限制金额
                // userPayAmount > limtPayAmount
                [self startWebPurchWithID:purchID parames:parames completeHandle:handle];
            } else if ([userPayAmount compare:limtPayAmount] == NSOrderedSame) {
                // userPayAmount == limtPayAmount
                [self startWebPurchWithID:purchID parames:parames completeHandle:handle];
            } else {
                [self startSystemPurchWithID:purchID parames:parames completeHandle:handle];
                //[self startWebPurchWithID:purchID parames:parames completeHandle:handle];
            }
        }
       
    } else {  // 未开启web支付
        LKLogInfo(@">>>>支付进入=============内购");
        [self startSystemPurchWithID:purchID parames:parames completeHandle:handle];
    }
    
}


- (void)startWebPurchWithID:(NSString *)purchID parames:(NSDictionary *)parames completeHandle:(INAPPPurchCompletionHandle)handle {
     LKWebPayViewController *vc = [[LKWebPayViewController alloc] init];
     _webPayVC = vc;
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
     nav.modalPresentationStyle = UIModalPresentationCustom;
     vc.productId = purchID;
     vc.parames = parames;
     vc.payHandler = ^(NSInteger type) {
         if (handle) {
             switch (type) {
                 case 0:
                     handle(INAPPPurchSuccess, nil);
                     break;
                 case 1:
                     handle(INAPPPurchFailed, [self responserErrorMsg:@"pay failed" code:-1002]);
                     break;
                 default:
                     handle(INAPPPurchCancle, [self responserErrorMsg:@"pay cancle" code:-1003]);
                     break;
             }
         }
     };
     [self.viewController presentViewController:nav animated:YES completion:nil];
  
}

- (void)startSystemPurchWithID:(NSString *)purchID parames:(NSDictionary *)parames completeHandle:(INAPPPurchCompletionHandle)handle {
    [[LKApplePayManager shared] statrtProductWithId:purchID parames:parames completeHandle:^(PurchType type, NSError * _Nullable error) {
        if (handle) {
            NSLog(@"支付回调开始...");
            NSString *amount = parames[@"amount"];
            NSString *orderId = parames[@"cp_order_no"];
            NSString *payReason = parames[@"product_id"];
            NSString *payType = @"CNY";
            NSString *payMethod = @"苹果内购";
            int amountNum =(int) round([amount floatValue] * 100);
            LKLogInfo(@"amount = %@, orderId=%@", amount, orderId);
            // INAPPPurchCancle取消 INAPPPurchSuccess成功
            if (type == INAPPPurchSuccess) { // 购买成功
                NSLog(@"支付成功开始引力引擎上报...");
                [[LKSDKManager instance] geTrackPayEventWithAmount:amountNum withPayType:payType withOrderId:orderId withPayReason:payReason withPayMethod:payMethod
                ];
                NSLog(@"支付成功开始上报php接口...");
                [LKTaptapUpload uploadTaptapType:@"3" withAmount:amount withPayType:payMethod complete:nil];
            }
            handle((int)type,error);
        }
    }];
}


/// 查询订阅(适用于苹果内购)
// 查询订阅
- (void)querysubscribeProduct:(NSString *)productId complete:(void(^)(NSError *error, NSDictionary*results))complete
{
    
//    [[LKApplePay shared] querysubscribeProduct:productId Complete:complete];
}

@end



#import "LKPayTypeController.h"
#import "LKPayTypeView.h"
#import "LKPayManager.h"
#import "LKOrderApi.h"
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
#import "LKApplePayManager.h"
@interface LKPayTypeController ()<LKApplePayManagerDelegate>
//@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
//@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, copy) NSString *orderId;
@end
/*
6002——网络错误
6001--取消支付
8000--没有商品
9000——订单支付成功
4000——订单支付失败
**/
@implementation LKPayTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showPayTypeView];
}


//- (UIView *)maskView{
//    if (!_maskView) {
//        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreen_LE_Width, kScreen_LE_Height)];
//        _maskView.backgroundColor =[UIColor colorWithWhite:0.2 alpha:0.6];
//        self.spinnerView = [[MMMaterialDesignSpinner alloc] init];
//        self.spinnerView.center = CGPointMake(kScreen_LE_Width * 0.5, kScreen_LE_Height * 0.5);
//        self.spinnerView.bounds = CGRectMake(0, 0, 60, 60);
//        self.spinnerView.lineWidth = 4.0f;
//        self.spinnerView.tintColor = [UIColor colorWithRed:220/255.0 green:92/255.0 blue:89/255.0 alpha:1];
//        [_maskView addSubview:self.spinnerView];
//    }
//    return _maskView;
//}
//- (void)showMaskView{
//    [self.view addSubview:self.maskView];
//
//    [self.spinnerView startAnimating];
//}
//
//- (void)hiddenMaskView{
//    [self.maskView removeFromSuperview];
//
//    [self.spinnerView stopAnimating];
//}

- (void)showPayTypeView{

    LKPayTypeView *payTypeView = [LKPayTypeView instancePayTypeView];
    [self.view insertSubview:payTypeView atIndex:self.view.subviews.count];
    payTypeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:payTypeView]; 
    CGFloat width =  [UIScreen mainScreen].bounds.size.width - 50;
    // 检测是否是ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        width = 350;
    }
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:267];
    [self layoutConstraint];
    
    
    
    payTypeView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    
    payTypeView.selectPayTypeCallBack = ^(UIButton * _Nonnull sender) {
        [self showMaskView];
        [self applePay];
    };
    

    NSString *cp_order_no = [NSString stringWithFormat:@"%@",self.parameters[@"cp_order_no"]];
    NSString *goodsName = [NSString stringWithFormat:@"%@",self.parameters[@"product_desc"]];
    NSString *amount = [NSString stringWithFormat:@"%@",self.parameters[@"amount"]];
    payTypeView.label_game_orderNum.text =cp_order_no;
    payTypeView.label_name.text = goodsName;
    payTypeView.label_price.text = [NSString stringWithFormat:@"￥%@",amount];
    
    
}


/*
 SIAPPurchSuccess = 0,       // 购买成功
 SIAPPurchFailed = 1,        // 购买失败
 SIAPPurchCancle = 2,        // 取消购买
 SIAPPurchVerFailed = 3,     // 订单校验失败
 SIAPPurchVerSuccess = 4,    // 订单校验成功
 SIAPPurchNotArrow = 5,      // 不允许内购
 SIAPPurchNoGoods = 6,       // 没有商品
 
 **/
- (void)applePay{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    [parameters setObject:@"ios" forKey:@"type"];
   // parameters[@"product_id"] = @"com.peopleracingcar.linking.consumeAd";
    NSString *product_id = parameters[@"product_id"];
    [[LKApplePayManager shared] setContentView:self.view];
    [LKApplePayManager shared].delegate = self;
    [[LKApplePayManager shared] statrtProductWithId:product_id parames:parameters completeHandle:^(PurchType type, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (type == PurchSuccess) {
                if (self.orderId.exceptNull != nil) {
                     NSDictionary *result = @{@"orderId":self.orderId};
                     self.completeCallBack(self,result, nil);
                }else{
                     self.completeCallBack(self,nil, nil);
                }

            }else if (type == PurchFailed){
                NSError *error = [self responserErrorMsg:@"支付失败" code:4000];
                self.completeCallBack(self,nil, error);
            }else if (type == PurchCancle){
                NSError *error = [self responserErrorMsg:@"取消支付" code:6001];
                 self.completeCallBack(self,nil, error);
            }else if (type == PurchNoGoods){
                NSError *error = [self responserErrorMsg:@"没有商品" code:8000];
//                [self.view makeToast:error.localizedDescription];
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
            }else if (type == PurchRestoredGoods){
                 NSError *error = [self responserErrorMsg:@"已经购买过该商品" code:8001];
                self.completeCallBack(self,nil, error);
//                 [self.view makeToast:error.localizedDescription];
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
            }else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
                [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
            }
            [self hiddenMaskView];
        });
        

    }];
    
    
}


- (void)storePayCreateOrderId:(NSString *)orderId withError:(NSError *)error{
    self.orderId = orderId;
}


- (void)payType:(PAYTYPE)type withParameters:(NSDictionary *)parames complete:(void(^)(NSError *error,BOOL success))complete{
    
    
}



- (void)createOrderType:(PAYTYPE)type withParameters:(NSDictionary *)parames complete:(void(^)(NSError *error, NSDictionary*result))complete{
    
    NSString *typeStr = @"ios";
    
    [LKOrderApi createOrderType:typeStr withParameters:parames complete:^(NSError * _Nonnull error, NSDictionary * _Nonnull result) {
        
        if (complete) {
            complete(error,result);
        }
    }];
}



- (NSError *)responserErrorMsg:(NSString *)msg code:(int)code{
    NSString *domain = @"com.linking.sdk.ErrorDomain";
        NSString *errorDesc = NSLocalizedString(msg, @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDesc };
        NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    return error;
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

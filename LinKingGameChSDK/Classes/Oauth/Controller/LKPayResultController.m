

#import "LKPayResultController.h"
#import "LKPayResultView.h"
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
#import "LKLog.h"
@interface LKPayResultController ()

@end

@implementation LKPayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showPayResultView];
    
}
- (void)showPayResultView{

    LKPayResultView *payResultView = [LKPayResultView instancePayResultView];
    [self.view insertSubview:payResultView atIndex:self.view.subviews.count];
    payResultView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:payResultView];
    CGFloat width = 300;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:264];
    [self layoutConstraint];
    
    payResultView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
   
    if ([self.result isEqualToString:@"YES"]) {
        LKLogInfo(@"支付成功...");
        payResultView.imageView_picture.image = [UIImage lk_ImageNamed:@"pay-success"];
        payResultView.label_desc.text = [NSString stringWithFormat:@"您购买的商品已到账，请回到游戏查收订单号"];
//        payResultView.label_desc.text = [NSString stringWithFormat:@"您购买的商品已到账，请回到游戏查收订单号:%@",self.orderNum];

        
    }else{
        payResultView.label_desc.font = [UIFont systemFontOfSize:16];
        LKLogInfo(@"支付失败...");
        payResultView.imageView_picture.image = [UIImage lk_ImageNamed:@"pay-fail"];
        //payResultView.label_desc.text = [NSString stringWithFormat:@"%@:%@",self.error,self.orderNum];
        payResultView.label_desc.text = [NSString stringWithFormat:@"%@",self.error];
       
    }
    
    
    
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

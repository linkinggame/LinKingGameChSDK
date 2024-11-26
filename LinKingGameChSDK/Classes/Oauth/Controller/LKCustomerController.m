

#import "LKCustomerController.h"
#import "LKCustomerView.h"
#import "LKIssueApi.h"
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
#import "LKSDKConfig.h"
@interface LKCustomerController ()
@property (nonatomic, strong) NSArray *dataSources;


@end

@implementation LKCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadListDatas];
    [self showCustomerView];
}
- (void)showCustomerView{

    LKCustomerView *customerView = [LKCustomerView instanceCustomerView];
    [self.view insertSubview:customerView atIndex:self.view.subviews.count];
    customerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:customerView];
    CGFloat width = 320;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:200];
    [self layoutConstraint];
    
    
    customerView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    customerView.commitIssueCallBack = ^{
        
       [self dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CommitIssueStyle" object:nil];
        }];
        
        
    };
    
    customerView.readIssueCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadIssue" object:nil];
        }];
    };
    

    
    
    
}


- (void)openQQ:(NSString *)qqNum{
    //是否安装QQ
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        NSString *qqStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNum];
         NSURL *url =  [NSURL URLWithString:qqStr];
        [[UIApplication sharedApplication] openURL:url];
        
    }else{
//        [self.view makeToast:@"未安装QQ"];
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.view makeToast:@"未安装QQ" duration:2 position:CSToastPositionCenter style:style];
    }
    

}


- (void)loadListDatas{
    [LKIssueApi fetchIssueListComplete:^(NSError * _Nonnull error, NSDictionary * _Nonnull result) {
        if (error == nil) {
            NSArray *datas =result[@"types"];
            self.dataSources = datas;
          LKSDKConfig *config = [LKSDKConfig getSDKConfig];
           
        }else{
//            [self.view makeToast:error.localizedDescription];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
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

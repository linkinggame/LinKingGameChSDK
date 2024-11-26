

#import "LKUseAgreementController.h"
#import "LKUseAgreementView.h"
#import <WebKit/WebKit.h>
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
@interface LKUseAgreementController ()
@property (strong, nonatomic)  WKWebView *webView;
@property (nonatomic, strong)  LKUseAgreementView *useAgreementVie;
@end

@implementation LKUseAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUseAgreementView];
}


- (void)showUseAgreementView{

    LKUseAgreementView *useAgreementView = [LKUseAgreementView instanceUseAgreementView];
    self.useAgreementVie = useAgreementView;
    [self.view insertSubview:useAgreementView atIndex:self.view.subviews.count];
    useAgreementView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:useAgreementView];
    CGFloat width = 300;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:408];
    [self layoutConstraint];
    
    
    useAgreementView.sureCallBack = ^(BOOL isSelect) {
        [self dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BACKUSEAGREEMENT" object:[NSNumber numberWithBool:isSelect]];
        }];
       
    };
    
    if (self.agreement) {
         [useAgreementView.button_checkBox setBackgroundImage:[UIImage lk_ImageNamed:@"checkmark"] forState:UIControlStateNormal];
         useAgreementView.button_checkBox.selected = YES;
    }else{
         [useAgreementView.button_checkBox setBackgroundImage:[UIImage lk_ImageNamed:@"frame"] forState:UIControlStateNormal];
         useAgreementView.button_checkBox.selected = NO;
    }
    
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
       WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
       self.webView = webView;
       webView.backgroundColor = [UIColor colorWithRed:226/255.0 green:225/255.0 blue:228/255.0 alpha:1];
  
       [useAgreementView.view_content addSubview:webView];
    

//        self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40 - 20, useAgreementView.view_content.frame.size.height);
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:useAgreementView.view_content attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
      
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:useAgreementView.view_content attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:useAgreementView.view_content attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:useAgreementView.view_content attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [useAgreementView.view_content addConstraints:@[left,right,top,bottom]];
       
      LKSDKConfig *sdkConfig = [LKSDKConfig getSDKConfig];

    if (self.type == 10) {
        NSString *privacypolicy = sdkConfig.auth_config[@"licenseagreement"];
         
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:privacypolicy]]];
        useAgreementView.label_title.text = @"使用协议";

    }else{
      NSString *privacypolicy = sdkConfig.auth_config[@"privacypolicy"];
   
      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:privacypolicy]]];
        useAgreementView.label_title.text = @"隐私条款";
    }
    
//       NSString *privacypolicy = sdkConfig.auth_config[@"privacypolicy"];
//       [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:privacypolicy]]];
   
}


- (void)loadAgreement{
    
    
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

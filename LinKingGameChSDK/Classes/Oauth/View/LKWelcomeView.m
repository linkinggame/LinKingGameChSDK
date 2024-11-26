

#import "LKWelcomeView.h"
#import "MONActivityIndicatorView.h"
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
#import "LKRealNameVerifyFactory.h"
@interface LKWelcomeView ()<MONActivityIndicatorViewDelegate>

@end

@implementation LKWelcomeView


+ (instancetype)instanceWecomeView{
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKWelcomeView *view = [[bundle loadNibNamed:@"LKWelcomeView" owner:nil options:nil] firstObject];
    
    view.button_change_account.layer.borderColor = [UIColor colorWithRed:155/255.0 green:154/255.0 blue:154/255.0 alpha:1].CGColor;
    view.button_change_account.layer.borderWidth = 1;
    view.button_change_account.layer.cornerRadius = 6;
    view.button_change_account.clipsToBounds = YES;
    [view addIndicatorView];
    view.label_account.adjustsFontSizeToFitWidth = YES;
    [view loadUserInfo];
    
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    
    return view;
}

- (IBAction)changeAccountAction:(UIButton *)sender {
    if (self.changeAccountAction) {
        self.changeAccountAction(sender);
    }
}

- (void)loadUserInfo{
   LKUser *user =  [LKUser getUser];
    if (user != nil) {
        if ([user.login_type isEqualToString:@"Ios"]){
            if ([[LKRealNameVerifyFactory createRealNameVerify] isRealName]) {
                self.label_account.attributedText = [self formatOriginString:user.real_name markString:@"(Apple)" font:[UIFont systemFontOfSize:14]];
            }else{
               self.label_account.attributedText = [self formatOriginString:@"iOS" markString:@"(Apple)" font:[UIFont systemFontOfSize:14]];
            }
        }else if ([user.login_type isEqualToString:@"Phone"]){
            self.label_account.attributedText = [self formatOriginString:user.phone markString:@"(手机号)" font:[UIFont systemFontOfSize:14]];
        }else if ([user.login_type isEqualToString:@"Guest"]){
            self.label_account.text = @"游客";;
        }else if ([user.login_type isEqualToString:@"Passport"]){
            self.label_account.attributedText = [self formatOriginString:user.phone markString:@"(账号)" font:[UIFont systemFontOfSize:14]];
        } else{
            self.label_account.text = @"";
        }
       
    }
}

- (NSAttributedString *)formatOriginString:(NSString *)originString markString:(NSString *)markString font:(UIFont *)font{
     NSString *infoStr = [NSString stringWithFormat:@"%@%@",originString,markString];
     NSAttributedString *str = [[NSAttributedString alloc] initWithString:infoStr];
     NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:str];
     NSRange range = NSMakeRange(originString.length,markString.length);
     [text addAttribute:NSFontAttributeName value:font range:range]; // 14
     return text;
}


- (void)addIndicatorView{
   MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
   indicatorView.delegate = self;
   indicatorView.numberOfCircles = 8;
   indicatorView.radius = 6;
   indicatorView.internalSpacing = 8;
   [indicatorView startAnimating];
   [self.view_Indicator addSubview:indicatorView];
    
    
    [self.view_Indicator addConstraint:[NSLayoutConstraint constraintWithItem:indicatorView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view_Indicator
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view_Indicator addConstraint:[NSLayoutConstraint constraintWithItem:indicatorView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view_Indicator
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
}




- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
//    CGFloat red   = (arc4random() % 256)/255.0;
//    CGFloat green = (arc4random() % 256)/255.0;
//    CGFloat blue  = (arc4random() % 256)/255.0;
//    CGFloat alpha = 1.0f;
    return [UIColor orangeColor];
}

@end

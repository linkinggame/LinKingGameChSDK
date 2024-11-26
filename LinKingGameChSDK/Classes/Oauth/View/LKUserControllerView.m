

#import "LKUserControllerView.h"
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
#import "LKLog.h"
@interface LKUserControllerView ()
@property (nonatomic, assign) BOOL isAlreadyCopy;
@end

@implementation LKUserControllerView

+ (instancetype)instanceUserControllerView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKUserControllerView *view = [[bundle loadNibNamed:@"LKUserControllerView" owner:nil options:nil] firstObject];
    
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    
    view.view_msg_circle.layer.cornerRadius = 5;
    view.view_msg_circle.clipsToBounds = YES;
    view.view_msg_circle.hidden = YES;
    
    view.button_binding_account.layer.borderWidth = 1;
    view.button_binding_account.layer.borderColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1].CGColor;
    view.button_binding_account.layer.cornerRadius = 8;
    view.button_binding_account.clipsToBounds = YES;
    
    view.button_change_account.layer.borderWidth = 1;
    view.button_change_account.layer.borderColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1].CGColor;
    view.button_change_account.layer.cornerRadius = 8;
    view.button_change_account.clipsToBounds = YES;
    
    
    view.view_icon.layer.cornerRadius = 32;
    view.view_icon.clipsToBounds = YES;
    
    view.view_icon.layer.borderWidth = 2;
    view.view_icon.layer.borderColor =  [UIColor colorWithRed:199/255.0 green:197/255.0 blue:197/255.0 alpha:1].CGColor;
    
    [view loadUserInfoUpdateView];
    
 
    
    return view;
}

- (IBAction)copyIdAction:(id)sender {
    LKUser *user =[LKUser getUser];
    if (user.userId != nil) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = user.userId;
        [self.contentView makeToast:@"已复制成功到粘贴板"];
    }
    

}


- (void)addLongPressGesture{
    
    self.label_id.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPre:)];
    longpress.minimumPressDuration = 1;
    [self.label_id addGestureRecognizer:longpress];
    
    
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

- (void)copy:(id)sender{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.label_id.text;
}

- (void)longPre:(UILongPressGestureRecognizer *)recongizer{
    
    if (self.isAlreadyCopy == YES) {
        return;
    }
    self.isAlreadyCopy = YES;
    
    
    [self becomeFirstResponder];
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.label_id.frame inView:self.label_id.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAlreadyCopy = NO;
    });
}



- (void)loadUserInfoUpdateView{
    
    LKUser *user =[LKUser getUser];
    
    if (user != nil) {
        
        // 是否绑定第三方
        if (user.third_id.exceptNull != nil) {
            self.imageView_badge.hidden = NO;
            NSString *strInfo = @"";
               if ([user.login_type isEqualToString:@"Ios"]){
                    if ([[LKRealNameVerifyFactory createRealNameVerify] isRealName]) {

                        strInfo = [NSString stringWithFormat:@"%@(Apple)",user.real_name];
                    }else{
                        strInfo = [NSString stringWithFormat:@"%@(Apple)",@"iOS"];
                    }
                    
                }else if ([user.login_type isEqualToString:@"Phone"]){
                    strInfo = [NSString stringWithFormat:@"%@(手机号)",user.phone];
                }else{
                    strInfo =  user.third_type.exceptNull == nil ? @"" : user.third_type;
                }
               
             self.label_tip.text = [NSString stringWithFormat:@"已绑定%@",strInfo];
            self.label_tip.textColor =  [UIColor colorWithRed:37/255.0 green:223/255.0 blue:164/255.0 alpha:1];
//            self.imageView_binding.image = [UIImage lk_ImageNamed:@"binding-02"];
            self.button_binding_account.hidden = YES;
        
        }else{
            self.imageView_badge.hidden = YES;
                       self.label_tip.text = @"未绑定";
                       self.label_tip.textColor =  [UIColor whiteColor];
//            self.imageView_binding.image = [UIImage lk_ImageNamed:@"binding"];
            self.button_binding_account.hidden = NO;
        }
        
        self.label_id.adjustsFontSizeToFitWidth = YES;
        
        self.label_id.text = [NSString stringWithFormat:@"ID:%@",user.userId];
       // 是否实名认证
        RealVerifyState state = [[LKRealNameVerifyFactory createRealNameVerify] getRealVerifyState];
        
        if (state == RealVerifyStateUnverified) {
            self.label_real_name.text = @"实名认证";
        } else if (state ==  RealVerifyStateAuthenticating) {
            
            if (user.real_name.exceptNull != nil && user.id_card.exceptNull != nil) {
                self.label_real_name.text = @"认证中";
            }else{
                self.label_real_name.text = @"实名认证";
            }
            
            
        } else if (state ==  RealVerifyStateVerified) {
            if (user.real_name.exceptNull != nil && user.id_card.exceptNull != nil) {
                self.label_real_name.text = @"已实名认证";
            }else{
                self.label_real_name.text = @"实名认证";
            }
            
        }
        
    }else{
        LKLogInfo(@"⚠️用户信息不存在⚠️%s",__func__);
       
    }
    
}


- (IBAction)closeViewAction:(UIButton *)sender {
    if (self.closeViewAction) {
        self.closeViewAction(sender);
    }
}

- (IBAction)selectItemAction:(UIButton *)sender {
    
    if (self.selectItemAction) {
        self.selectItemAction(sender);
    }
    
}

- (IBAction)changeAccountAction:(UIButton *)sender {
    
    if (self.changeAccountAction) {
        self.changeAccountAction(sender);
    }
    
}

- (IBAction)fixIconAction:(UIButton *)sender {
    if (self.fixIconAction) {
        self.fixIconAction(sender);
    }
}
- (IBAction)bindingAccount:(UIButton *)sender {
    
    if (self.bindingAccountAction) {
        self.bindingAccountAction(sender);
    }
    
}

@end

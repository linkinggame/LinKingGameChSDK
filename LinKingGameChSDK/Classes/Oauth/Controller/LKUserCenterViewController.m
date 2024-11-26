
#import "LKUserCenterViewController.h"
#import "LKUserControllerView.h"
#import "LKUserCenterApi.h"
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
@interface LKUserCenterViewController ()
@property(nonatomic,strong) LKUserControllerView *userCenterView;
@end

@implementation LKUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addobserRedDot:) name:@"REDDOTUPDATE" object:nil];
    
    [self showUserCenterView];
    
    [self loadUserIcon];
}

- (void)addobserRedDot:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    
    NSNumber *question_red_dot = dict[@"question_red_dot"];
    
    
    if ([question_red_dot boolValue]) {
        self.userCenterView.view_msg_circle.hidden = NO;
    }else{
        self.userCenterView.view_msg_circle.hidden = YES;
    }
    
}

#pragma mark -- 获取用户头像
- (void)loadUserIcon{
    
   LKUser * user =[LKUser getUser];
    if (user != nil && user.userId.exceptNull != nil) {
        
        [LKUserCenterApi fetchUserIconcomplete:^(NSError * _Nonnull error, NSArray * _Nonnull data, NSString * _Nonnull icon) {
            if (error == nil) {
                [self.userCenterView.imageView_icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage lk_ImageNamed:@"default-icon"]];
            }
        }];
    }else{
        LKLogInfo(@"⚠️用户信息不存在⚠️%s",__func__);
    }
    
    
}


#pragma mark -- 关闭视图
- (void)closeAlterView{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark -- 选择item
- (void)selectItem:(NSInteger)index{
    
    switch (index) {
        case 10:  // 实名认证
            {
//                BOOL isResult =  [self isCanRealName];
//                if (isResult == NO) {
//                    return;
//                }
            }
            break;
        case 20: // 客户反馈
             
             break;
        case 30: // 我的订单
             
             break;
        case 40: // 账号绑定
        {
            BOOL isResult =  [self isCanBinding];
            if (isResult == NO) {
                return;
            }
        }
             break;
        default:
            break;
    }
    
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectItem" object:[NSString stringWithFormat:@"%ld",(long)index]];
    }];
}


- (BOOL)isCanRealName{
    LKUser *user = [LKUser getUser];
    if (user == nil) {
        LKLogInfo(@"⚠️用户信息不存在⚠️%s",__func__);
        return NO;
    }
    
    if ([[LKRealNameVerifyFactory createRealNameVerify] isRealName] == NO) {
        return YES; // 可以实名
    }else{
//        [self.view makeToast:@"该用户已经实名，无法进行再次实名"];
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.view makeToast:@"该用户已经实名，无法进行再次实名" duration:2 position:CSToastPositionCenter style:style];
         return NO;
    }

    
}

- (BOOL)isCanBinding{
    
    LKUser *user = [LKUser getUser];
    if (user == nil) {
        LKLogInfo(@"⚠️用户信息不存在⚠️%s",__func__);
        return NO;
    }
    
    // 检测当前用户是否能够绑定账号
    if (user.third_id.exceptNull == nil && [user.login_type isEqualToString:@"Guest"]) { // 当前是游客可以进行绑定
        return YES;
        
    }else{ // 其他用户无法绑定
//        [self.view makeToast:@"该用户已经绑定，无法进行再次绑定"];
        
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.view makeToast:@"该用户已经绑定，无法进行再次绑定" duration:2 position:CSToastPositionCenter style:style];
        return NO;
    }

    
}


- (void)bindingAccount{
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCenterBinDingAccount" object:nil];
    }];
}

#pragma mark --修改用户头像
-(void)fixUserIcon{
    
      [self dismissViewControllerAnimated:NO completion:^{
          [[NSNotificationCenter defaultCenter] postNotificationName:@"FixUserIcon" object:nil];
      }];
    
}


#pragma mark --切换账号
-(void)changAccount{
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAccount" object:nil];
    }];
}

- (void)showUserCenterView{
    
    LKUserControllerView *userCenterView  = [LKUserControllerView instanceUserControllerView];
    userCenterView.contentView = self.view;
    self.userCenterView = userCenterView;
    [self.view insertSubview:userCenterView atIndex:self.view.subviews.count];
   // 使用autoLayout约束，禁止将AutoresizingMask转换为约束
    userCenterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:userCenterView];
    
    CGFloat width = 340;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:250];
    [self layoutConstraint];
    
    
    /// 关闭视图
    userCenterView.closeViewAction = ^(UIButton * _Nonnull sender) {
        
        [self closeAlterView];
    };
    
    /// 选中item
    userCenterView.selectItemAction = ^(UIButton * _Nonnull sender) {
        [self selectItem:sender.tag];
    };
    
    
    /// 修改用户头像
    userCenterView.fixIconAction = ^(UIButton * _Nonnull sender) {
        [self fixUserIcon];
    };
    
    /// 切换账号
    userCenterView.changeAccountAction = ^(UIButton * _Nonnull sender) {
        [self changAccount];
    };
    
    userCenterView.bindingAccountAction = ^(UIButton * _Nonnull sender) {
        [self bindingAccount];
    };
    
    
    
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

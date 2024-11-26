

#import "LKIconCenterViewController.h"
#import "LKIconManagerView.h"
#import "LKCollectionView.h"
#import "LKUserCenterApi.h"
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
#import "LKUserEntity.h"
@interface LKIconCenterViewController ()
@property(nonatomic, strong) LKCollectionView *collectionView;
@property(nonatomic, strong) LKIconManagerView *iconManagerView;
@property(nonatomic, copy) NSString *iconId;
@end

@implementation LKIconCenterViewController
- (LKCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[LKCollectionView alloc] initWithFrame:CGRectMake(0, 0, 300-112, self.iconManagerView.view_iconItem.frame.size.height)];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showIconCenterView];
   
}


#pragma mark -- 获取用户头像
- (void)loadUserIcon{
    
    
    LKUser *user =  [LKUser getUser];
    
    if (user != nil) {
        self.iconId = user.head_icon;
    }
    
    [LKUserCenterApi fetchUserIconcomplete:^(NSError * _Nonnull error, NSArray * _Nonnull data, NSString * _Nonnull icon) {
        
        
        [self.iconManagerView.imageView_icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage lk_ImageNamed:@"default-icon"]];
        
        self.collectionView.data = data;
         
        
    }];
    
    __weak typeof(self)weakSelf=self;
    self.collectionView.selectIconCallback = ^(NSString * _Nonnull icon, NSString * _Nonnull iconId) {
        
         [weakSelf.iconManagerView.imageView_icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage lk_ImageNamed:@"default-icon"]];
          weakSelf.iconId = iconId;
    };


}

#pragma mark -- 确认修改用户头像
- (void)sureFixIcon{
    
    [LKUserCenterApi sureFixUserIconWithIconId:self.iconId Complete:^(NSError * _Nonnull error) {
       
        if (error == nil) {
            
            LKUser *user = [LKUser getUser];
            if (user != nil) {
                [LKUserEntity shared].user.head_icon = self.iconId;
            } 
            [self dismissViewControllerAnimated:NO completion:nil];
            
       
        }else{
//            [self.view makeToast:error.localizedDescription];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
        }
        
    }];
    
    
    
}

- (void)showIconCenterView{

    LKIconManagerView *iconManagerView = [LKIconManagerView instanceIconManagerView];
    self.iconManagerView = iconManagerView;
    [self.view insertSubview:iconManagerView atIndex:self.view.subviews.count];

    iconManagerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:iconManagerView];
    
    CGFloat width = 300;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:261];
    [self layoutConstraint];
   
    
    [iconManagerView.view_iconItem addSubview:self.collectionView];
    

    [self loadUserIcon];
    
    iconManagerView.closeAlterViewCallBack = ^(UIButton * _Nonnull sender) {
      
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    
    iconManagerView.cancelCallBack = ^(UIButton * _Nonnull sender) {
      
        [self dismissViewControllerAnimated:NO completion:nil];
        
    };
    
    
    iconManagerView.sureCallBack = ^(UIButton * _Nonnull sender) {
        
        
        [self sureFixIcon];
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

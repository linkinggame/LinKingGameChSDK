
#import "LKSubmitIssueController.h"
#import "LKSubmitIssueView.h"
#import "LKPictureCollectionView.h"
#import "LKGlobalConf.h"
#import "LKIssueApi.h"
#import "LKTextView.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "LKBundleUtil.h"
#import "LKNetUtils.h"
#import "LKLog.h"
@interface LKSubmitIssueController ()<TZImagePickerControllerDelegate>
{
     NSMutableArray *_selectedAssets;
}
@property(nonatomic, strong) LKPictureCollectionView *collectionView;
@property (nonatomic, strong) LKSubmitIssueView *crazyTipView;
@property (nonatomic, strong) TZImagePickerController *imagePickerVc;
@property (nonatomic, strong)  NSMutableArray<UIImage *> *images;
@end

@implementation LKSubmitIssueController
- (LKPictureCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[LKPictureCollectionView alloc] initWithFrame:CGRectMake(0, 0, 322 - 20, self.crazyTipView.view_picture.frame.size.height)];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSubmitIssueView];
    
    self.images = [NSMutableArray arrayWithCapacity:0];
}

- (void)showSubmitIssueView{

    LKSubmitIssueView *crazyTipView = [LKSubmitIssueView instanceSubmitIssueView];
    self.crazyTipView = crazyTipView;
    [self.view insertSubview:crazyTipView atIndex:self.view.subviews.count];
    crazyTipView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:crazyTipView];
//    self.isFullScreen = YES;
//    [self setAlterWidth:[UIScreen mainScreen].bounds.size.width];
//    [self setAlterHeight:[UIScreen mainScreen].bounds.size.height];
    
    [self setAlterWidth:322];
    [self setAlterHeight:480];
    [self layoutConstraint];

    [crazyTipView.view_picture addSubview:self.collectionView];
    
    [crazyTipView setLKSuperView:self.view];
    
    crazyTipView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    
    // 提交数据
    crazyTipView.commitCallBack = ^{
             
        [self commitData];
    };
    
    
 __weak typeof(self)weakSelf = self;
   
    self.collectionView.selectItemCallBack = ^(NSInteger index) {
        [weakSelf.crazyTipView.textView resignFirstResponder];
        [weakSelf showImagePickerController];
    };
    
}



- (void)commitData{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.issueType forKey:@"question_type"];
    [parameters setObject:self.crazyTipView.textView.text forKey:@"question"];
    
    if (self.crazyTipView.textfield_iphone.text.exceptNull != nil) {
        [parameters setObject:self.crazyTipView.textfield_iphone.text forKey:@"contact"];
    }
    
    if (self.crazyTipView.button_checkbox.selected == YES) {
         [parameters setObject:@"true" forKey:@"can_contact"];
    }else{
         [parameters setObject:@"false" forKey:@"can_contact"];
    }
    
    // SDK 版本
    [parameters setObject:[LKBundleUtil getSDKVersion] forKey:@"version"];
    NSString *game_version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // 游戏版本
    [parameters setObject:game_version forKey:@"game_version"];
    // 设备信息
    [parameters setObject:[LKNetUtils deviceInfo] forKey:@"device_info"];
    
    [LKIssueApi commitIssue:self.images parameters:parameters complete:^(NSError * _Nonnull error) {
        
        if (error == nil) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:@"提交成功" duration:2 position:CSToastPositionCenter style:style];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:nil];
            });
        }else{
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
        }
        
    }];
}

- (void)showImagePickerController{
    
    
     CGFloat photoCount = 4;
    if (self.images.count == 0) {
        photoCount = 4;
    }
    
    
    if (photoCount - self.images.count > 1) {
        photoCount = photoCount - self.images.count;
    }else{
        photoCount = 1;
    }
    
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:photoCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    self.imagePickerVc = imagePickerVc;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
               
}


- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    [self.imagePickerVc dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{

    LKLogInfo(@"------>%@",photos);
    
    self.images = (NSMutableArray *)photos;
    [self.collectionView reloadDatas:self.images];
    
    self.crazyTipView.label_imageCount.text = [NSString stringWithFormat:@"%ld/4",(long)self.images.count];
    
    
//
//    NSDictionary *dict = @{@"question_type":@"1",@"question":@"123",@"contact":@"15609631943",@"can_contact":@"true"};
//
//    [LKIssueApi commitIssue:photos parameters:dict];
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

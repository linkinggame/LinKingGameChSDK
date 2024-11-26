

#import "LKIssueStyleController.h"
#import "LKIssueStyleView.h"
#import "LKIssueApi.h"
#import "LKGlobalConf.h"
#import "LKIssueStyleTableView.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
@interface LKIssueStyleController ()
@property (nonatomic, strong) LKIssueStyleView *issueStyleView;
@property (nonatomic, copy) NSArray *dataSources;
@end

@implementation LKIssueStyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showIssueStyleView];
}
- (void)showIssueStyleView{

    LKIssueStyleView *issueStyleView = [LKIssueStyleView instanceIssueStyleView];
    self.issueStyleView = issueStyleView;
    [self.view insertSubview:issueStyleView atIndex:self.view.subviews.count];
    issueStyleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:issueStyleView];

    
    [self setAlterWidth:322];
    [self setAlterHeight:400];
    [self layoutConstraint];
    
    
    issueStyleView.closeAlterViewCallBack = ^{
  
        [self dismissViewControllerAnimated:NO completion:nil];
        
    };

    issueStyleView.tableView.selectItemCallBack = ^(NSDictionary * _Nullable dict, NSInteger index) {
        [self dismissViewControllerAnimated:NO completion:^{
            NSString *issueStyle = self.dataSources[index];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CommitIssue" object:issueStyle];
        }];
       
        
    };
    [self loadListDatas];
}



- (void)loadListDatas{
    [LKIssueApi fetchIssueListComplete:^(NSError * _Nonnull error, NSDictionary * _Nonnull result) {
        if (error == nil) {
            NSArray *datas =result[@"types"];
            self.dataSources = datas;
            [self.issueStyleView.tableView reloadData:datas];
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

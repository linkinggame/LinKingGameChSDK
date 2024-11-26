

#import "LKIssueServiceController.h"
#import "LKIssueServiceView.h"
#import "LKIssueApi.h"
#import "LKGlobalConf.h"
#import "LKIssueServiceTableView.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
@interface LKIssueServiceController ()
@property (nonatomic, strong) LKIssueServiceView *issueServiceView;
@end

@implementation LKIssueServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showIssueStyleView];
   
    [self requestIssueStatus];
}


- (void)showIssueStyleView{

    LKIssueServiceView *issueServiceView = [LKIssueServiceView instanceIssueServiceView];
    self.issueServiceView = issueServiceView;
    [self.view insertSubview:issueServiceView atIndex:self.view.subviews.count];
    issueServiceView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:issueServiceView];
    [self setAlterWidth:322];
    [self setAlterHeight:480];
    [self layoutConstraint];
    
    issueServiceView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
     
   
}


- (void)requestIssueStatus{
    
    [LKIssueApi fetchFeedBookIssueListComplete:^(NSError * _Nonnull error, NSArray * _Nonnull result) {
        if (error == nil) {
            
            [self.issueServiceView.tableview reloadData:result];
            
        }else{
//            [self.view makeToast:error.localizedDescription];
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.view makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter style:style];
        }
    }];
    
}


@end

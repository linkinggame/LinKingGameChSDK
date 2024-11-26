
#import <UIKit/UIKit.h>

@class LKIssueStyleTableView;
NS_ASSUME_NONNULL_BEGIN

@interface LKIssueStyleView : UIView

@property(nonatomic, copy)void(^closeAlterViewCallBack)(void);
@property (weak, nonatomic) IBOutlet LKIssueStyleTableView *tableView;
+ (instancetype)instanceIssueStyleView;
@end

NS_ASSUME_NONNULL_END

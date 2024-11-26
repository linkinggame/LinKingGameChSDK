
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKIssueStyleTableView : UITableView
- (void)reloadData:(NSArray *)data;
@property (nonatomic, copy)void(^selectItemCallBack)(NSDictionary * _Nullable dict,NSInteger index);
@end

NS_ASSUME_NONNULL_END

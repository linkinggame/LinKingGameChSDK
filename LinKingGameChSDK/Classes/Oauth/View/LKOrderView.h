

#import <UIKit/UIKit.h>

@class LKOrderTableView;
NS_ASSUME_NONNULL_BEGIN

@interface LKOrderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label_month;
@property (weak, nonatomic) IBOutlet UILabel *label_year;
@property (weak, nonatomic) IBOutlet UIButton *button_close;
@property (weak, nonatomic) IBOutlet LKOrderTableView *tableView;
@property (nonatomic, copy) void (^closeAlterViewCallBack)(UIButton *button);
@property (nonatomic, copy) void (^selectDateCallBack)(UIButton *button);
+ (instancetype)instanceOrderView;

@end

NS_ASSUME_NONNULL_END

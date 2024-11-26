

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKWelcomeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label_account;
@property (weak, nonatomic) IBOutlet UILabel *label_tip;
@property (weak, nonatomic) IBOutlet UIView *view_Indicator;
@property (weak, nonatomic) IBOutlet UIButton *button_change_account;
@property(nonatomic, copy)void(^changeAccountAction)(UIButton *sender);
+ (instancetype)instanceWecomeView;
@end

NS_ASSUME_NONNULL_END

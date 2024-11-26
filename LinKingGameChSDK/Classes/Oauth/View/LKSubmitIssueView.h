

#import <UIKit/UIKit.h>

@class LKTextView;
NS_ASSUME_NONNULL_BEGIN

@interface LKSubmitIssueView : UIView
@property (weak, nonatomic) IBOutlet LKTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label_count;
@property (weak, nonatomic) IBOutlet UIView *view_picture;
@property (weak, nonatomic) IBOutlet UITextField *textfield_iphone;
@property (weak, nonatomic) IBOutlet UIButton *button_checkbox;
@property (weak, nonatomic) IBOutlet UIButton *button_commit;
@property (weak, nonatomic) IBOutlet UILabel *label_imageCount;
@property (nonatomic, copy) void(^closeAlterViewCallBack)(void);
@property (nonatomic, copy) void(^checkBoxCallBack)(UIButton *sender);
@property (nonatomic, copy) void(^commitCallBack)(void);
+ (instancetype)instanceSubmitIssueView;
- (void)setLKSuperView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END

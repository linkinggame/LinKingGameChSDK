
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKRealNameView : UIView
@property (weak, nonatomic) IBOutlet UIButton *button_close;
@property (weak, nonatomic) IBOutlet UITextField *textfield_name;
@property (weak, nonatomic) IBOutlet UITextField *textfield_code;
@property (weak, nonatomic) IBOutlet UIButton *button_auth;
@property(nonatomic, copy)void(^closeAlterViewAction)(UIButton *sender);
@property(nonatomic, copy)void(^authAction)(UIButton *sender,NSString *name, NSString *number);
@property (weak, nonatomic) IBOutlet UIImageView *imageView_close;

- (void)setLKSuperView:(UIView *)superView;
+ (instancetype)instanceRealNameView;
@end

NS_ASSUME_NONNULL_END

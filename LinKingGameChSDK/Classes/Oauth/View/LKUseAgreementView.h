

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKUseAgreementView : UIView
@property (weak, nonatomic) IBOutlet UIView *view_content;
@property (weak, nonatomic) IBOutlet UIButton *button_checkBox;
@property (weak, nonatomic) IBOutlet UIButton *button_ok;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_agree;

@property (nonatomic,copy)void(^sureCallBack)(BOOL isSelect);
+ (instancetype)instanceUseAgreementView;


@end

NS_ASSUME_NONNULL_END

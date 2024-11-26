

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKPayResultView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView_picture;
@property (weak, nonatomic) IBOutlet UILabel *label_desc;
@property(nonatomic, copy) void(^closeAlterViewCallBack)(void);
+ (instancetype)instancePayResultView;
@end

NS_ASSUME_NONNULL_END



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKCollectionView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) void(^selectIconCallback)(NSString *icon,NSString *iconId);

@end

NS_ASSUME_NONNULL_END

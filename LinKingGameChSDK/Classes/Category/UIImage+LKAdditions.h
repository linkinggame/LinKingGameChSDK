

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LKAdditions)
+ (UIImage *)lk_ImageNamed:(NSString *)name;
+ (UIImage *)lk_ImageNamed:(NSString *)name withCls:(Class)cls;
@end

NS_ASSUME_NONNULL_END

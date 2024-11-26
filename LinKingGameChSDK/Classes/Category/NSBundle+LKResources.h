

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (LKResources)
+ (NSBundle *)lk_loadBundleClass:(Class)aClass bundleName:(NSString *)bundleName;
@end

NS_ASSUME_NONNULL_END



#import "NSBundle+LKResources.h"

@implementation NSBundle (LKResources)
+ (NSBundle *)lk_loadBundleClass:(Class)aClass bundleName:(NSString *)bundleName{
    NSBundle *bundle = [NSBundle bundleForClass:[aClass class]];
    NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}


@end

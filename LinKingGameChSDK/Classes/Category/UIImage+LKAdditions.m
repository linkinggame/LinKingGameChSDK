

#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKManager.h"
@implementation UIImage (LKAdditions)
+ (UIImage *)lk_ImageNamed:(NSString *)name{
    
    // bundle
   NSBundle *bundle = [NSBundle lk_loadBundleClass:[LKSDKManager class] bundleName:@"LinKingGameChSDKBundle"];
    
    name = [name stringByAppendingFormat:@"@2x"];
    // path
   NSString *imagePath = [bundle pathForResource:name ofType:@"png"];
    
    // image
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        
        // 去除@2x 使用 imagesName 加载
      name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
      image = [UIImage imageNamed:name];
    }
    
    
    return  image;
}
+ (UIImage *)lk_ImageNamed:(NSString *)name withCls:(Class)cls{
    
    // bundle
   NSBundle *bundle = [NSBundle lk_loadBundleClass:cls bundleName:@"LinKingGameChSDKBundle"];
    
    name = [name stringByAppendingFormat:@"@2x"];
    // path
   NSString *imagePath = [bundle pathForResource:name ofType:@"png"];
    
    // image
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        
        // 去除@2x 使用 imagesName 加载
      name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
      image = [UIImage imageNamed:name];
    }
    

    return  image;
}
@end

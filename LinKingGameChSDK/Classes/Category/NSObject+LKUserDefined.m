
#import "NSObject+LKUserDefined.h"

@implementation NSObject (LKUserDefined)
- (id)exceptNull
{
    if (self == [NSNull null]) {
        return nil;
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString*)self isEqualToString:@"<null>"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"null"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@""]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"false"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"(null)"]) {
            return nil;
        }
        if ([(NSString*)self isEqualToString:@"<nil>"]) {
            return nil;
        }
    }

    return self;
}
@end

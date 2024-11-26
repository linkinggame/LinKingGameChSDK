

#import "LKProduct.h"
#import <StoreKit/StoreKit.h>
@implementation LKProduct
- (instancetype)initWithArray:(SKProduct *)product
{
    self = [super init];
    if (self) {
        self.productId = product.productIdentifier;
        self.desc = [product description];
        self.localizedTitle = [product localizedTitle];
        self.localizedDescription = [product localizedDescription];
        self.price = [product price];
    }
    return self;
}
@end

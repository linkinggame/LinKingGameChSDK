
#import "LKGoods.h"

@implementation LKGoods

- (instancetype)initWithDictionary:(NSDictionary *)product{
    self = [super init];
    if (self) {
        self.productId = product[@"id"];
        self.name = product[@"name"];
        self.num = product[@"num"];
        self.amount =  product[@"amount"];
     
    }
    return self;
}

@end

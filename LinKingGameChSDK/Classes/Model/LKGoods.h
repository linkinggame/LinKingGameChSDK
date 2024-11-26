

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKGoods : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)product;
/// 商品ID
@property (nonatomic,copy) NSString *productId;
/// 商品描述
@property (nonatomic,copy) NSString *name;
/// 商品数量
@property (nonatomic,strong) NSNumber *num;
/// 商品价格
@property (nonatomic,strong) NSNumber *amount;


@end

NS_ASSUME_NONNULL_END

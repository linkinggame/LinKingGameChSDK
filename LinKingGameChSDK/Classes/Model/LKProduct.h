

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SKProduct;
@interface LKProduct : NSObject
- (instancetype)initWithArray:(SKProduct *)product;
/// 商品ID
@property (nonatomic,copy) NSString *productId;
/// 商品描述
@property (nonatomic,copy) NSString *desc;
/// 商品标题
@property (nonatomic,copy) NSString *localizedTitle;
/// 本地描述
@property (nonatomic,copy) NSString *localizedDescription;
/// 价格
@property (nonatomic,strong) NSDecimalNumber *price;


@end

NS_ASSUME_NONNULL_END

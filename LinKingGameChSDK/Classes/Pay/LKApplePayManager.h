

#import <UIKit/UIKit.h>
@class LKGoods;
typedef enum {
   PurchSuccess = 0,       // 购买成功
   PurchFailed = 1,        // 购买失败
   PurchCancle = 2,        // 取消购买
   PurchVerFailed = 3,     // 订单校验失败
   PurchVerSuccess = 4,    // 订单校验成功
   PurchNotArrow = 5,      // 不允许内购
   PurchNoGoods = 6,       // 没有商品
   PurchRestoredGoods = 7, // 已经购买过该商品
   PurchServiceFail = 8, // 网络故障
   PurchReceiptInvalid = 9, // 支付票据无效
   PurchOrderNotExist = 10, // 支付订单不存在
   PurchOrderClosed = 11, // 支付订单已结束
   PurchOrderNoComplete = 12, // 订单未完成
   PurchAbnormalOrder = 13, // 异常订单
   PurchOrderFail = 14, // 订单创建失败
    
}PurchType;
NS_ASSUME_NONNULL_BEGIN
typedef void (^CompletionHandle)(PurchType type,NSError * _Nullable error);

@protocol LKApplePayManagerDelegate <NSObject>

@optional
/// 创建订单成功回调
- (void)storePayCreateOrderId:(NSString * _Nullable)orderId withError:(NSError *_Nullable)error;

@end

@interface LKApplePayManager : NSObject

@property (nonatomic, weak) id<LKApplePayManagerDelegate>delegate;

+ (instancetype)shared;
/**
 启动工具
 */
- (void)startManager;
/**
 结束工具
 */
- (void)stopManager;

/// 拉取所有商品信息
- (void)requestProductDatasComplete:(void(^_Nullable)(NSError * _Nullable error, NSArray*_Nullable products))complete;

//开始内购
- (void)statrtProductWithId:(NSString *)productId parames:(NSDictionary *)parames completeHandle:(CompletionHandle)handle;


- (void)setContentView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END

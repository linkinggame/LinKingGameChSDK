

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKSDKConfig : NSObject<NSSecureCoding,NSCoding>
// 实名认证开关
@property (nonatomic, strong) NSNumber     *real_name_switch;
// 实名认证  认证中的状态  true 认定认证成功      false 认定认证失败
@property (nonatomic, copy) NSNumber       *real_name_success;
// 充值开关              true 只有实名认证用户才可以充值   false 所有状态下的玩家都可以充值
@property (nonatomic, copy) NSNumber       *pay_limit;
@property (nonatomic, strong) NSDictionary *mqtt_config;
@property (nonatomic, copy) NSString       *ready_type;
@property (nonatomic, copy) NSString       *pay_type;
@property (nonatomic, strong) NSNumber     *mode_debug;
@property (nonatomic, strong) NSNumber     *wsy;
@property (nonatomic, strong) NSDictionary *sdk_config;
@property (nonatomic, strong) NSDictionary *wx_config;
@property (nonatomic, strong) NSDictionary *auth_config;
@property (nonatomic, strong) NSDictionary *point_config;
@property (nonatomic, strong) NSDictionary *ad_config_ios;
@property (nonatomic, strong) NSDictionary *share_info;
@property (nonatomic, strong) NSDictionary *updateGame;
@property (nonatomic, copy)   NSString *wx_service_num;
/// 是否开启web第三方支付
@property (nonatomic, strong) NSNumber *thirdOpenPay;
/// 累计充值金额
@property (nonatomic, strong) NSNumber *rechargePay;
/// web 支付Url
@property (nonatomic, strong) NSString *webPayBaseUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (LKSDKConfig *)getSDKConfig;
+ (void)setSDKConfig:(LKSDKConfig *)config;
+ (void)removeSDKConfig;
/// 获取MQTT参数
+ (NSDictionary *)getMQttSettingFromConfig;
/// 是否使用MQTT机制
+ (BOOL)isMqttCheck;
@end

NS_ASSUME_NONNULL_END



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKUser : NSObject<NSSecureCoding>

/// 用户唯一id标识
@property (nonatomic, copy) NSString *userId;
/// 真实姓名
@property (nonatomic, copy) NSString *real_name;
/// 手机号码
@property (nonatomic, copy) NSString *phone;
/// 年龄
@property (nonatomic, copy) NSString *age;
/// 系统时间
@property (nonatomic, copy) NSString *timestamp;
/// 校验字符串
@property (nonatomic, copy) NSString *verify;
/// 登录类型，参考枚举类 Guest|Passport|Facebook|Google|Fkxyr|FireBase
@property (nonatomic, copy) NSString *login_type;
/// 账号编号
@property (nonatomic, copy) NSString *ppid;
/// 是否是新用户
@property (nonatomic, copy) NSString *is_new_user;
/// 昵称
@property (nonatomic, copy) NSString *nick_name;
/// 第三方编号
@property (nonatomic, copy) NSString *third_id;

@property (nonatomic, copy) NSString *third_type;
/// 用户头像
@property (nonatomic, copy) NSString *head_icon;
/// token
@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *id_card;
/// 用户创建时间
@property (nonatomic, copy) NSString *create_time;
/// 性别 m-男 f-女
@property (nonatomic, copy) NSString *gender;

/// 认证状态 0 未认证  1 认证中 2 已认证
@property (nonatomic, copy) NSString *real_verify;

/// 用户累计充值金额
@property (nonatomic, copy) NSString *payAmount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)getToekn;
+ (LKUser *)getUser;
+ (void)setUser:(LKUser *)user;
+ (void)removeUserInfo;

@end

NS_ASSUME_NONNULL_END

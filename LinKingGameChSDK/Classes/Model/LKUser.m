

#import "LKUser.h"
#import "LKGlobalConf.h"
#import "LKUserEntity.h"
#import "NSObject+LKUserDefined.h"
#import "LKLog.h"
#import "LKRealNameVerifyFactory.h"
@implementation LKUser
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.userId = [NSString stringWithFormat:@"%@",dictionary[@"id"]];
        self.real_name = [NSString stringWithFormat:@"%@",dictionary[@"real_name"]];
        self.phone = [NSString stringWithFormat:@"%@",dictionary[@"phone"]];
        self.age = [NSString stringWithFormat:@"%@",dictionary[@"age"]];
        self.timestamp = [NSString stringWithFormat:@"%@",dictionary[@"timestamp"]];
        self.verify = [NSString stringWithFormat:@"%@",dictionary[@"verify"]];
        self.login_type = [NSString stringWithFormat:@"%@",dictionary[@"login_type"]];
        self.ppid = [NSString stringWithFormat:@"%@",dictionary[@"ppid"]];
        self.is_new_user = [NSString stringWithFormat:@"%@",dictionary[@"is_new_user"]];
        self.nick_name = [NSString stringWithFormat:@"%@",dictionary[@"nick_name"]];
        self.third_id = [NSString stringWithFormat:@"%@",dictionary[@"third_id"]];
        self.head_icon = [NSString stringWithFormat:@"%@",dictionary[@"head_icon"]];
        self.token = [NSString stringWithFormat:@"%@",dictionary[@"token"]];
        self.id_card = [NSString stringWithFormat:@"%@",dictionary[@"id_card"]];
        self.create_time = [NSString stringWithFormat:@"%@",dictionary[@"create_time"]];
        self.gender = [NSString stringWithFormat:@"%@",dictionary[@"gender"]];
        self.third_type =  [NSString stringWithFormat:@"%@",dictionary[@"third_type"]];
        self.real_verify = [NSString stringWithFormat:@"%@",dictionary[@"real_verify"]];
        self.payAmount = [NSString stringWithFormat:@"%@",dictionary[@"pay_amount"]];
        
    }
    return self;
}
// 解码
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.userId = [coder decodeObjectForKey:@"id"];
        self.real_name = [coder decodeObjectForKey:@"real_name"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.age = [coder decodeObjectForKey:@"age"];
        self.timestamp = [coder decodeObjectForKey:@"timestamp"];
        self.verify = [coder decodeObjectForKey:@"verify"];
        self.login_type = [coder decodeObjectForKey:@"login_type"];
        self.ppid = [coder decodeObjectForKey:@"ppid"];
        self.is_new_user = [coder decodeObjectForKey:@"is_new_user"];
        self.nick_name = [coder decodeObjectForKey:@"nick_name"];
        self.third_id = [coder decodeObjectForKey:@"third_id"];
        self.head_icon = [coder decodeObjectForKey:@"head_icon"];
        self.token = [coder decodeObjectForKey:@"token"];
        self.id_card = [coder decodeObjectForKey:@"id_card"];
        self.create_time = [coder decodeObjectForKey:@"create_time"];
        self.gender = [coder decodeObjectForKey:@"gender"];
        self.third_type = [coder decodeObjectForKey:@"third_type"];
        self.real_verify = [coder decodeObjectForKey:@"real_verify"];
        self.payAmount = [coder decodeObjectForKey:@"pay_amount"];
        
    }
    return self;
}

// 编码
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.userId forKey:@"id"];
    [coder encodeObject:self.real_name forKey:@"real_name"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.age forKey:@"age"];
    [coder encodeObject:self.timestamp forKey:@"timestamp"];
    [coder encodeObject:self.verify forKey:@"verify"];
    [coder encodeObject:self.login_type forKey:@"login_type"];
    [coder encodeObject:self.ppid forKey:@"ppid"];
    [coder encodeObject:self.is_new_user forKey:@"is_new_user"];
    [coder encodeObject:self.nick_name forKey:@"nick_name"];
    [coder encodeObject:self.third_id forKey:@"third_id"];
    [coder encodeObject:self.head_icon forKey:@"head_icon"];
    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.id_card forKey:@"id_card"];
    [coder encodeObject:self.create_time forKey:@"create_time"];
    [coder encodeObject:self.gender forKey:@"gender"];
    [coder encodeObject:self.third_type forKey:@"third_type"];
    [coder encodeObject:self.real_verify forKey:@"real_verify"];
    [coder encodeObject:self.payAmount forKey:@"pay_amount"];
}


+ (NSString *)getToekn{
    
    NSString *token = nil;
    
    NSString *res1 = [LKUserEntity shared].token;
    if (res1.exceptNull != nil) {
        token = res1;
        return token;
    }
    
    NSString *res2 = [LKUserEntity shared].user.token;
    if (res2.exceptNull != nil) {
        token = res2;
        return token;
    }

    NSString *res3 = [self getUserCachePrivate].token;
    if (res3.exceptNull != nil) {
        token = res3;
    }

    return token;
    
}

+ (LKUser *)getUser{
    
    // 先从内存中获取用户对象
    if ([LKUserEntity shared].user != nil) {
        return [LKUserEntity shared].user;
    }
    // 从沙盒中获取
    return [self getUserCachePrivate];
    
   
}



+ (BOOL)supportsSecureCoding {
    return true;
}

+ (void)setUser:(LKUser *)user{
    
   
    LKLogInfo(@"用户real_verify:%@",user.real_verify);
    // 先存入缓存
    [LKUserEntity shared].user = user;
    // 在判断token是否为空
    if (user.token.exceptNull != nil) {
        [LKUserEntity shared].token = user.token;
    }
    // 在存入沙盒
    [self setUserCachePrivate:user];
    
    // 更新实名认证状态
    [[LKRealNameVerifyFactory createRealNameVerify] saveUserRealVerifyState:user.real_verify];
}


+ (LKUser *)getUserCachePrivate{
    
    // 或取本地数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"LKUSER"];
    if(data == nil){
        LKLogInfo(@"No configuration information is available or obtained locally!!!");
       return nil;
    }

    if (@available(iOS 11.0, *)) {
         LKUser *user = (LKUser *)[NSKeyedUnarchiver unarchivedObjectOfClass:LKUser.class fromData:data error:nil];
        if (user != nil) {
            // 存入一份到本地
            [LKUserEntity shared].user = user;
        }else{
            LKLogInfo(@"===user对象为空===");
        }
         return user;
     } else {
         LKUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
         if (user != nil) {
             // 存入一份到本地
             [LKUserEntity shared].user = user;
         }else{
             LKLogInfo(@"===user对象为空===");
         }
          return user;
     }

}

+ (void)setUserCachePrivate:(LKUser *)user{
    
    NSData *userData =nil;
    if (@available(iOS 11.0, *)) {
       userData = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:nil];
    } else {
       userData =[NSKeyedArchiver archivedDataWithRootObject:user];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"LKUSER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserInfo{
    NSString *key = [NSString stringWithFormat:@"REALVERIFYKEY_%@",[LKUserEntity shared].user.userId];
    [LKUserEntity shared].token = nil;
    [LKUserEntity shared].user = nil;
    [LKUserEntity shared].userId = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LKUSER"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"REALNAMESTATUS"];
}
@end

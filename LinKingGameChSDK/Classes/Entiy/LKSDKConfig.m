
#import "LKSDKConfig.h"
#import "LKGlobalConf.h"
#import "LKLog.h"
@implementation LKSDKConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.ready_type = [NSString stringWithFormat:@"%@",dictionary[@"ready_type"]];
        self.pay_type = [NSString stringWithFormat:@"%@",dictionary[@"pay_type"]];
        self.mode_debug = dictionary[@"mode_debug"];
        self.wsy = dictionary[@"wsy"];
        self.sdk_config = dictionary[@"sdk_config"];
        self.wx_config = dictionary[@"wx_config"];
        self.auth_config = dictionary[@"auth_config"];
        self.point_config = dictionary[@"point_config"];
        self.ad_config_ios = dictionary[@"ad_config_ios"];
        self.share_info = dictionary[@"share_info"];
        self.updateGame = dictionary[@"updateGame"];
        self.wx_service_num = [NSString stringWithFormat:@"%@",dictionary[@"wx_service_num"]];
        self.real_name_switch = dictionary[@"real_name_switch"];
        self.real_name_success = dictionary[@"real_name_success"];
        self.pay_limit = dictionary[@"pay_limit"];
        self.mqtt_config = dictionary[@"mqtt"];
        self.thirdOpenPay = dictionary[@"third_open_pay"];
        self.rechargePay = dictionary[@"recharge_pay"];
        self.webPayBaseUrl = dictionary[@"web_pay_base_url"];
    }
    return self;
}
// 解码
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.ready_type =  [coder decodeObjectForKey:@"ready_type"];
        self.pay_type =[coder decodeObjectForKey:@"pay_type"];
        self.mode_debug =[coder decodeObjectForKey:@"mode_debug"];
        self.wsy = [coder decodeObjectForKey:@"wsy"];
        self.sdk_config = [coder decodeObjectForKey:@"sdk_config"];
        self.wx_config =[coder decodeObjectForKey:@"wx_config"];
        self.auth_config =[coder decodeObjectForKey:@"auth_config"];
        self.point_config= [coder decodeObjectForKey:@"point_config"];
        self.ad_config_ios =[coder decodeObjectForKey:@"ad_config_ios"];
        self.share_info = [coder decodeObjectForKey:@"share_info"];
        self.updateGame = [coder decodeObjectForKey:@"updateGame"];
        self.wx_service_num = [coder decodeObjectForKey:@"wx_service_num"];
        self.real_name_switch = [coder decodeObjectForKey:@"real_name_switch"];
        self.real_name_success = [coder decodeObjectForKey:@"real_name_success"];
        self.pay_limit = [coder decodeObjectForKey:@"pay_limit"];
        self.mqtt_config = [coder decodeObjectForKey:@"mqtt"];
        self.thirdOpenPay = [coder decodeObjectForKey:@"third_open_pay"];
        self.rechargePay = [coder decodeObjectForKey:@"recharge_pay"];
        self.webPayBaseUrl = [coder decodeObjectForKey:@"web_pay_base_url"];
    }
    return self;
}

// 编码
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.ready_type forKey:@"ready_type"];
    [coder encodeObject:self.pay_type forKey:@"pay_type"];
    [coder encodeObject:self.mode_debug forKey:@"mode_debug"];
    [coder encodeObject:self.wsy forKey:@"wsy"];
    [coder encodeObject:self.sdk_config forKey:@"sdk_config"];
    [coder encodeObject:self.wx_config forKey:@"wx_config"];
    [coder encodeObject:self.auth_config forKey:@"auth_config"];
    [coder encodeObject:self.point_config forKey:@"point_config"];
    [coder encodeObject:self.ad_config_ios forKey:@"ad_config_ios"];
    [coder encodeObject:self.share_info forKey:@"share_info"];
    [coder encodeObject:self.updateGame forKey:@"updateGame"];
    [coder encodeObject:self.wx_service_num forKey:@"wx_service_num"];
    [coder encodeObject:self.real_name_switch forKey:@"real_name_switch"];
    [coder encodeObject:self.real_name_success forKey:@"real_name_success"];
    [coder encodeObject:self.pay_limit forKey:@"pay_limit"];
    [coder encodeObject:self.mqtt_config forKey:@"mqtt"];
    [coder encodeObject:self.thirdOpenPay forKey:@"third_open_pay"];
    [coder encodeObject:self.rechargePay forKey:@"recharge_pay"];
    [coder encodeObject:self.webPayBaseUrl forKey:@"web_pay_base_url"];
    
}

+ (LKSDKConfig *)getSDKConfig{
    // 或取本地数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SDKCONF"];
    if(data == nil){
        LKLogInfo(@"No configuration information is available or obtained locally!!!");
       return nil;
    }

    if (@available(iOS 11.0, *)) {
        NSError *error = nil;
         LKSDKConfig *sdkConfig = (LKSDKConfig *)[NSKeyedUnarchiver unarchiveTopLevelObjectWithData:data error:&error];
         return sdkConfig;
     } else {
         LKSDKConfig *sdkConfig = [NSKeyedUnarchiver unarchiveObjectWithData:data];
          return sdkConfig;
     }
    
   
}





+ (BOOL)supportsSecureCoding {
    return true;
}

+ (void)setSDKConfig:(LKSDKConfig *)config{
       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SDKCONF"];
    NSData *configData =nil;
    if (@available(iOS 11.0, *)) {
       configData = [NSKeyedArchiver archivedDataWithRootObject:config requiringSecureCoding:YES error:nil];
    } else {
       configData =[NSKeyedArchiver archivedDataWithRootObject:config];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:configData forKey:@"SDKCONF"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

+ (void)removeSDKConfig{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SDKCONF"];
}


/// 获取MQTT参数
+ (NSDictionary *)getMQttSettingFromConfig{
    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
    
    
    NSDictionary *mqtt =  config.mqtt_config;
    NSString *server_uri = mqtt[@"server_uri"];
    
    NSString *host = nil;
    NSString *port = nil;
    if ([server_uri rangeOfString:@":"].location != NSNotFound) {
       NSArray *array = [server_uri componentsSeparatedByString:@":"];
        host = array[0];
        port = array[1];
    }
    
    NSString *instance_id = mqtt[@"instance_id"];
    NSString *accessKey = mqtt[@"accessKey"];
    NSString *topicPush = mqtt[@"topic_push"];
    NSString *topic_subscribe = mqtt[@"topic_subscribe"];
    NSString *group = mqtt[@"group"];
    NSNumber *mqttCheck = mqtt[@"mqtt_check"];
    
    NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
                             instance_id,@"instanceId",
                             topic_subscribe,@"rootTopic",
                             accessKey,@"accessKey",
                             group,@"groupId",
                             host,@"host",
                             port,@"port",
                             @0,@"tls",
                             @0,@"qos",
                             topicPush,@"topicPush",
                             mqttCheck,@"mqtt_check",
                             nil];
    return setting;

}

+ (BOOL)isMqttCheck{
   NSDictionary *mqtt = [self getMQttSettingFromConfig];
    NSNumber *res = mqtt[@"mqtt_check"];
    return [res boolValue];
}
@end

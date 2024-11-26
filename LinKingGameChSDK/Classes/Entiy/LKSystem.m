

#import "LKSystem.h"
#import "LKGlobalConf.h"
#import "LKLog.h"
@implementation LKSystem
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 解码
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.loginStyle = [coder decodeObjectForKey:@"loginStyle"];
        self.token = [coder decodeObjectForKey:@"token"];
        self.userToken = [coder decodeObjectForKey:@"userToken"];
        self.gameId = [coder decodeObjectForKey:@"gameId"];
        self.appID = [coder decodeObjectForKey:@"appID"];
        self.secretkey = [coder decodeObjectForKey:@"secretkey"];
        self.matrixLanguage = [coder decodeObjectForKey:@"matrixLanguage"];
        
    }
    return self;
}

// 编码
- (void)encodeWithCoder:(NSCoder *)coder
{
     [coder encodeObject:self.loginStyle forKey:@"loginStyle"];
     [coder encodeObject:self.token forKey:@"token"];
     [coder encodeObject:self.userToken forKey:@"userToken"];
     [coder encodeObject:self.gameId forKey:@"gameId"];
     [coder encodeObject:self.appID forKey:@"appID"];
     [coder encodeObject:self.secretkey forKey:@"secretkey"];
     [coder encodeObject:self.matrixLanguage forKey:@"matrixLanguage"];
    
}
+ (BOOL)supportsSecureCoding {
    return true;
}

+ (LKSystem *)getSystem{
    //获取本地数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SYSTEMSDK"];
    if(data == nil){
       LKLogInfo(@"No configuration information is available or obtained locally!!!");
       return [[LKSystem alloc] init];
    }
    
   if (@available(iOS 11.0, *)) {
        LKSystem *system = (LKSystem *)[NSKeyedUnarchiver unarchivedObjectOfClass:LKSystem.class fromData:data error:nil];
        return system;
    } else {
        LKSystem *system = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return system;
    }
   
}



+ (void)clearSystemConf{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SYSTEMSDK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)setSystem:(LKSystem *)system{

   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SYSTEMSDK"];
    NSData *sdkConfData =nil;
    if (@available(iOS 11.0, *)) {
       sdkConfData = [NSKeyedArchiver archivedDataWithRootObject:system requiringSecureCoding:YES error:nil];
    } else {
       sdkConfData =[NSKeyedArchiver archivedDataWithRootObject:system];
    }
    [[NSUserDefaults standardUserDefaults] setObject:sdkConfData forKey:@"SYSTEMSDK"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end



#import "LKTaptapUpload.h"
#import "LKSDKConfigApi.h"
#import "LKSDKConfig.h"
#import "LKGlobalConf.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import "LKSystem.h"
#import "LKBundleUtil.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "LKLog.h"
#import "LKUUID.h"

@implementation LKTaptapUpload


+ (void)uploadLoginTaptapType:(NSString *)event_type complete:(void(^_Nullable)(NSError *_Nullable error))complete{
    NSString *userId=@"";
    NSString *login_type=@"";
    NSString *third_id=@"";
    LKUser *user = [LKUser getUser];
    if (user!=nil) {
        userId=user.userId;
        login_type=user.login_type;
        third_id=user.third_id;
        LKLogInfo(@"questTaptapType uploadLoginTaptapType =============== userId = %@, loginType=%@, thirdId=%@", userId, login_type, third_id);
        [self uploadTaptapType:@"2" withAmount:@"0" withPayType:@"" complete:complete];
    }
}

+ (void)uploadTaptapType:(NSString *)event_type withAmount:(NSString *)amount withPayType:(NSString *)pay_type complete:(void(^_Nullable)(NSError *_Nullable error))complete{
    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
    NSDictionary *taptap_config =  config.taptap_config;
    if (taptap_config!=nil) {
        NSDictionary *sdk_config =  config.sdk_config;
        NSString * gameId = @"";
        if (sdk_config!=nil) {
            gameId = sdk_config[@"app_id_ios"];
        }
        NSString *userId=@"";
        NSString *login_type=@"";
        NSString *third_id=@"";
        LKUser *user = [LKUser getUser];
        if (user!=nil) {
            userId=user.userId;
            login_type=user.login_type;
            third_id=user.third_id;
        }
        
        NSString * tapad_dot_flag = taptap_config[@"tapad_dot_flag"];
        NSString * tapad_dot_url = taptap_config[@"tapad_dot_url"];
        NSString * device_id = [LKUUID getUUID];
        NSString * sub_channel = @"AppStore";
        //开始php上报的url拼接
        NSString *uploadUrl = [NSString stringWithFormat:@"%@?gameid=%@&user_id=%@&third_id=%@&login_type=%@&event_type=%@&amount=%@&device_id=%@&sub_channel=%@&pay_type=%@&device_type=ios", tapad_dot_url, gameId, userId, third_id, login_type, event_type, amount, device_id, sub_channel, pay_type];
        LKLogInfo(@"questTaptapType info url = %@", uploadUrl);
        LKLogInfo(@"questTaptapType info tapad_dot_flag = %@", tapad_dot_flag);
        
        if ([@"1" isEqualToString: tapad_dot_flag]) {
            LKLogInfo(@"questTaptapType info begin");
            [LKNetWork getWithURLString:uploadUrl success:^(id  _Nonnull responseObject) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                LKLogInfo(@"questTaptapType info end success josnStr:%@", responseStr);
                if (complete) {
                    complete(nil);
                }
            } failure:^(NSError * _Nonnull error) {
                LKLogInfo(@"questTaptapType info end error");
                if (complete) {
                    complete(error);
                }
            }];
        }
        
    }
    
    
    
}

@end



#import "LKBindingApi.h"
#import "LKGlobalConf.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "LKUserEntity.h"
@implementation LKBindingApi
+ (void)bindAccountWithType:(NSString *)type phone:(NSString *)phone thirdToken:(NSString *)thirdToken complete:(void(^)(NSError *error))complete{
      NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/bind"];
     
      NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
      
     [parameters setObject:type forKey:@"type"];
    if (thirdToken.exceptNull != nil) {
       [parameters setObject:thirdToken forKey:@"token"];
    }
    if (phone.exceptNull != nil) {
        [parameters setObject:phone forKey:@"phone"];
    }
    
//    if (code.exceptNull != nil) {
//        [parameters setObject:code forKey:@"pwd"];
//    }
    
      NSMutableDictionary *headers = [NSMutableDictionary dictionary];
      LKUser *user = [LKUser getUser];
      [headers setObject:user.token forKey:@"LK_TOKEN"];
     [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

         NSNumber *success = responseObject[@"success"];
         NSString *desc = responseObject[@"desc"];
         NSString *code = responseObject[@"code"];
         NSDictionary *data = responseObject[@"data"];
         if ([success boolValue] == YES) {
             LKUser *user = [[LKUser alloc] initWithDictionary:data[@"user"]];
             if (user != nil) {
                 // 将用户信息存储到本地
                 [LKUser setUser:user];
             }
             if (complete) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    complete(nil);
                   });
                 }
         }else{
             dispatch_async(dispatch_get_main_queue(), ^{
                 complete([self responserErrorMsg:desc code:[code intValue]]);
             });
         }
     } failure:^(NSError * _Nonnull error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             complete(error);
         });
     }];
     
     return;
    
    
}
@end

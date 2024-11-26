

#import "LKUserCenterApi.h"
#import "LKNetWork.h"
#import "LKUser.h"
@implementation LKUserCenterApi

+ (void)fetchUserIconcomplete:(void(^)(NSError *error,NSArray *data,NSString *icon))complete{

         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"config/avatar_list"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParames]];
         
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
         LKUser *user = [LKUser getUser];
         
         [headers setObject:user.token forKey:@"LK_TOKEN"];

        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            NSArray *data = responseObject[@"data"];
            if ([success boolValue] == YES) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                   LKUser *user = [LKUser getUser];
                    NSString *icon = nil;
                    for (NSDictionary *dict in data) {
                        NSNumber *idNumber = dict[@"id"];
                        if ([idNumber intValue] == [user.head_icon intValue]) {
                            icon = dict[@"url"];
                            break;
                        }
                    }
                      complete(nil,data,icon);
                  });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete([self responserErrorMsg:desc],nil,nil);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error,nil,nil);
            });
        }];
    
    
}

+ (void)sureFixUserIconWithIconId:(NSString *)iconId Complete:(void(^)(NSError *error))complete{

         NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"user/c/hi"];
        
         NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
         
        [parameters setObject:iconId forKey:@"hi"];
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
         LKUser *user = [LKUser getUser];
         
         [headers setObject:user.token forKey:@"LK_TOKEN"];

        [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

            NSNumber *success = responseObject[@"success"];
            NSString *desc = responseObject[@"desc"];
            if ([success boolValue] == YES) {
                dispatch_async(dispatch_get_main_queue(), ^{
                      complete(nil);
                  });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete([self responserErrorMsg:desc]);
                });
            }
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error);
            });
        }];
    
    
}






@end

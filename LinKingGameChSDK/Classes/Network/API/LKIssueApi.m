

#import "LKIssueApi.h"
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
@implementation LKIssueApi


+ (void)fetchIssueListComplete:(void(^)(NSError *error, NSDictionary*result))complete{
    
            NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"config/question_types"];
            
             NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
    
             NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        
             LKUser *user = [LKUser getUser];
             
             [headers setObject:user.token forKey:@"LK_TOKEN"];

            [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

                NSNumber *success = responseObject[@"success"];
                NSString *desc = responseObject[@"desc"];
                NSDictionary *data = responseObject[@"data"];
                if ([success boolValue] == YES) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           if (complete) {
                               NSDictionary *result = data;
                               complete(nil,result);
                           }
                       });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete([self responserErrorMsg:desc],nil);
                    });
                }
            } failure:^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(error,nil);
                });
            }];
    
}


+ (void)commitIssue:(NSArray <UIImage *>*)images parameters:(NSDictionary *)parameters complete:(void(^)(NSError *error))complete{
        NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"question/upload"];

        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
   
        LKUser *user = [LKUser getUser];
        
        [headers setObject:user.token forKey:@"LK_TOKEN"];
    [LKNetWork uploadWithURLString:url withImages:images parameters:parameters HTTPHeaderField:headers complete:^(NSError * _Nullable error, NSDictionary * _Nullable responseObj) {
        if (complete) {
            complete(error);
        }
    }];
}

+ (void)fetchFeedBookIssueListComplete:(void(^)(NSError *error, NSArray*result))complete{
    
            NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"question/list"];
            
             NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self defaultParamesSimple]];
    
             NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        
             LKUser *user = [LKUser getUser];
             
             [headers setObject:user.token forKey:@"LK_TOKEN"];

            [LKNetWork postWithURLString:url parameters:parameters HTTPHeaderField:headers success:^(id  _Nonnull responseObject) {

                NSNumber *success = responseObject[@"success"];
                NSString *desc = responseObject[@"desc"];
                NSString *code = responseObject[@"code"];
                NSArray *data = responseObject[@"data"];
                if ([success boolValue] == YES) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           if (complete) {
                               NSArray *result = data;
                               complete(nil,result);
                           }
                       });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete([self responserErrorMsg:desc code:[code intValue]],nil);
                    });
                }
            } failure:^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(error,nil);
                });
            }];
    
}


+ (void)readIssueWithId:(NSString *)issueId complete:(void(^)(NSError *error))complete{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[self baseURL],@"question/read"];
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:issueId forKey:@"id"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    LKUser *user = [LKUser getUser];
    [headers setObject:user.token forKey:@"LK_TOKEN"];

    [LKNetWork uploadWithURLString:url withImages:@[] parameters:parameters HTTPHeaderField:headers complete:^(NSError * _Nullable error, NSDictionary * _Nullable responseObj) {
        if (error == nil) {
            
            NSNumber *success = responseObj[@"success"];
            NSString *desc = responseObj[@"desc"];
            NSString *code = responseObj[@"code"];
            if ([success boolValue] == YES){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) {
                        complete(nil);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) {
                        complete([self responserErrorMsg:desc code:[code intValue]]);
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error);
            });
        }
    }];
    
}



@end

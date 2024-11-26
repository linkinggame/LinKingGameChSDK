//
//  LKUUID.m
//  LinKingSDK
//
//  Created by leoan on 2020/7/20.
//  Copyright © 2020 dml1630@163.com. All rights reserved.
//

#import "LKUUID.h"
#import "LKKeyChainStore.h"
#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"
@implementation LKUUID
+ (NSString *)getUUID
{
    
    //  NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *bundleIdentifier = @"com.linking.sdk";
    //[[NSBundle mainBundle] bundleIdentifier];
   
    NSString * strUUID = (NSString *)[LKKeyChainStore load:bundleIdentifier];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        
        //生成一个uuid的方法
        
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        
        [LKKeyChainStore save:bundleIdentifier data:strUUID];
        
    }
    return strUUID;
}
@end

//
//  LKBundleUtil.h
//  LinKingSDK
//
//  Created by leon on 2021/5/25.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKBundleUtil : NSObject
+ (NSDictionary *)getLinKingBundleInfo;
+ (NSString *)getSDKVersion;
+ (NSString *)getReportedLogURL;
@end

NS_ASSUME_NONNULL_END

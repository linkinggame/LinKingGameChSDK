//
//  LKUserEntity.h
//  LinKingSDK
//
//  Created by leon on 2021/5/20.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKUser;
NS_ASSUME_NONNULL_BEGIN

@interface LKUserEntity : NSObject
+ (instancetype)shared;
@property (nonatomic, copy )NSString  * _Nullable token;
@property (nonatomic, strong)LKUser * _Nullable user;
@property (nonatomic, copy )NSString  * _Nullable userId;
@end

NS_ASSUME_NONNULL_END

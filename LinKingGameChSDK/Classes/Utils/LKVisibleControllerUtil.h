//
//  LKVisibleControllerUtil.h
//  LinKingSDK
//
//  Created by leon on 2021/5/27.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKVisibleControllerUtil : NSObject
+ (BOOL)alreadyVisibleWithRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END

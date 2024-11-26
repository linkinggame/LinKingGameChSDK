//
//  LKVisibleControllerUtil.m
//  LinKingSDK
//
//  Created by leon on 2021/5/27.
//  Copyright © 2021 dml1630@163.com. All rights reserved.
//

#import "LKVisibleControllerUtil.h"
#import "LKWecomeViewController.h"
#import "LKLog.h"
@implementation LKVisibleControllerUtil



- (BOOL)alreadyVisible:(Class)clazz{
    
    UIViewController *vc = [self getCurrentVC];
    
    if ([vc isKindOfClass:clazz]) {
        // 已显示
        return YES;
    }
    
    return NO;
}

+ (NSMutableArray *)getAllNeedVisibleViewController{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:50];
    // 遍历所有需要presented的视图
    Class LKWecomeViewController = NSClassFromString(@"LKWecomeViewController");
    Class LKUserCenterViewController = NSClassFromString(@"LKUserCenterViewController");
    Class LKUseAgreementController = NSClassFromString(@"LKUseAgreementController");
    Class LKSubmitIssueController = NSClassFromString(@"LKSubmitIssueController");
    Class LKRestPwdViewController = NSClassFromString(@"LKRestPwdViewController");
    Class LKRegisterController = NSClassFromString(@"LKRegisterController");
    Class LKRealNameController = NSClassFromString(@"LKRealNameController");
    Class LKPayTypeController = NSClassFromString(@"LKPayTypeController");
    Class LKPayResultController = NSClassFromString(@"LKPayResultController");
    Class LKOrderController = NSClassFromString(@"LKOrderController");
    Class LKIssueStyleController = NSClassFromString(@"LKIssueStyleController");
    Class LKIssueServiceController = NSClassFromString(@"LKIssueServiceController");
    Class LKIconCenterViewController = NSClassFromString(@"LKIconCenterViewController");
    Class LKFixPwdViewController = NSClassFromString(@"LKFixPwdViewController");
    Class LKCustomerController = NSClassFromString(@"LKCustomerController");
    Class LKCrazyTipController = NSClassFromString(@"LKCrazyTipController");
    Class LKBindingTipController = NSClassFromString(@"LKBindingTipController");
    Class LKBindingController = NSClassFromString(@"LKBindingController");
    Class LKAlterLoginViewController = NSClassFromString(@"LKAlterLoginViewController");


    [list addObject:LKWecomeViewController];
    [list addObject:LKUserCenterViewController];
    [list addObject:LKUseAgreementController];
    [list addObject:LKSubmitIssueController];
    [list addObject:LKRestPwdViewController];
    [list addObject:LKRegisterController];
    [list addObject:LKRealNameController];
    [list addObject:LKPayTypeController];
    [list addObject:LKPayResultController];
    [list addObject:LKOrderController];
    [list addObject:LKIssueStyleController];
    [list addObject:LKIssueServiceController];
    [list addObject:LKIconCenterViewController];
    [list addObject:LKFixPwdViewController];
    [list addObject:LKCustomerController];
    [list addObject:LKCrazyTipController];
    [list addObject:LKBindingTipController];
    [list addObject:LKBindingController];
    [list addObject:LKAlterLoginViewController];
    
    return list;
}



//+ (BOOL)alreadyVisibleWithRootViewController:(UIViewController *)rootViewController{
//
//    BOOL isVisible = NO;
//    UIViewController *presentedViewController = rootViewController.presentedViewController;
//    if (presentedViewController == nil) {
//        isVisible = NO;
//    }
//    NSMutableArray *list =  [self getAllNeedVisibleViewController];
//    for (Class clazz in list) {
//        if ([presentedViewController isKindOfClass:clazz]) {
//            // 已显示
//            isVisible = YES;
//            break;
//        }
//    }
//
//    return isVisible;
//}

+ (BOOL)alreadyVisibleWithRootViewController:(UIViewController *)rootViewController{

    BOOL isVisible = NO;
    UIViewController *presentedViewController = rootViewController.presentedViewController;
    LKLogVerbose(@"rootViewController--presentedViewController:%@",presentedViewController);
    if (presentedViewController != nil) {
        LKLogVerbose(@"[rootViewController] %@ 已显示",rootViewController);
        isVisible = YES;
    }

    return isVisible;
}


- (UIViewController *)getCurrentVC{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    //其他框架可能会改我们的keywindow，比如支付宝支付，qq登录都是在一个新的window上，这时候的keywindow就不是appdelegate中的window。 当然这里也可以直接用APPdelegate里的window。
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController* currentViewController = window.rootViewController;
    while (YES) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
 
}
@end

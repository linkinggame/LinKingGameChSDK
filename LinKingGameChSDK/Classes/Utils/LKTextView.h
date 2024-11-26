//
//  LKTextView.h
//  LinKingSDK
//
//  Created by leoan on 2020/7/24.
//  Copyright © 2020 dml1630@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKTextView : UITextView
/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  占位文字的颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end

NS_ASSUME_NONNULL_END

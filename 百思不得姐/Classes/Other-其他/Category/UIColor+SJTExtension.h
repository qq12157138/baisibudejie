//
//  UIColor+SJTExtension.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/7.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SJTExtension)

/**
 换肤设计：@"normal"要从沙盒中获取
 */
+ (UIColor *)colorWithKey:(NSString *)key;

@end

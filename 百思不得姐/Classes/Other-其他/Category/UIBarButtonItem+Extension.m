//
//  UIBarButtonItem+Extension.m
//  黑马微博2期
//
//  Created by 史江涛 on 16/2/16.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

/**
 创建一个item
 
 @param target    调用哪个对象的方法
 @param action    点击item调用的方法
 @param image     图片
 @param highImage 高亮图片
 
 @return 创建完的item
 */
+ (instancetype)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage{
    // 创建一个自定义(Custom)按钮
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    // 设置按钮图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:(UIControlStateHighlighted)];
    // 设置按钮尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[self alloc] initWithCustomView:btn];
}

@end

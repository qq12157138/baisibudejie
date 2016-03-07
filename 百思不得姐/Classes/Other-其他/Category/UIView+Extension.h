//
//  UIView+Extension.h
//  黑马微博2期
//
//  Created by 史江涛 on 16/2/16.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
// 分类只能创建方法的声明，并不会生成get／set方法，需自己实现
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

/**
 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

/**
 获取当前正在显示的控制器
 */
- (UIViewController *)getCurrentVC;

+ (instancetype)viewFromXib;

@end

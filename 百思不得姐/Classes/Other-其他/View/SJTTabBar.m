//
//  SJTTabBar.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTabBar.h"

@interface SJTTabBar()
/**
 发布按钮
 */
@property (nonatomic, weak) UIButton *publishButton;

@end

@implementation SJTTabBar

// 自定义控件一定要重写这个方法来设置内容
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置tabBar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabBar-light"]];
        
        // 添加一个发布按钮
        UIButton *publishButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:(UIControlStateNormal)];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:(UIControlStateHighlighted)];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

// 在布局子控件的时候设置尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 设置发布按钮frame
//    self.publishButton.bounds = CGRectMake(0, 0, self.publishButton.currentBackgroundImage.size.width, self.publishButton.currentBackgroundImage.size.height);
    self.publishButton.size = self.publishButton.currentBackgroundImage.size;
    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            continue;
        }
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        index++;
    }
    
}

@end

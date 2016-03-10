//
//  SJTTopWindow.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/2.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTopWindow.h"
#import "SJTTopWindowViewController.h"

@implementation SJTTopWindow

static UIWindow *window_;

+ (void)show {
    window_ = [[UIWindow alloc] init];
    window_.windowLevel = UIWindowLevelAlert;
    window_.frame = [UIApplication sharedApplication].statusBarFrame;
    window_.backgroundColor = [UIColor clearColor];
    window_.rootViewController = [SJTTopWindowViewController showWithStyle:UIStatusBarStyleDefault statusBarHidden:NO];
    window_.hidden = NO;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topWindowClick)]];
}

/**
 监听窗口的点击
 */
+ (void)topWindowClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superView {
    for (UIScrollView *subView in superView.subviews) {
        // 如果是scroll，滚动最顶部
        if ([subView isKindOfClass:[UIScrollView class]] && subView.isShowingOnKeyWindow) {
            CGPoint offset = subView.contentOffset;
            offset.y = -subView.contentInset.top;
            [subView setContentOffset:offset animated:YES];
        }
        // 继续查找子控件
        [self searchScrollViewInView:subView];
    }
}

@end

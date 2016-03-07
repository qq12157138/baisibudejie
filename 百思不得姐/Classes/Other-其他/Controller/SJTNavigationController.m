//
//  SJTNavigationController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTNavigationController.h"
#import "SVProgressHUD.h"

@interface SJTNavigationController ()

@end

@implementation SJTNavigationController

+ (void)initialize
{
    // 可以用appearance设置所有导航栏样式
    // appearanceWhenContainedInInstancesOfClasses指定哪个类触发（这里是指用SJTNavigationController的类）
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:(UIBarMetricsDefault)];
    
    // 设置当前导航栏的背景图片
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:(UIBarMetricsDefault)];
    
    // 设置所有导航栏文字
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
    // 设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    // 自定义返回按钮需要清空代理，才有手势返回
    self.interactivePopGestureRecognizer.delegate = nil;
}


// 拦截所有push进来的控制器，统一设置返回按钮样式
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // backBarButtonItem不允许自定义
//    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:nil action:nil];
    
    if (self.childViewControllers.count > 0) {  // 为了防止第一个控制器就设置左上按钮（因为系统加载VC也是push）
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTitle:@"返回" forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:(UIControlStateHighlighted)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        // 按钮尺寸宽用户好点击
        button.size = CGSizeMake(70, 30);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // [button sizeToFit];
        // 如果你嫌默认的按钮位置边距还是太大，可以用contentEdgeInsets设置内边距
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        [button addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
        // 如果push后自动隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 因为上面设置了所有控制器的左上按钮，所以把super放在后面是为了控制器可以在加载的时候自定义左上按钮，减少依赖性。
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

// 返回用的pop
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [super popViewControllerAnimated:animated];
    
    // 隐藏指示器
    [SVProgressHUD dismiss];
    return nil;
}



@end

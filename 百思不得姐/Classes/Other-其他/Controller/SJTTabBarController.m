//
//  SJTTabBarController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/20.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTabBarController.h"
#import "SJTEssenceViewController.h"
#import "SJTNewViewController.h"
#import "SJTFriendTrendsViewController.h"
#import "SJTMeViewController.h"
#import "SJTTabBar.h"
#import "SJTNavigationController.h"

@interface SJTTabBarController ()

@end

@implementation SJTTabBarController
+ (void)initialize {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    attrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // UI_APPEARANCE_SELECTOR进行统一设置的话最好放在initialize中，只设置一次
    #pragma mark - 统一设置所有item的外观（如果系统方法后面有UI_APPEARANCE_SELECTOR，都可以统一设置）
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:(UIControlStateNormal)];
    [item setTitleTextAttributes:selectedAttrs forState:(UIControlStateSelected)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVc:[[SJTEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self setupChildVc:[[SJTNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    [self setupChildVc:[[SJTFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    [self setupChildVc:[[SJTMeViewController alloc] initWithStyle:(UITableViewStyleGrouped)] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    // 更换tabBar
    [self setValue:[[SJTTabBar alloc] init] forKeyPath:@"tabBar"];
    
}

- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    // 这里访问了view也就说view会被创建并且懒加载属性（不要在这里设置）
//    vc.view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    /**
     // 设置文字样式
     [vc.tabBarItem setTitleTextAttributes:attrs forState:(UIControlStateNormal)];
     [vc.tabBarItem setTitleTextAttributes:selectedAttrs forState:(UIControlStateSelected)];
     // 设置图片不需要渲染（已在Assets中给图片手动设置）
     UIImage *image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
     image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
     vc.tabBarItem.selectedImage = image;
     */
    
    // 包装一个导航控制器，添加导航控制器为tabBarController的子控制器
    SJTNavigationController *nav = [[SJTNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

@end

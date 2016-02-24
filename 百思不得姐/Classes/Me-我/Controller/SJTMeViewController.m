//
//  SJTMeViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTMeViewController.h"

@interface SJTMeViewController ()

@end

@implementation SJTMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    //    self.title = @"我的";
    
    // 设置导航栏左边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithTarget:self action:@selector(settingClick) image:@"mine-setting-icon" highImage:@"mine-setting-icon-click"];
    UIBarButtonItem *nightModeItem = [UIBarButtonItem itemWithTarget:self action:@selector(nightModeClick) image:@"mine-moon-icon" highImage:@"mine-moon-icon-click"];
    self.navigationItem.rightBarButtonItems = @[settingItem, nightModeItem];
    
    // 设置颜色
    self.view.backgroundColor = SJTGlobalBg;
}

- (void)settingClick {
    
}

- (void)nightModeClick {
    SJTLog(@"nightModeClick");
}

@end

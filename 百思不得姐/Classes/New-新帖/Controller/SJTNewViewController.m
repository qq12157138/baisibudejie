//
//  SJTNewViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTNewViewController.h"

@interface SJTNewViewController ()

@end

@implementation SJTNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(tagClick) image:@"MainTagSubIcon" highImage:@"MainTagSubIconClick"];
    
    // 设置背景色
    self.view.backgroundColor = SJTGlobalBg;
}

- (void)tagClick{
    SJTLogFunc;
}


@end

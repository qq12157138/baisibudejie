//
//  SJTEssenceViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTEssenceViewController.h"
#import "SJTRecommendTagsViewController.h"

@interface SJTEssenceViewController ()

@end

@implementation SJTEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(tagClick) image:@"MainTagSubIcon" highImage:@"MainTagSubIconClick"];;
    // 设置颜色
    self.view.backgroundColor = SJTGlobalBg;
    
}

- (void)tagClick {
    
    [self.navigationController pushViewController:[[SJTRecommendTagsViewController alloc] init] animated:YES];
}

@end

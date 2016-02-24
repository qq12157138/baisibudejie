//
//  SJTFriendTrendsViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTFriendTrendsViewController.h"
#import "SJTRecommendViewController.h"
#import "SJTLoginRegisterViewController.h"

@interface SJTFriendTrendsViewController ()

@end

@implementation SJTFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏标题
    self.navigationItem.title = @"我的关注";
//    self.title = @"我的关注";
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendsClick) image:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click"];
    
    // 设置颜色
    self.view.backgroundColor = SJTGlobalBg;
}

- (void)friendsClick {
    SJTRecommendViewController *vc = [[SJTRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 点击登录
- (IBAction)loginRegister:(id)sender {
    SJTLoginRegisterViewController *login = [[SJTLoginRegisterViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

@end

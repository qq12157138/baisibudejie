//
//  SJTMeViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTMeViewController.h"
#import "SJTMeCell.h"
#import "SJTMeFooterView.h"
#import <AFNetworking.h>
#import "SJTSettingViewController.h"

@interface SJTMeViewController ()

@end

static NSString *MeID = @"cell";

@implementation SJTMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 设置scrollView其他属性
    self.tableView.contentSize = CGSizeMake(self.tableView.width, self.tableView.height + 40);
}

- (void)setupNav {
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    //    self.title = @"我的";
    // 设置导航栏左边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithTarget:self action:@selector(settingClick) image:@"mine-setting-icon" highImage:@"mine-setting-icon-click"];
    UIBarButtonItem *nightModeItem = [UIBarButtonItem itemWithTarget:self action:@selector(nightModeClick) image:@"mine-moon-icon" highImage:@"mine-moon-icon-click"];
    self.navigationItem.rightBarButtonItems = @[settingItem, nightModeItem];
    
}

- (void)setupTableView {
    // 设置颜色
    self.tableView.backgroundColor = SJTGlobalBg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册Class
    [self.tableView registerClass:[SJTMeCell class] forCellReuseIdentifier:MeID];
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = SJTTopicCellMargin;
    
    // 调整内边距
    self.tableView.contentInset = UIEdgeInsetsMake(SJTTopicCellMargin - 35, 0, 0, 0);
    
    // 设置footerView
    self.tableView.tableFooterView = [[SJTMeFooterView alloc] init];
    
    [self.tableView setAllowsSelection:NO];
}

- (void)settingClick {
    [self.navigationController pushViewController:[[SJTSettingViewController alloc] initWithStyle:(UITableViewStyleGrouped)] animated:YES];
}

- (void)nightModeClick {
    SJTLog(@"nightModeClick");
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SJTMeCell *cell = [tableView dequeueReusableCellWithIdentifier:MeID];
    if (indexPath.section == 0) {
        cell.imageView.image = [[UIImage imageNamed:@"defaultUserIcon"] sjt_circleImage];
        cell.textLabel.text = @"登录/注册";
    } else if(indexPath.section == 1){
        cell.textLabel.text = @"离线下载";
    }
    
    
    return cell;
}


@end

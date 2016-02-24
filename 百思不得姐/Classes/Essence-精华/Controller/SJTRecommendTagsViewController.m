//
//  SJTRecommendTagsViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/23.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTRecommendTagsViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "SJTRecommendTag.h"
#import "SJTRecommendTagCell.h"

@interface SJTRecommendTagsViewController ()

/** 标签数据 */
@property (nonatomic, strong) NSArray *tags;


@end

@implementation SJTRecommendTagsViewController

static NSString * const SJTTagId = @"tag";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化tableView
    [self setupTableView];
    
    // 加载标签
    [self loadTags];
    
}

- (void)setupTableView {
    // 注册xib
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SJTRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:SJTTagId];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SJTGlobalBg;
}

- (void)loadTags {
    self.title = @"推荐标签";
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tags = [SJTRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"数据请求失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJTRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:SJTTagId];
    
    cell.recommendTag = self.tags[indexPath.row];
    
    cell.x = 10;
    
    return cell;
}

@end

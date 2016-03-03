//
//  SJTTopicViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/25.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTopicViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "SJTTopic.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "SJTTopicCell.h"
#import "SJTShowPictureView.h"
#import "SJTCommentViewController.h"
#import "SJTNewViewController.h"

@interface SJTTopicViewController ()

/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;

/** 当前页码 */
@property (nonatomic, assign) NSInteger page;

/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;

/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

/** 上次选中的索引（或者控制器） */
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation SJTTopicViewController

- (NSMutableArray *)topics {
    if (!_topics) {
        self.topics = [[NSMutableArray alloc] init];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化表格
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefresh];
}

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    // 自动调整透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

static NSString * const SJTTopicCellId = @"topic";
- (void)setupTableView {
    // 设置内边距（规范内容显示的位置）
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = SJTTitleViewY + SJTTitleViewH;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset; // 滚动条内边距
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册nib
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SJTTopicCell class]) bundle:nil] forCellReuseIdentifier:SJTTopicCellId];
    
    // 监听tabBar发出的通知
    [SJTNoteCenter addObserver:self selector:@selector(tabBarSelect) name:SJTTabBarDidSelectNotification object:nil];
}

- (void)tabBarSelect {
    
    // 如果是连续选中2次 并且 如果选中的是当前控制器
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex
//        && self.tabBarController.selectedViewController == self.navigationController
        && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - a参数
- (NSString *)a {
    return [self.parentViewController isKindOfClass:[SJTNewViewController class]] ? @"newlist" : @"list";
}

#pragma mark - 数据处理
/**
 *  加载新的帖子数据
 */
- (void)loadNewTopics {
    // 结束上拉
    [self.tableView.mj_footer endRefreshing];
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) return;
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典转模型
        self.topics = [SJTTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 清空页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
    }];
}

/**
 *  加载更多帖子数据
 */
- (void)loadMoreTopics {
    // 结束下拉
    [self.tableView.mj_header endRefreshing];
    
    self.page++;
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"page"] = @(self.page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典转模型
        NSArray *newTopics = [SJTTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        
        if (self.params != params) return;
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 恢复页码（防止下拉刷新失败，但是页码已经++）
        self.page--;
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = self.topics.count == 0;
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJTTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:SJTTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取出帖子模型
    SJTTopic *topic = self.topics[indexPath.row];
    
    // 返回这个模型对应的cell高度
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SJTCommentViewController *commentVc = [[SJTCommentViewController alloc] init];
    commentVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES];
}
@end

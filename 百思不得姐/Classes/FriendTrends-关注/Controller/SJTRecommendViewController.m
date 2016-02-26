//
//  SJTRecommendViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTRecommendViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "SJTRecommendCategoryCell.h"
#import <MJExtension.h>
#import "SJTRecommendCategory.h"
#import "SJTRecommendUserCell.h"
#import "SJTRecommendUser.h"
#import <MJRefresh.h>

// 左边被选中的类别模型（要现实右边数据你要搞清楚左边显示的是谁）
#define SJTSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface SJTRecommendViewController () <UITableViewDataSource, UITableViewDelegate>

/** 左边类别数据 */
@property (nonatomic, strong) NSArray *categories;

/** 左边类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

/** AFN请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation SJTRecommendViewController

// 这个标识是在SJTRecommendCategoryCell.xib中设置的标识
static NSString * const SJTCategoryID = @"category";
// 这个标识是在SJTRecommendUserCell.xib中设置的标识
static NSString * const SJTUserID = @"user";

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        self.manager = [[AFHTTPSessionManager alloc] init];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控件初始化
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefresh];
    
    // 加载左侧的类别数据
    [self loadCategory];
}

/**
 *  初始化控件
 */
- (void)setupTableView {
    // 注册 SJTRecommendCategoryCell.xib
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SJTRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:SJTCategoryID];
    // 注册 SJTRecommendUserCell.xib
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SJTRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:SJTUserID];
    
    // 设置contentInset（只有一个contentInset可以设置，当你有两个tableView就需要自己搞了）
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    
    // 设置标题
    self.navigationItem.title = @"推荐关注";
    
    // 设置背景色
    self.view.backgroundColor = SJTGlobalBg;
}

/**
 *  添加刷新控件
 */
- (void)setupRefresh {
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}

/**
 *  加载左侧的类别数据
 */
- (void)loadCategory {
    // 显示指示器
    [SVProgressHUD show];
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
        // 服务器返回的JSON数据
        self.categories = [SJTRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.categoryTableView reloadData];
        
        // 默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionTop)];
        
        // 让用户表格进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
    }];
    
    // 去掉分割线
    self.categoryTableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - 加载用户数据
- (void)loadNewUsers {
    SJTRecommendCategory *c = SJTSelectedCategory;
    
    // 设置当前页码为1（可以不写，但写是为了加载更多数据的时候方便）
    c.currentPage = 1;
    
    // 发送请求给服务器，加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(c.id);
    params[@"page"] = @(c.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 字典数组 -> 模型数组
        NSArray *user = [SJTRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 清除以前的所有旧数据（如果不清空，多次下拉刷新会重复添加数据）
        [c.users removeAllObjects];
        
        // 添加到当前类别对应的用户数组中
        [c.users addObjectsFromArray:user];
        
        // 保存总数
        c.total = [responseObject[@"total"] integerValue];
        
        /**
         这里这么判断的意思是，如果有两次请求，
         第一次：
         self.params = 第一次  , params1 = 第一次
         第二次：
         self.params = 第二次  , params1 = 第二次
         如果第一次时间长还没加载完又触发了第二次其他请求，
         也就是说我不想要第一次请求了，请给我第二次请求的数据，那么这样就可以拦截数据加载
         
         写在这里是因为就算你前面几次请求回来了，我可以吧数据存起来，但是我不会刷新表格，因为你不是当前显示的模块的请求
         */
        if (self.params != params) return;
        
        // 刷新表格
        [self.userTableView reloadData];
        
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
        // 如果当前加载的cell数和总数相同，就代表没有下一页了
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreUsers {
    SJTRecommendCategory *category = SJTSelectedCategory;
    
    // 发送请求给服务器，加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @([SJTSelectedCategory id]);
    // 因为加载cell的时候设置了页码，所以这里加载更多数据很方便
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 字典数组 -> 模型数组
        NSArray *user = [SJTRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:user];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新表格
        [self.userTableView reloadData];
        
        // 如果当前加载的cell数和总数相同，就代表没有下一页了
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 结束刷新
        [self.userTableView.mj_footer endRefreshing];
    }];
}

/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState {
    SJTRecommendCategory *c = SJTSelectedCategory;
    NSInteger count = c.users.count;
    // 控制每次刷新右边数据时，都控制footer显示或隐藏
    self.userTableView.mj_footer.hidden = count == 0;
    // 这里再判断是为了每次点击左边栏都判断加载按钮的状态
    if (count == c.total) { // 全部加载完毕
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    } else {    // 还有数据
        // 让底部控件结束刷新（等待下次刷新）
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 左边类别表格
    if (tableView == self.categoryTableView) return self.categories.count;
    
    // 这里再判断是为了每次点击左边栏都判断加载按钮的状态
    [self checkFooterState];
    
    // 右边用户表格
    return [SJTSelectedCategory users].count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) {  // 左边类别表格
        SJTRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:SJTCategoryID];
        
        cell.category = self.categories[indexPath.row];
        
        return cell;
    } else {    // 右边用户表格
        SJTRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:SJTUserID];
        // 左边被选中的类别模型（要现实右边数据你要搞清楚左边显示的是谁）
        cell.user = [SJTSelectedCategory users][indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击新的左边标签后，先结束上次刷新
    [self.userTableView.mj_footer endRefreshing];
    [self.userTableView.mj_header endRefreshing];
    
    SJTRecommendCategory *c = self.categories[indexPath.row];
    
    if (c.users.count) {    // 如果右边曾经有数据就加载曾经的数据
        // 显示曾经的数据
        [self.userTableView reloadData];
    } else {
        // 赶紧刷新表格，马上显示当前category的用户数据，不让用户看见上一个category的残留数据
        [self.userTableView reloadData];
        
        // 进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
    }
    
}

#pragma mark - 控制器销毁
- (void)dealloc {
    // 停止所有的操作（防止请求还没执行完控制器被销毁，请求又完成来使用控制器造成崩溃，因为请求是异步的）
    [self.manager.operationQueue cancelAllOperations];
}

@end

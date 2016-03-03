//
//  SJTCommentViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/1.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTCommentViewController.h"
#import "SJTTopicCell.h"
#import "SJTTopic.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "SJTComment.h"
#import <MJExtension.h>
#import "SJTCommentHeaderView.h"
#import "SJTCommentCell.h"
#import <SVProgressHUD.h>

//static NSInteger const SJTHeaderLabelTag = 99;

static NSString * const SJTCommentId = @"comment";

@interface SJTCommentViewController () <UITableViewDelegate, UITableViewDataSource>
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

/** 保存帖子top_cmt */
@property (nonatomic, strong) SJTComment *saved_top_cmt;

/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;

/** manager */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation SJTCommentViewController

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBasic];
    
    [self setupHeader];
 
    [self setupRefresh];
}

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}

- (void)loadMoreComments {
    // 结束之前所有的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 页码
    NSInteger page = self.page + 1;
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    SJTComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) { // 说没有评论数据
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        // 最新评论
        NSArray *newComments = [SJTComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        // 页码处理
        self.page = page;
        
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
//             [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            // 结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadNewComments {
    // 结束之前所有的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) { // 说没有评论数据
            [self.tableView.mj_header endRefreshing];
            return;
        }
        // 最热评论
        self.hotComments = [SJTComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [SJTComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 页码
        self.page = 1;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
            // [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setupHeader {
    // 设置header
    UIView *header = [[UIView alloc] init];
    
    // 清空top_cmt（为了不现实帖子上的最热评论，切记要最后要还原，因为你用的模型和前面是同一个）
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        // 清零自动重新计算高度
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    // 添加cell
    SJTTopicCell *cell = [SJTTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.size = CGSizeMake(SJTScreenW, self.topic.cellHeight);
    [header addSubview:cell];
    
    // header高度
    header.height = self.topic.cellHeight + SJTTopicCellMargin;
    self.tableView.tableHeaderView = header;
    
}

- (void)setupBasic {
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:nil image:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click"];
    
    // 利用通知监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // cell的高度设置（IOS8）
    self.tableView.estimatedRowHeight = 44; // 估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 自动尺寸
    
    // 背景色
    self.tableView.backgroundColor = SJTGlobalBg;
    
    // 注册xib
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SJTCommentCell class]) bundle:nil] forCellReuseIdentifier:SJTCommentId];
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SJTTopicCellMargin, 0);
}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 键盘显示、隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSapce.constant = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 强制自动布局
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 恢复帖子的top_cmt
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        // 清零自动重新计算高度
        [self.topic setValue:@0 forKeyPath:@"cellHeight"];
    }
    
    // 结束之前所有的请求
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // invalidateSessionCancelingTasks也能结束请求，但是是永久结束，所以上面用makeObjectsPerformSelector让数组中的每个元素都执行cancel方法
    [self.manager invalidateSessionCancelingTasks:YES];
}

/**
 返回第section组的所有评论数据
 */
- (NSArray *)commentsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

- (SJTComment *)commentInIndexPath:(NSIndexPath *)indexPath {
    return [self commentsInSection:indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger hotCount = self.hotComments.count;
    NSInteger latesCount = self.latestComments.count;
    
    if (hotCount) return 2;  // 最热＋最新
    if (latesCount) return 1;   // 最新
    return 0;   // 没有评论
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger hotCount = self.hotComments.count;
    NSInteger latesCount = self.latestComments.count;
    // 隐藏尾部控件
    tableView.mj_footer.hidden = latesCount == 0;
    
    if (section == 0) {
        return hotCount ? hotCount : latesCount;
    }
    return latesCount;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        return hotCount ? @"最热评论" : @"最新评论";
//    }
//    return @"最新评论";
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    static NSString *ID = @"header";
//    UILabel *label = nil;
//    // 先从缓存池里找header
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
//    if (!header) {  // 缓存池中没有，自己创建
//        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
//        header.contentView.backgroundColor = SJTGlobalBg;
//        // 创建label
//        label = [[UILabel alloc] init];
//        label.textColor = SJTColor(67, 67, 67);
//        label.width = 200;
//        label.x = SJTTopicCellMargin;
//        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        label.tag = SJTHeaderLabelTag;
//        [header.contentView addSubview:label];
//    } else {    // 从缓存池中取出来
//        label = [header viewWithTag:SJTHeaderLabelTag];
//    }
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        label.text = hotCount ? @"最热评论" : @"最新评论";
//    } else {
//        label.text = @"最新评论";
//    }
//    return header;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 自定义headerView
    SJTCommentHeaderView *header = [SJTCommentHeaderView headerViewWithTableView:tableView];
    
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    } else {
        header.title = @"最新评论";
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJTCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:SJTCommentId];
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark - MenuController处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 显示MenuController
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    } else {
        // 被点击的cell
        SJTCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // 让cell成为响应者
        [cell becomeFirstResponder];
        
        // 添加MenuItem
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)ding:(UIMenuController *)menu {
    // 拿到选中的行
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [SVProgressHUD showSuccessWithStatus:[self commentInIndexPath:indexPath].content];
}

- (void)replay:(UIMenuController *)menu {
    // 拿到选中的行
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [SVProgressHUD showSuccessWithStatus:[self commentInIndexPath:indexPath].content];
}

- (void)report:(UIMenuController *)menu {
    // 拿到选中的行
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [SVProgressHUD showSuccessWithStatus:[self commentInIndexPath:indexPath].content];
}
@end

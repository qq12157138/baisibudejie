//
//  SJTEssenceViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTEssenceViewController.h"
#import "SJTRecommendTagsViewController.h"
#import "SJTTItleButton.h"
#import "SJTTopicViewController.h"
#import "SJTShowPictureView.h"

@interface SJTEssenceViewController () <UIScrollViewDelegate>

/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) SJTTItleButton *selectedBtn;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIScrollView *titleScrollView;
/** 中间的内容 */
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation SJTEssenceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // IOS7以上设置不要自动调整Insets，否则UIScrollView的y值默认会有64的偏移量（也就是可以透过导航栏）
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.extendedLayoutIncludesOpaqueBars = NO;
    
    // 设置导航栏
    [self setupNav];
    
    // 初始化子控件
    [self setupChildVces];
    
    // 设置标题栏
    [self setupTitleView];
    
    // 设置中间内容的scrollView
    [self setupContentView];
    
}

/**
 *  设置导航栏
 */
- (void)setupNav{
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

/**
 *  设置标题栏
 */
- (void)setupTitleView {
    // 标签栏整体
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.frame = CGRectMake(0, SJTTitleViewY, self.view.width, SJTTitleViewH);
    titleScrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
    
    // 底部红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titleScrollView.height - indicatorView.height;
    //    indicatorView.width = width;
    self.indicatorView = indicatorView;
    
    // 内部子标签
    CGFloat width = titleScrollView.width / 5;
    CGFloat height = titleScrollView.height;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        SJTTItleButton *titleBtn = [SJTTItleButton buttonWithType:UIButtonTypeCustom];
        titleBtn.tag = i;
        titleBtn.width = width;
        titleBtn.height = height;
        titleBtn.y = 0;
        titleBtn.x = i * width;
        // 这里设置完文字要用layoutIfNeeded强制布局（强制更新子控件的frame），否则默认点击第一个按钮时红色标签拿不到宽度
        // [titleBtn layoutIfNeeded];
        UIViewController *vc = self.childViewControllers[i];
        [titleBtn setTitle:vc.title forState:(UIControlStateNormal)];
        [titleBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [titleScrollView addSubview:titleBtn];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            // 设置一开始button的比例为1.0
            titleBtn.scale = 1.0;
            // 调用[self clickTitleBtn:titleBtn];方法会有个动画效果，如果一开始不要动画就要手动设置
            titleBtn.enabled = NO;
            self.selectedBtn = titleBtn;
            
            // 让按钮内部的lable根据文字内容计算尺寸
            [titleBtn.titleLabel sizeToFit];
            self.indicatorView.width = titleBtn.titleLabel.width;
            self.indicatorView.centerX = titleBtn.centerX;
        }
    }
    
    // 设置scrollView其他属性
    titleScrollView.contentSize = CGSizeMake(self.childViewControllers.count * width, 0);
    // 取消弹簧效果
    // titleScrollView.bounces = NO;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.showsVerticalScrollIndicator = NO;
    
    #warning 注意，尽量不要用titleScrollView.count去获取内容子控件数量，因为这里添加了一个不是内容的子控件
    [titleScrollView addSubview:indicatorView];
}

/**
 *  titleScrollView中按钮点击出发的方法
 *
 *  @param sender 要触发方法的对象（按钮）
 */
- (void)clickTitleBtn:(SJTTItleButton *)button {
    // 修改按钮状态
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 *  设置中间内容的scrollView
 */
- (void)setupContentView {
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    // 设置scrollView的内容宽度
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

/**
 *  初始化子控件
 */
- (void)setupChildVces {
    [self setupChildVc:[[SJTTopicViewController alloc] init] type:SJTTopicAll title:@"全部"];
    [self setupChildVc:[[SJTTopicViewController alloc] init] type:SJTTopicVideo title:@"视频"];
    [self setupChildVc:[[SJTTopicViewController alloc] init] type:SJTTopicVoice title:@"声音"];
    [self setupChildVc:[[SJTTopicViewController alloc] init] type:SJTTopicPicture title:@"图片"];
    [self setupChildVc:[[SJTTopicViewController alloc] init] type:SJTTopicWord title:@"段子"];
    
    // 监听cell图片被点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewClick:) name:pictureNotificationName object:nil];
}

- (void)imageViewClick:(NSNotification *)notification{
    SJTShowPictureView *pictureBgView = [SJTShowPictureView showPictureView];
    [pictureBgView image:notification.userInfo[@"clickImageView"] imageSuperView:notification.userInfo[@"view"] topicModel:notification.userInfo[@"topic"]];
}

- (void)setupChildVc:(SJTTopicViewController *)vc type:(SJTTopicType)type title:(NSString *)title {
    // type 是枚举
    vc.type = type;
    vc.title = title;
    [self addChildViewController:vc];
}

#pragma mark - UIScrollViewDelegate
// 当scrollView滚动完成后调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 一些临时变量
    CGFloat width = scrollView.width;
    CGFloat height = scrollView.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    // 让对应的顶部标题居中显示
    SJTTItleButton *button = self.titleScrollView.subviews[index];
    CGPoint titleOffset = self.titleScrollView.contentOffset;
    titleOffset.x = button.center.x - width * 0.5;
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.titleScrollView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    
    [self.titleScrollView setContentOffset:titleOffset animated:YES];
    
    // 让其他label回到最初的状态
    for (SJTTItleButton *otherButton in self.titleScrollView.subviews) {
        // 因为titleScrollView里边还有一个红色标签view所以要判断类型
        if ([otherButton isKindOfClass:[SJTTItleButton class]]) {
            if (otherButton != button) otherButton.scale = 0.0;
        }
    }
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    // 如果当前位置的位置已经显示过了，就直接返回
    if ([vc isViewLoaded]) return;
    vc.view.frame = CGRectMake(offsetX, 0, width, height);
    
    [scrollView addSubview:vc.view];
}

// 减速完毕调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self clickTitleBtn:self.titleScrollView.subviews[index]];
}

// 在滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.contentOffset.x / scrollView.width;
    if (scale < 0 || scale > self.childViewControllers.count - 1) return;
    // 获得需要操作的左边按钮
    NSInteger leftIndex = scale;
    SJTTItleButton *leftBtn = self.titleScrollView.subviews[leftIndex];
    
    // 获得需要操作的右边按钮
    NSInteger rightIndex = leftIndex + 1;
    SJTTItleButton *rightBtn = (rightIndex == self.childViewControllers.count)? nil : self.titleScrollView.subviews[rightIndex];
    
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    
    // 设置button的比例
    leftBtn.scale = leftScale;
    rightBtn.scale = rightScale;
    
    // 设置红色标签的位置
    self.indicatorView.centerX = leftBtn.centerX + rightScale * (rightBtn.centerX - leftBtn.centerX);
}

@end

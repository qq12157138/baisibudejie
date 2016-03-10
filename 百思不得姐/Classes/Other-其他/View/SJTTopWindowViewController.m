//
//  SJTTopWindowViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/9.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTopWindowViewController.h"

@interface SJTTopWindowViewController ()

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;

@end

@implementation SJTTopWindowViewController

#pragma mark - 单例
static id instance_;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [super allocWithZone:zone];
    });
    return instance_;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

+ (instancetype)showWithStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden {
    SJTTopWindowViewController *vc = [SJTTopWindowViewController sharedInstance];
    vc.statusBarHidden = statusBarHidden;
    vc.statusBarStyle = statusBarStyle;
    return vc;
}

#pragma mark - 状态栏控制
- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

#pragma mark - setter
- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

@end

//
//  SJTMeFooterView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTMeFooterView.h"
#import <AFNetworking.h>
#import "SJTSquare.h"
#import <MJExtension.h>
#import <UIButton+WebCache.h>
#import "SJTSquareButton.h"
#include "SJTWebViewController.h"

@implementation SJTMeFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *squares = [SJTSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            // 创建方块
            [self createSquares:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

/**
 创建方块
 */
- (void)createSquares:(NSArray *)squares {
    // 一行最多4列
    int maxCols = 4;
    // 宽度／高度
    CGFloat buttonW = self.width / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < squares.count; i++) {
        SJTSquareButton *button = [SJTSquareButton buttonWithType:(UIButtonTypeCustom)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:(UIControlStateNormal)];
        button.square = squares[i];
        [self addSubview:button];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
        
    }
    
    // 计算footer的高度
    // 总行数
//    NSUInteger rows = squares.count / maxCols;
//    if (squares.count % maxCols != 0) { // 不能整除
//        rows++;
//    }
    // 总页数＝（总个数 ＋ 每页的最大条数－1）／每页最大数
    NSInteger rows = (squares.count + maxCols - 1) / maxCols;
    self.height = rows * buttonH;
    // 重绘
    [self setNeedsDisplay];
}

- (void)buttonClick:(SJTSquareButton *)button {
    if ([button.square.url hasPrefix:@"http"]) {
        SJTWebViewController *web = [[SJTWebViewController alloc] init];
        web.url = button.square.url;
        web.title = button.square.name;
        UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nav = tabBarVc.selectedViewController;
        [nav pushViewController:web animated:YES];
        
    }
}

// 画背景图片
- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
}

@end

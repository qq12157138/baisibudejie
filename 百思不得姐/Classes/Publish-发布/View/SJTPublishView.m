//
//  SJTPublishView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/29.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTPublishView.h"
#import "SJTVerticalButton.h"
#import <POP.h>
#import <SVProgressHUD.h>
#import "SJTPostWordViewController.h"
#import "SJTNavigationController.h"

// 动画时间的系数
static CGFloat const SJTAnimationDelay = 0.05;
// 弹簧弹力和时间的系数
static CGFloat const SJTSpringFactor = 6;


@interface SJTPublishView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SJTPublishView

// _在前面是成员变量，在后面是全局变量
static UIWindow *window_;
+ (void)show {
    /**
     窗口优先级
     window.windowLevel = UIWindowLevelStatusBar;
     UIWindowLevelNormal(不可盖住状态栏) < UIWindowLevelStatusBar(可盖住状态栏) < UIWindowLevelAlert(可盖住状态栏)
     */
//    window = [[UIWindow alloc] init];
//    window.frame = [UIScreen mainScreen].bounds;
//    window.backgroundColor = [UIColor clearColor];
//    window.hidden = NO; // 显示窗口
//    SJTPublishView *publish = [SJTPublishView publishView];
//    publish.frame = SJTWindow.bounds;
//    [window addSubview:publish];

    // 自定义窗口的好处是，事件不会传递，和其他窗口独立出来。
    window_.hidden = YES;
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [UIColor clearColor];
    window_.hidden = NO;
    
    // 添加发布界面
    SJTPublishView *publishView = [SJTPublishView viewFromXib];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
}

- (void)awakeFromNib {
    // 控制在动画执行过程中不能点后面背景
    self.userInteractionEnabled = NO;
    
    if (iOS8) {
        [self.bgView addSubview:[SJTTool sjt_bgBluEffectWithFrame:CGRectMake(0, 0, SJTScreenW, SJTScreenH)]];
    } else {
        self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 中间按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (SJTScreenH - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 15;
    CGFloat xMargin = (SJTScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i < images.count; i++) {
        SJTVerticalButton *button = [[SJTVerticalButton alloc] init];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bgView addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:images[i]] forState:(UIControlStateNormal)];
        
        int row = i / maxCols;
        int col = i % maxCols;
//        button.x = buttonStartX + col * (xMargin + buttonW);
//        button.y = buttonStartY + row * buttonH;
//        button.width = buttonW;
//        button.height = buttonH;
        
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        //        CGFloat buttonBeginY = buttonEndY - SJTScreenH;
        
        // 添加按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(SJTScreenW * 0.5 - buttonW * 0.5, SJTScreenH, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = SJTSpringFactor;
        anim.springSpeed = SJTSpringFactor;
        anim.beginTime = CACurrentMediaTime() + SJTAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    CGFloat centerX = SJTScreenW * 0.5;
    CGFloat centerEndY = SJTScreenH * 0.15;
    CGFloat centerBeginY = -sloganView.height;
    sloganView.y = centerBeginY;
    [self.bgView addSubview:sloganView];
    // 标语动画
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    // kCAMediaTimingFunctionEaseOut 开始快后面慢
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * SJTAnimationDelay;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finis) {
        self.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
}

- (IBAction)close{
    [self closeWithCompletionBlock:nil];
}

- (void)buttonClick:(UIButton *)button {
    [self closeWithCompletionBlock:^{
        if ([button.titleLabel.text isEqualToString:@"发段子"]) {
            // 弹出发段子控制器
            SJTPostWordViewController *postWord = [[SJTPostWordViewController alloc] init];
            SJTNavigationController *nav = [[SJTNavigationController alloc] initWithRootViewController:postWord];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        } else {
            [SVProgressHUD showSuccessWithStatus:button.titleLabel.text];
        }
    }];
}

/**
 先执行退出动画，然后动画完毕后执行completionBLock这个block
 */
// void (^)()：block没有返回值void ，block标识(^)，没有参数()
- (void)closeWithCompletionBlock:(void (^)())completionBLock {
    // 防止连点多次按钮（执行多次动画）
    self.userInteractionEnabled = NO;
    
    int beginIndex = 0;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    for (int i = beginIndex; i < self.bgView.subviews.count; i++) {
        UIView *subview = self.bgView.subviews[i];
        if ([subview isKindOfClass:[SJTVerticalButton class]]) {
            if (beginIndex == 0) {
                beginIndex = i;
            }
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            anim.toValue = [NSValue valueWithCGRect:CGRectMake(SJTScreenW * 0.5 - buttonW * 0.5, SJTScreenH, buttonW, buttonH)];
            anim.beginTime = CACurrentMediaTime() + SJTAnimationDelay * (i - beginIndex);
            [subview pop_addAnimation:anim forKey:nil];
        }
        if ([subview isKindOfClass:[UIImageView class]]) {
            // 标语动画
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            CGFloat centerX = SJTScreenW * 0.5;
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, -subview.height)];
            anim.beginTime = CACurrentMediaTime() + SJTAnimationDelay * (i - beginIndex);
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finis) {
                [self removeFromSuperview];
                // 销毁窗口
                window_ = nil;
                
                // 执行传进来的completionBlock参数
//                if (completionBLock) {
//                    completionBLock();
//                }
                !completionBLock ? : completionBLock();
            }];
            [subview pop_addAnimation:anim forKey:nil];
        }
    }
}


/**
 pop和Core Animation的区别
 1.Core Animation的动画只能添加到layer上
 2.pop可以添加到任何对象上
 3.pop底层并非基于Core Animation，是基于CADisplayLink
 4.Core Animation的动画仅仅是表像，并不会真正修改对象的frame、size等
 5.pop会时时修改对象的属性
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self close];
    
    
    //    POPSpringAnimation; 弹簧
    //    POPBasicAnimation;  平缓动画（基本动画）
    //    POPDecayAnimation;  衰减
    //    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    //
    //    anim.springBounciness = 20;   // 弹簧的弹力（0-20）
    //    anim.springSpeed = 20;        // 弹簧的持续时间（0-20）
    //    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.sloganView.y, 100)];
    //    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.sloganView.y, 200)];
    //
    //    [self.sloganView pop_addAnimation:anim forKey:nil];
    
    //    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    //    // anim.beginTime = CACurrentMediaTime() + 2.0;    // 当前时间的2秒后执行
    //    anim.springBounciness = 20;
    //    anim.springSpeed = 20;
    //    anim.fromValue = @(self.sloganView.layer.position.y);
    //    anim.toValue = @(300);
    //    anim.completionBlock = ^(POPAnimation *anim, BOOL finished){
    //        SJTLog(@"动画结束");
    //    };
    //
    //    [self.sloganView pop_addAnimation:anim forKey:nil];
}

@end

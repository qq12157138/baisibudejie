//
//  SJTPushGuideView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/24.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTPushGuideView.h"

@implementation SJTPushGuideView

+ (instancetype)guideView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (IBAction)close:(id)sender {
    // 从窗口删除
    [self removeFromSuperview];
}

@end

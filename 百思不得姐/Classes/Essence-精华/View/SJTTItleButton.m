//
//  SJTTItleButton.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/25.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTItleButton.h"

// 灰色
#define SJTRed 0.5
#define SJTGreen 0.5
#define SJTBlue 0.5

@implementation SJTTItleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor colorWithRed:SJTRed green:SJTGreen blue:SJTBlue alpha:1.0] forState:(UIControlStateNormal)];
//        [self setTitleColor:[UIColor redColor] forState:(UIControlStateDisabled)];
    }
    return self;
}


- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    // 红色
    CGFloat red = SJTRed + (1 - SJTRed) * scale;
    CGFloat green = SJTGreen + (0 - SJTGreen) * scale;
    CGFloat blue = SJTBlue + (0 - SJTBlue) * scale;
    [self setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0] forState:(UIControlStateDisabled)];
    [self setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0] forState:(UIControlStateNormal)];
    
    // 大小缩放比例值（1 -> 1.25）
    CGFloat transformScale = 1 + scale * 0.25;
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}


@end

//
//  SJTSqureButton.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTSquareButton.h"
#import "SJTSquare.h"
#import <UIButton+WebCache.h>

@implementation SJTSquareButton

- (void)setup {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

// 在initWithFrame里写是为了通过代码创建也可以有一样的功能
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.y = self.height * 0.15;
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width * 0.5;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
}

- (void)setSquare:(SJTSquare *)square {
    _square = square;
    
    [self setTitle:square.name forState:(UIControlStateNormal)];
    // 利用SDWebImage给按钮设置image
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:(UIControlStateNormal)];
}

@end

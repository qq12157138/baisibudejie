//
//  SJTVerticalButton.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/24.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTVerticalButton.h"

@implementation SJTVerticalButton

- (void)setup {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
    
}

@end

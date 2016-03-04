//
//  SJTTagButton.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/4.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTagButton.h"

@implementation SJTTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:(UIControlStateNormal)];
        self.titleLabel.font = SJTTagFont;
        self.backgroundColor = SJTTagBg;
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:10.0];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3 * SJTTagMargin;
    self.height = SJTTagH;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.x = SJTTagMargin;
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + SJTTagMargin;
}

@end

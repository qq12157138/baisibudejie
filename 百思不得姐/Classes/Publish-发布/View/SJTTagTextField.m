//
//  SJTTagTextField.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/4.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTagTextField.h"

@implementation SJTTagTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"多个标签用逗号或换行隔开";
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.height = SJTTagH;
    }
    return self;
}

- (void)deleteBackward {
    // block有值就帮我调一下
    !self.deleteBlock ? : self.deleteBlock();
    
    [super deleteBackward];
}

@end

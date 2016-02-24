//
//  SJTTextField.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/24.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTextField.h"
#import <objc/runtime.h>

static NSString * const SJTPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation SJTTextField

// 重画TextField内部的文字、占位文字、光标等
//- (void)drawPlaceholderInRect:(CGRect)rect {
//    [self.placeholder drawInRect:CGRectMake(0, 15, rect.size.width, rect.size.height) withAttributes:@{
//                                                       NSForegroundColorAttributeName : [UIColor grayColor],
//                                                       NSFontAttributeName : self.font
//                                                       }];
//}


- (void)awakeFromNib {
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    // 不成为第一响应者（就为了设置颜色省代码）
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    // 设置占位字颜色
    //    UILabel *placeholderLabel = [self valueForKey:@"_placeholderLabel.textColor"];
    //    placeholderLabel.textColor = [UIColor whiteColor];
    [self setValue:self.textColor forKeyPath:SJTPlacerholderColorKeyPath];
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    // 设置占位字颜色
    [self setValue:[UIColor grayColor] forKeyPath:SJTPlacerholderColorKeyPath];
    
    return [super resignFirstResponder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    // 设置占位字颜色
    [self setValue:placeholderColor forKeyPath:SJTPlacerholderColorKeyPath];
}

@end

//
//  SJTPlaceholderTextView.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//  拥有占位文字功能的TextView控件

#import <UIKit/UIKit.h>

@interface SJTPlaceholderTextView : UITextView

/** 占位文字 */
@property (nonatomic, strong) NSString *placeholder;

/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end

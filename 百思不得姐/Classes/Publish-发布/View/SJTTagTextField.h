//
//  SJTTagTextField.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/4.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJTTagTextField : UITextField

/** 按了删除键后的回调 */
@property (nonatomic, copy) void (^deleteBlock)();

@end

//
//  SJTAddTagViewController.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/4.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJTAddTagViewController : UIViewController

/** 获取tags的block */
@property (nonatomic, copy) void (^tagsBlock)(NSArray *tags);

/** 所有的标签 */
@property (nonatomic, strong) NSArray *tags;

@end

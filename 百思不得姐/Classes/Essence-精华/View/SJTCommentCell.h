//
//  SJTCommentCell.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/1.
//  Copyright © 2016年 史江涛. All rights reserved.
//  
//  IOS8 cell auto-sizing 可以不算高度


#import <UIKit/UIKit.h>

@class SJTComment;
@interface SJTCommentCell : UITableViewCell
/** 评论模型 */
@property (nonatomic, strong) SJTComment *comment;
@end

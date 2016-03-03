//
//  SJTCommentViewController.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/1.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJTTopic;
@interface SJTCommentViewController : UIViewController

/** 帖子模型 */
@property (nonatomic, strong) SJTTopic *topic;

@end

//
//  SJTTopicCell.h
//  百思不得姐
//
//  Created by 史江涛 on 16/2/26.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJTTopic;
@interface SJTTopicCell : UITableViewCell
/** 帖子数据 */
@property (nonatomic, strong) SJTTopic *topic;

@end

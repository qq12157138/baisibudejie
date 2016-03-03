//
//  SJTComment.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/1.
//  Copyright © 2016年 史江涛. All rights reserved.
//  评论模型

#import <Foundation/Foundation.h>

@class SJTUser;
@interface SJTComment : NSObject

/** id */
@property (nonatomic, copy) NSString *ID;

/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;

/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceurl;

/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;

/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;

/** 用户模型 */
@property (nonatomic, strong) SJTUser *user;

@end

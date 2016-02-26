//
//  SJTTopic.h
//  百思不得姐
//
//  Created by 史江涛 on 16/2/25.
//  Copyright © 2016年 史江涛. All rights reserved.
//  帖子

#import <Foundation/Foundation.h>

@interface SJTTopic : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 头像 */
@property (nonatomic, copy) NSString *profile_image;

/** 发帖时间 */
@property (nonatomic, copy) NSString *created_at;

/** 文字内容 */
@property (nonatomic, copy) NSString *text;

/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;

/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;

/** 转发数 */
@property (nonatomic, assign) NSInteger repost;

/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;

/** 是否为新浪的加V用户 */
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;

@end

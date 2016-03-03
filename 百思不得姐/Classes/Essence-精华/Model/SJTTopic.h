//
//  SJTTopic.h
//  百思不得姐
//
//  Created by 史江涛 on 16/2/25.
//  Copyright © 2016年 史江涛. All rights reserved.
//  帖子模型

#import <UIKit/UIKit.h>

@class SJTComment;
@interface SJTTopic : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
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
/** 小图片的路径 */
@property (nonatomic, copy) NSString *samll_image;
/** 大图片的路径 */
@property (nonatomic, copy) NSString *large_image;
/** 中图片的路径 */
@property (nonatomic, copy) NSString *middle_image;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 帖子的类型 */
@property (nonatomic, assign) SJTTopicType type;
/** 音频的时长(秒) */
@property (nonatomic, assign) NSInteger voicetime;
/** 播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/** 视频的时长(秒) */
@property (nonatomic, assign) NSInteger videotime;

/** 最热评论 */
//@property (nonatomic, strong) NSArray *top_cmt;
// 虽然返回是数组，但是我只需要数组中的第一个就行了
@property (nonatomic, strong) SJTComment *top_cmt;

/** qzone_uid */
@property (nonatomic, copy) NSString *qzone_uid;

#pragma mark - 自己的额外辅助属性
/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/** 图片控件的frame */
@property (nonatomic, assign, readonly) CGRect pictureViewFrame;
/** 图片是否太大 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;
/** 图片下载进度 */
@property (nonatomic, assign) CGFloat pictureProgress;

/** 声音控件的frame */
@property (nonatomic, assign, readonly) CGRect voiceFrame;
/** 视频控件的frame */
@property (nonatomic, assign, readonly) CGRect videoFrame;

@end

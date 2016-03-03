//
//  SJTTopicCell.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/26.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTopicCell.h"
#import <UIImageView+WebCache.h>
#import "SJTTopic.h"
#import "SJTTopicPictureView.h"
#import "SJTTopicVoiceView.h"
#import "SJTTopicVideoView.h"
#import "SJTComment.h"
#import "SJTUser.h"

@interface SJTTopicCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
/** 帖子文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;

/** 图片帖子中间的内容 */
@property (nonatomic, weak) SJTTopicPictureView *pictureView;
/** 声音帖子中间的内容 */
@property (nonatomic, weak) SJTTopicVoiceView *voiceView;
/** 视频帖子中间的内容 */
@property (nonatomic, weak) SJTTopicVideoView *videoView;

/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;

@end

@implementation SJTTopicCell
// 懒加载
- (SJTTopicPictureView *)pictureView {
    if (!_pictureView) {
        // 因为是weak弱指针，所以不能直接赋值，所以一开始就加进去就行
//        self.pictureView = [SJTTopicPictureView pictureView];
        SJTTopicPictureView *pictureView = [SJTTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
// 懒加载
- (SJTTopicVoiceView *)voiceView {
    if (!_voiceView) {
        SJTTopicVoiceView *voiceView = [SJTTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
// 懒加载
- (SJTTopicVideoView *)videoView {
    if (!_videoView) {
        SJTTopicVideoView *videoView = [SJTTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    
}


- (void)setTopic:(SJTTopic *)topic {
    _topic = topic;
    
    // 新浪加v
    self.sinaVView.hidden = !topic.isSina_v;
    
    // 设置头像
    [self.profileImageView setHeader:topic.profile_image];
    
    self.nameLabel.text = topic.name;
    
    // 设置帖子的创建时间
    self.createTimeLabel.text = topic.created_at;
    
    // 设置按钮文字
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    // 设置帖子文字内容
    self.text_label.text = topic.text;
    
    // 根据模型类型（帖子类型）添加对应的内容到cell中间
    if (topic.type == SJTTopicPicture) {    // 图片帖子
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureViewFrame;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == SJTTopicVoice) {   // 声音帖子
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceFrame;
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == SJTTopicVideo) {   // 视频帖子
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoFrame;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
    } else {    // 段子帖子
        // 隐藏，防止循环利用
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
//    SJTComment *cmt = [topic.top_cmt firstObject];
//    if (cmt) {
    if (topic.top_cmt) {
        self.topCmtView.hidden = NO;
//        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", cmt.user.username, cmt.content];
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", topic.top_cmt.user.username, topic.top_cmt.content];
    } else {
        self.topCmtView.hidden = YES;
    }
}

//- (void)testDate:(NSString *)create_time {
//    // 格式化时间
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    
//    // 当前时间
//    NSDate *now = [NSDate date];
//    // 发帖时间
//    NSDate *create = [fmt dateFromString:create_time];
//    // 时间之间的差值
//    NSDateComponents *cmps = [now deltaFrom:create];
//    cmps.year;
//}

//- (void)testDate:(NSString *)create_time {
//    // 当前时间
//    NSDate *now = [NSDate date];
//    // 发帖时间
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *create = [fmt dateFromString:create_time];
//    // 两个时间相差的秒数
//    NSTimeInterval delta = [now timeIntervalSinceDate:create];
//}

- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder {
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:(UIControlStateNormal)];
}

/**
 *  重写frame给cell添加边距（也就是为了不让cell粘在一起）
 */
- (void)setFrame:(CGRect)frame {
    frame.origin.x = SJTTopicCellMargin;
    frame.size.width -= SJTTopicCellMargin * 2;
//    frame.size.height -= SJTTopicCellMargin;
    frame.size.height = self.topic.cellHeight - SJTTopicCellMargin;
    frame.origin.y += SJTTopicCellMargin;
    
    [super setFrame:frame];
}

- (IBAction)more {
//    if (iOS8) {
//        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            
//        }]];
//        
//        //    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        //
//        //    }]];
//        
//        [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            
//        }]];
//        
//        [window.rootViewController presentViewController:alert animated:YES completion:nil];
//    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
        [sheet showInView:self.window];
//    }
    
}

@end

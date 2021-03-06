//
//  SJTTopicVideoView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/29.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTopicVideoView.h"
#import <UIImageView+WebCache.h>
#import "SJTTopic.h"
#import "SJTShowPictureView.h"

@interface SJTTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;

@end

@implementation SJTTopicVideoView

- (void)awakeFromNib {
#warning 如果发现你设置的尺寸正确，但是显示的不正确，一般是autoresizing属性影响它了
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    // 给图片添加点击事件
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture {
    SJTShowPictureView *pictureBgView = [SJTShowPictureView viewFromXib];
    [pictureBgView imageView:self.imageView imageUrl:self.topic.large_image imageSize:CGSizeMake(self.topic.width, self.topic.height) nowPictureProgress:self.topic.pictureProgress];
}

- (void)setTopic:(SJTTopic *)topic {
    _topic = topic;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil];
    
    // 播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    // 时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end

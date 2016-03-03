//
//  SJTTopicPictureView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/26.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTopicPictureView.h"
#import "SJTTopic.h"
#import <UIImageView+WebCache.h>
#import "SJTPregressView.h"
#import "SJTShowPictureView.h"

@interface SJTTopicPictureView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** git标志 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;

/** 进度条控件 */
@property (weak, nonatomic) IBOutlet SJTPregressView *progressView;

@end

@implementation SJTTopicPictureView

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
    
    // 立马显示最新的进度值（防止因为网速慢导致显示其他cell的其他图片的下载进度）
    [self.progressView setProgress:topic.pictureProgress animated:YES];
    
    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:progress animated:YES];
        
        topic.pictureProgress = progress;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        if (!topic.isBigPicture) return;
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureViewFrame.size, YES, 0.0);
        
        // 将下载完的image对象绘制到图形上下文中
        CGFloat width = topic.pictureViewFrame.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        // 获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束图形上下文
        UIGraphicsEndImageContext();
    }];
    
    /**
     *  在不知道图片扩展名的情况下，取出图片的第一个字节，就可以判断出图片的真实类型（用扩展名不太靠谱）
     */
    // 判断是否为gif
    NSString *extension = topic.large_image.pathExtension;  // 获取扩展名
    // 不管扩展名是大写还是小写，都转换为小写判断
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    // 是否显示点击查看全图按钮
    if (topic.isBigPicture) {   // 大图
        self.seeBigButton.hidden = NO;
        /**
         *  UIViewContentModeScaleAspectFit     把图片按宽高等比缩放到规定的尺寸内
         *  UIViewContentModeScaleAspectFill    把图片的宽或者高压缩到规定的尺寸有一个相同时
         */
        // self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {    // 非大图
        self.seeBigButton.hidden = YES;
        // 带Scale都是拉伸, 不带Scale的就不拉伸图片
        // self.imageView.contentMode = UIViewContentModeScaleToFill;
        
    }
}

@end

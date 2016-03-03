//
//  SJTShowPictureView.h
//  百思不得姐
//
//  Created by 史江涛 on 16/2/27.
//  Copyright © 2016年 史江涛. All rights reserved.
//  点击查看大图处理

#import <UIKit/UIKit.h>

@class SJTTopic;
@interface SJTShowPictureView : UIView

- (void)imageView:(UIImageView *)clickImageView imageUrl:(NSString *)imageUrl imageSize:(CGSize)imageSize nowPictureProgress:(CGFloat)progress;

@end

//
//  UIImageView+SJTExtension.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "UIImageView+SJTExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (SJTExtension)

- (void)setHeader:(NSString *)url {
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] sjt_circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // completed监听下载完成事件，拿到下载好的图片
        self.image = image ? [image sjt_circleImage] : placeholder;
    }];
}

@end

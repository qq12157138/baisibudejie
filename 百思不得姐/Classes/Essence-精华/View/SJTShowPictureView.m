//
//  SJTShowPictureView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/27.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTShowPictureView.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "SJTPregressView.h"

@interface SJTShowPictureView ()

/** 点击后的图片 */
@property (nonatomic, weak) UIImageView *imageView;
/** 点击前的图片frame */
@property (nonatomic, assign) CGRect imageViewFrame;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet SJTPregressView *progressView;

@end

@implementation SJTShowPictureView

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

static UIWindow *window_;

/**
 查看大图控件函数
 
 @param clickImageView 点击的imageView
 @param imageUrl       原始图路径
 @param imageSize      原始图的正确大小
 @param progress       如果还没加载完就点击imageView，可以穿入进度值继续加载
 */
- (void)imageView:(UIImageView *)clickImageView imageUrl:(NSString *)imageUrl imageSize:(CGSize)imageSize nowPictureProgress:(CGFloat)progress {
    window_.hidden = YES;
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [UIColor clearColor];
    window_.windowLevel = UIWindowLevelAlert;
    window_.hidden = NO;
    [window_ addSubview:self];
    self.frame = window_.bounds;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView.image = imageView.image;
    self.imageView.userInteractionEnabled = YES;
    // 给图片添加点击事件
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    // 给图片添加长按事件
    [self.imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(save)]];
    
    // 转换坐标系，从左边的坐标系转换到右边的坐标系
    CGRect newFrame = [clickImageView.superview convertRect:clickImageView.frame toView:nil];
    self.imageView.frame = newFrame;
    self.imageViewFrame = newFrame;
    self.imageView = self.imageView;
    
    CGFloat pictureW = window_.width;
    CGFloat pictureH = pictureW * imageSize.height / imageSize.width; // 按照宽度等比缩放高度
    CGFloat pictureX = 0;
    CGFloat pictureY = window_.height * 0.5 - pictureH * 0.5;
    self.scrollView.contentSize = CGSizeMake(0, pictureH);
    [UIView animateWithDuration:0.25 animations:^{
        if (pictureH > window_.height) {    // 显示图片超过屏幕高度，需要滚动查看
            self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        } else {    //居中显示
            self.imageView.frame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
        }
    }];
    // 马上显示当前图片的下载进度
    [self.progressView setProgress:progress animated:YES];
    
    // 下载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:progress animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}

- (void)back {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.frame = self.imageViewFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        window_ = nil;
    }];
}

- (IBAction)save {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak SJTShowPictureView *selfWeak = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (selfWeak.imageView.image == nil) {
            [SVProgressHUD showErrorWithStatus:@"图片并未下载完毕"];
            return;
        }
        // 将图片写入相册
        UIImageWriteToSavedPhotosAlbum(selfWeak.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }]];
    
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }]];
    
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

@end

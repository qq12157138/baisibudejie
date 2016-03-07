//
//  UIImage+SJTExtension.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/7.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SJTExtension)
/**
 *  加模糊效果函数，传入参数：image是图片，blur是模糊度（0~2.0之间）
 */
- (UIImage *)sjt_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/**
 圆形头像
 */
+ (UIImage *)sjt_imageWithRoundImage:(UIImage *)image border:(CGFloat)border borderColor:(UIColor *)borderColor;
/**
 圆形头像
 */
- (UIImage *)sjt_circleImage;

/**
 截屏
 */
+ (UIImage *)sjt_imageWithCaptureView:(UIView *)view;

/**
 拉伸图片
 */
+ (UIImage *)sjt_imageWithResizable:(UIImage *)image;

/**
 按比例缩放图片
 */
- (UIImage *)sjt_imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 指定宽度按比例缩放图片
 */
- (UIImage *)sjt_imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**
 换肤设计：@"SkinDirName"要从沙盒中获取
 */
+ (UIImage *)imageWithName:(NSString *)name;

@end

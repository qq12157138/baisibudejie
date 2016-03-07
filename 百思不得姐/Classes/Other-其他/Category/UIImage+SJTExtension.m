//
//  UIImage+SJTExtension.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/7.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "UIImage+SJTExtension.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (SJTExtension)


/**
 圆形头像
 
 - parameter image:       图片
 - parameter border:      图片边框宽度
 - parameter borderColor: 图片边框颜色
 */
- (UIImage *)sjt_circleImage {
    //    self.imageView.layer.cornerRadius = self.imageView.width * 0.5;
    //    self.imageView.layer.masksToBounds = YES;
    return [UIImage sjt_imageWithRoundImage:self border:0 borderColor:nil];
}

/**
 圆形头像
 
 - parameter image:       图片
 - parameter border:      图片边框宽度
 - parameter borderColor: 图片边框颜色
 */
+ (UIImage *)sjt_imageWithRoundImage:(UIImage *)image border:(CGFloat)border borderColor:(UIColor *)borderColor {
    if (border) {
        border = 0;
    }
    // 圆环的宽度
    CGFloat borderW = border;
    
    // 加载旧的图片
    UIImage *oldImage = image;
    // 新的图片尺寸
    CGFloat imageW = oldImage.size.width + 2 * borderW;
    CGFloat imageH = oldImage.size.width + 2 * borderW;
    
    // 设置新的图片尺寸（防止图片是长方形）
    CGFloat circirW = imageW > imageH ? imageH : imageW;
    
    // 开启（NO代表透明）上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circirW, circirW), NO, 0.0);
    
    // 画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circirW, circirW)];
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, path.CGPath);
    
    if (borderColor) {
        // 设置颜色
        [borderColor set];
    }
    
    // 渲染
    CGContextFillPath(ctx);
    
    CGRect clipR = CGRectMake(borderW, borderW, oldImage.size.width, oldImage.size.height);
    // 画圆：正切于旧图片的圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipR];
    // 设置裁剪区域
    [clipPath addClip];
    // 画图片
    [oldImage drawAtPoint:CGPointMake(borderW, borderW)];
    
    // 获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 截屏
 
 - parameter view: 需要截屏的视图
 - returns: 截取屏幕生成的图片
 */
+ (UIImage *)sjt_imageWithCaptureView:(UIView *)view {
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染控制器View的图层到上下文
    // 图层只能用渲染不能用draw
    [view.layer renderInContext:ctx];
    
    // 获取截屏图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 拉伸图片
 
 - parameter image: 要拉伸的图片
 - returns: 拉伸完成的图片
 */
+ (UIImage *)sjt_imageWithResizable:(UIImage *)image {
    image = [image stretchableImageWithLeftCapWidth:(image.size.width * 0.5) topCapHeight:(image.size.height * 0.5)];
    return image;
}

/**
 按比例缩放图片
 
 - parameter size: 要把图显示到多大区域，如：CGSizeMake(300, 140)
 - returns: 缩放好的图片
 */
- (UIImage *)sjt_imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

/**
 指定宽度按比例缩放图片
 
 - parameter defineWidth: 要显示的宽度
 - returns: 缩放好的图片
 */
- (UIImage *)sjt_imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  加模糊效果函数，传入参数：image是图片，blur是模糊度（0~2.0之间）
 */
- (UIImage *)sjt_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur{
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)){
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    NSLog(@"boxSize:%i",boxSize);
    
    //图像处理
    CGImageRef img = image.CGImage;
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    
    inBuffer.height = CGImageGetHeight(img);
    
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    
    outBuffer.width = CGImageGetWidth(img);
    
    outBuffer.height = CGImageGetHeight(img);
    
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    vImage_Buffer outBuffer2;
    
    outBuffer2.data = pixelBuffer2;
    
    outBuffer2.width = CGImageGetWidth(img);
    
    outBuffer2.height = CGImageGetHeight(img);
    
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //将一个隐式的M×N区域颗粒和具有箱式滤波器的效果的ARGB8888源图像进行卷积运算得到作用区域。
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error){
        NSLog(@"error from convolution %ld", error);
    }
    
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    
    free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

/**
 @"SkinDirName"要从沙盒中获取
 */
+ (UIImage *)imageWithName:(NSString *)name {
    NSString *dir = [[NSUserDefaults standardUserDefaults] stringForKey:@"SkinDirName"];
    NSString *path = [NSString stringWithFormat:@"Skins/%@/%@", dir, name];
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:nil]];
}

@end

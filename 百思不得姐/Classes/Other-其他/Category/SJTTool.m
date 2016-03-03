//
//  SJTTool.m
//  黑马微博2期
//
//  Created by 史江涛 on 16/2/18.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTool.h"
#import <Accelerate/Accelerate.h>

#define HMFileBoundary @"heima"
#define HMNewLien @"\r\n"
#define HMEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation SJTTool

// 系统版本号
- (void)setCurrentVersion:(NSString *)currentVersion {
//    [UIDevice currentDevice].systemVersion;
    _sjt_currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
}

/**
 获取沙盒的Caches的文件夹路径
 
 @param directory 哪个目录
 @param fileName  文件名称
 */
+ (NSString *)sjt_path:(NSSearchPathDirectory)directory fileName:(NSString *)fileName {
    if (fileName) {
        return [[NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    } else {
        return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) lastObject];
    }
}

/**
 是否是新版本（第一次加载）
 
 @param new 是新版本
 @param old 旧版本
 */
+ (void)sjt_isNewVsersion:(void (^)(void))new oldVersion:(void (^)(void))old {
//    NSString *key = @"CFBundleVersion"; // 大版本
    NSString *key = @"CFBundleShortVersionString";  // 小版本
    // 存储在沙盒中的版本号（上一次使用版本）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从info.plish中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同（已经加载过）
        if (old) old();
    } else {    // （第一次加载）
        if (new) new();
        // 将当前版本号存入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 错误抖动
 
 - parameter view: 只要父类是UIView都行
 */
+ (void)sjt_shakeForErro:(UIView *)view {
    CAKeyframeAnimation *anim = [[CAKeyframeAnimation alloc] init];
    anim.keyPath = @"position";
    
    CGFloat x = view.frame.origin.x + view.frame.size.width/2;
    CGFloat y = view.frame.origin.y + view.frame.size.height/2;
    // 同时在多个值之间传值
    NSValue *v1 = [NSValue valueWithCGPoint:CGPointMake(x+3, y)];
    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(x+3, y)];
    
    anim.values = @[v1, v2, v3];
    anim.repeatCount = 5;
    anim.duration = 0.1;
    
    [view.layer addAnimation:anim forKey:nil];
}

/**
 颤抖（类似IOS图标抖动）
 
 - parameter view: 只要父类是UIView都行
 */
+ (void)sjt_tremble:(UIView *)view {
    CAKeyframeAnimation *anim = [[CAKeyframeAnimation alloc] init];
    anim.keyPath = @"transform.rotation";
    // 角度转弧度： -5 / 180 * M_PI
    anim.values = @[@(-5 / 180.0 * M_PI), @(5 / 180.0 * M_PI), @(-5 / 180.0 * M_PI)];
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.25;
    [view.layer addAnimation:anim forKey:nil];
}

/**
 解析JSON数据（父节点是[]）
 
 - parameter data: 服务器json数据
 - returns: 解析出来的集合群
 */
+ (NSArray *)sjt_JSONWithNSArray:(NSData *)data {
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    return jsonArr;
}
/**
 解析JSON数据（父节点是{}）
 
 - parameter data: 服务器json数据
 - returns: 解析出来的集合群
 */
+ (NSDictionary *)sjt_JSONWithNSDictionary:(NSData *)data {
    NSDictionary *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    return jsonArr;
}

/**
 获取MIMEType值
 
 - parameter patch: 要上传的文件路径
 - returns: 要上传的文件MIMEType值
 */
- (NSString *)sjt_MIMEType:(NSURL *)url
{
    // 1.创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 2.发送请求（返回响应）
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    // 3.获得MIMEType
    return response.MIMEType;
}

/**
 单上传文件
 
 - parameter url:                   服务器http上传文件的路径
 - parameter fileName:              要生成的文件名称.格式
 - parameter mimeType:              上传文件的mimeType（自行百度）
 - parameter fileData:              文件二进制数据（自行转换成NSData）
 - parameter params:                服务器接受的参数（如："username" : "李四"）
 - parameter NSURLConnectionBlock:  NSURLConnection异步请求的block
 
 - returns: 返回的是request对象
 */
- (void)sjt_uploadWithFilename:(NSString *)filename mimeType:(NSString *)mimeType fileData:(NSData *)fileData params:(NSDictionary *)params NSURLConnectionBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))block
{
    // 1.请求路径
    NSURL *url = [NSURL URLWithString:@"http://192.168.15.172:8080/MJServer/upload"];
    
    // 2.创建一个POST请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 3.设置请求体
    NSMutableData *body = [NSMutableData data];
    
    // 3.1.文件参数
    [body appendData:HMEncode(@"--")];
    [body appendData:HMEncode(HMFileBoundary)];
    [body appendData:HMEncode(HMNewLien)];
    
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"", filename];
    [body appendData:HMEncode(disposition)];
    [body appendData:HMEncode(HMNewLien)];
    
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@", mimeType];
    [body appendData:HMEncode(type)];
    [body appendData:HMEncode(HMNewLien)];
    
    [body appendData:HMEncode(HMNewLien)];
    [body appendData:fileData];
    [body appendData:HMEncode(HMNewLien)];
    
    // 3.2.非文件参数
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [body appendData:HMEncode(@"--")];
        [body appendData:HMEncode(HMFileBoundary)];
        [body appendData:HMEncode(HMNewLien)];
        
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", key];
        [body appendData:HMEncode(disposition)];
        [body appendData:HMEncode(HMNewLien)];
        
        [body appendData:HMEncode(HMNewLien)];
        [body appendData:HMEncode([obj description])];
        [body appendData:HMEncode(HMNewLien)];
    }];
    
    // 3.3.结束标记
    [body appendData:HMEncode(@"--")];
    [body appendData:HMEncode(HMFileBoundary)];
    [body appendData:HMEncode(@"--")];
    [body appendData:HMEncode(HMNewLien)];
    
    request.HTTPBody = body;
    
    // 4.设置请求头(告诉服务器这次传给你的是文件数据，告诉服务器现在发送的是一个文件上传请求)
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", HMFileBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // 5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:block];
}

/**
 对HTTP请求的url进行截取、拆分处理（主要用于JS调IOS代码）
 
 - parameter httpHead: 指定请求头（为了对自定义协议进行拦截）
 - parameter url:      包含请求头的url
 - parameter block:    返回客户端请求的主机地址 和 拆分好的参数
 */
+ (void)sjt_getUrlValueWithHttpHead:(NSString *)httpHead url:(NSString *)url block:(void (^)(NSString *selector, NSDictionary *dict))block {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *split = [url componentsSeparatedByString:@"?"];
    if (split.count > 1){
        NSArray *splitJoin = [split[1] componentsSeparatedByString:@"&"];
        for (int splitNum = 0; splitNum < splitJoin.count; splitNum++) {
            NSArray *keyValue = [splitJoin[splitNum] componentsSeparatedByString:@"="];
            [dict setValue:keyValue[1] forKey:keyValue[0]];
        }
    }
    if (httpHead) {
        NSArray *httpStr = [split[0] componentsSeparatedByString:httpHead];
        if (httpStr.count > 1){
            if (dict.count > 0) {
                block([NSString stringWithFormat:@"%@:", httpStr[1]], dict);
            }else{
                block(httpStr[1], dict);
            }
        }
    } else {
        block(nil, dict);
    }
}

/**
 模糊效果
 
 @param frame 多大
 @param alpha 模糊度
 
 @return 返回UIVisualEffectView可以添加到控制器中
 */
+ (UIVisualEffectView *)sjt_bgBluEffectWithFrame:(CGRect)frame alpha:(CGFloat)alpha{
    // 1、创建模糊效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
    // 2、把模糊效果添加到容器里
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = frame;
    if (alpha) {
        blurView.alpha = alpha;
    }
    return blurView;
}

/**
 模糊效果
 
 @param frame 多大
 
 @return 返回UIVisualEffectView可以添加到控制器中
 */
+ (UIVisualEffectView *)sjt_bgBluEffectWithFrame:(CGRect)frame{
    // 1、创建模糊效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
    // 2、把模糊效果添加到容器里
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = frame;
    return blurView;
}

@end

@implementation UIImage (SJT)

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
@end


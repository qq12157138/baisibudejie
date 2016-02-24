//
//  SJTTool.h
//  黑马微博2期
//
//  Created by 史江涛 on 16/2/18.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SJTTool : NSObject

/**
 系统版本号
 */
@property (nonatomic, copy) NSString *currentVersion;

/**
 获取沙盒的Caches的文件夹路径
 */
+ (NSString *)path:(NSSearchPathDirectory)directory fileName:(NSString *)fileName;

/**
 是否是新版本（第一次加载）
 */
+ (void)isNewVsersion:(void (^)(void))new oldVersion:(void (^)(void))old;

/**
 错误抖动
 */
+ (void)shakeForErro:(UIView *)view;

/**
 颤抖（类似IOS图标抖动）
 */
+ (void)tremble:(UIView *)view;

/**
 解析JSON数据（父节点是[]）
 */
+ (NSArray *)JSONWithNSArray:(NSData *)data;

/**
 解析JSON数据（父节点是{}）
 */
+ (NSDictionary *)JSONWithNSDictionary:(NSData *)data;

/**
 获取MIMEType值
 */
- (NSString *)MIMEType:(NSURL *)url;

/**
 单上传文件
 */
- (void)uploadWithFilename:(NSString *)filename mimeType:(NSString *)mimeType fileData:(NSData *)fileData params:(NSDictionary *)params NSURLConnectionBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))block;

/**
 对HTTP请求的url进行截取、拆分处理（主要用于JS调IOS代码）
 */
+ (void)getUrlValueWithHttpHead:(NSString *)httpHead url:(NSString *)url block:(void (^)(NSString *selector, NSDictionary *dict))block;

@end

@interface UIImage (SJT)
/**
 圆形头像
 */
+ (UIImage *)imageWithRoundImage:(UIImage *)image border:(CGFloat)border borderColor:(UIColor *)borderColor ;

/**
 截屏
 */
+ (UIImage *)imageWithCaptureView:(UIView *)view;

/**
 拉伸图片
 */
+ (UIImage *)imageWithResizable:(UIImage *)image;

/**
 按比例缩放图片
 */
- (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 指定宽度按比例缩放图片
 */
- (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

@end

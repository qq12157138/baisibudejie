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
@property (nonatomic, copy) NSString *sjt_currentVersion;

/**
 获取沙盒的Caches的文件夹路径
 */
+ (NSString *)sjt_path:(NSSearchPathDirectory)directory fileName:(NSString *)fileName;

/**
 是否是新版本（第一次加载）
 */
+ (void)sjt_isNewVsersion:(void (^)(void))new oldVersion:(void (^)(void))old;

/**
 错误抖动
 */
+ (void)sjt_shakeForErro:(UIView *)view;

/**
 颤抖（类似IOS图标抖动）
 */
+ (void)sjt_tremble:(UIView *)view;

/**
 解析JSON数据（父节点是[]）
 */
+ (NSArray *)sjt_JSONWithNSArray:(NSData *)data;

/**
 解析JSON数据（父节点是{}）
 */
+ (NSDictionary *)sjt_JSONWithNSDictionary:(NSData *)data;

/**
 获取MIMEType值
 */
- (NSString *)sjt_MIMEType:(NSURL *)url;

/**
 单上传文件
 */
- (void)sjt_uploadWithFilename:(NSString *)filename mimeType:(NSString *)mimeType fileData:(NSData *)fileData params:(NSDictionary *)params NSURLConnectionBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))block;

/**
 对HTTP请求的url进行截取、拆分处理（主要用于JS调IOS代码）
 */
+ (void)sjt_getUrlValueWithHttpHead:(NSString *)httpHead url:(NSString *)url block:(void (^)(NSString *selector, NSDictionary *dict))block;

/**
 模糊效果
 */
+ (UIVisualEffectView *)sjt_bgBluEffectWithFrame:(CGRect)frame alpha:(CGFloat)alpha;
/**
 模糊效果
 */
+ (UIVisualEffectView *)sjt_bgBluEffectWithFrame:(CGRect)frame;

/**
 设置本地通知
 */
+ (void)sjt_registerLocalNotification:(NSInteger)alertTime title:(NSString *)title userInfo:(NSDictionary *)userDict;
/**
 通知数减1
 */
+ (void)sjt_updateLocationNotification;
/**
 通知数改为几？
 */
+ (void)sjt_updateLocationNotification:(NSInteger)num;
/**
 取消某个本地推送通知
 */
+ (void)sjt_cancelLocalNotificationWithKey:(NSString *)key;

@end

@interface UIImage (SJT)

@end

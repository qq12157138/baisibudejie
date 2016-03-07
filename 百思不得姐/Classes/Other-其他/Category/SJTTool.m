//
//  SJTTool.m
//  黑马微博2期
//
//  Created by 史江涛 on 16/2/18.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTTool.h"

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

/**
 设置本地通知
 
 @param alertTime 几秒后提示
 @param title     app在后台要提示的文字
 @param userDict  点击提示或app在前台的提示
 
 在App被显示到前台可以在applicationDidBecomeActive中写清空标识
 //取消徽章
 [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
 
 在AppDelegate中的通知回调函数didReceiveLocalNotification
 NSString *notMess = [notification.userInfo objectForKey:@"key"];
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本地通知(前台)" message:notMess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
 [alert show];
 // 更新显示的徽章个数
 [SJTTool sjt_updateLocationNotification];
 // 在不需要再推送时，可以取消推送
 [SJTTool sjt_cancelLocalNotificationWithKey:@"key"];
 */
+ (void)sjt_registerLocalNotification:(NSInteger)alertTime title:(NSString *)title userInfo:(NSDictionary *)userDict {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody = title;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSDayCalendarUnit;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

/**
 通知数减1
 */
+ (void)sjt_updateLocationNotification {
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

/**
 通知数改为几？
 */
+ (void)sjt_updateLocationNotification:(NSInteger)num {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:num];
}

/**
 取消某个本地推送通知
 
 @param key 这个key对应你设置通知时传入的字典对应的key
 */
+ (void)sjt_cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

@end


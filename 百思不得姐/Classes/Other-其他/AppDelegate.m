//
//  AppDelegate.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/20.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "AppDelegate.h"
#import "SJTTabBarController.h"
#import "SJTPushGuideView.h"
#import <SDWebImageManager.h>
#import "SJTTopWindow.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
//    SJTTabBarController *tabBarController = [[SJTTabBarController alloc] init];
//    tabBarController.delegate = self;
    
    // 设置窗口的根控制器
    self.window.rootViewController = [[SJTTabBarController alloc] init];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    [SJTTopWindow show];
    
    // 显示推送指南
    [SJTTool sjt_isNewVsersion:^{
        SJTPushGuideView *guideView = [SJTPushGuideView viewFromXib];
        guideView.frame = self.window.bounds;
        [self.window addSubview:guideView];
    } oldVersion:nil];
    
    
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
////    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
////    userInfo[SJTSelectedControllerKey] = viewController;
////    userInfo[SJTSelectedControllerIndexKey] = @(tabBarController.selectedIndex);
//    
//    // 既然tabBarController.selectedIndex能拿到选中的索引，那么参数就没必要传了，在控制器中可以拿到自己的tabBarController
//    // 发通知
//    [SJTNoteCenter postNotificationName:SJTTabBarDidSelectNotification object:nil userInfo:nil];
//}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    #warning 用了SDWebImage框架需要处理内存
    // 1.取消下载
    SDWebImageManager *manager =[SDWebImageManager sharedManager];
    [manager cancelAll];
    // 2.清除内存中所有图片
    [manager.imageCache clearMemory];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [SJTTool sjt_updateLocationNotification:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:notMess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    // 更新显示的徽章个数
    [SJTTool sjt_updateLocationNotification];
    
    // 在不需要再推送时，可以取消推送
    [SJTTool sjt_cancelLocalNotificationWithKey:@"key"];
}

@end

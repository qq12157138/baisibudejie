//
//  SJTLoginTool.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/7.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTLoginTool.h"
#import "SJTLoginRegisterViewController.h"

@implementation SJTLoginTool

+ (void)setUid:(NSString *)uid {
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUid {
    return [self getUid:NO];
}

+ (NSString *)getUid:(BOOL)showLoginController {
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    if (showLoginController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SJTLoginRegisterViewController *login = [[SJTLoginRegisterViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:login animated:YES completion:nil];
        });
    }
    return uid;
}

@end

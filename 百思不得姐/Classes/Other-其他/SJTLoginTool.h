//
//  SJTLoginTool.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/7.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJTLoginTool : NSObject

+ (void)setUid:(NSString *)uid;

/**
 获得当前登录用户的uid
 
 @return nil为没有登录
 */
+ (NSString *)getUid;


+ (NSString *)getUid:(BOOL)showLoginController;

@end

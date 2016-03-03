//
//  SJTUser.h
//  百思不得姐
//
//  Created by 史江涛 on 16/3/1.
//  Copyright © 2016年 史江涛. All rights reserved.
//  用户模型

#import <Foundation/Foundation.h>

@interface SJTUser : NSObject

/** 用户名 */
@property (nonatomic, copy) NSString *username;

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 头像 */
@property (nonatomic, copy) NSString *profile_image;

@end

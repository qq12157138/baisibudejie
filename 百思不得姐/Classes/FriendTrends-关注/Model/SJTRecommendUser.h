//
//  SJTRecommendUser.h
//  百思不得姐
//
//  Created by 史江涛 on 16/2/23.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJTRecommendUser : NSObject

/** 头像 */
@property (nonatomic, copy) NSString *header;

/** 粉丝数 */
@property (nonatomic, assign) NSInteger fans_count;

/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;

@end

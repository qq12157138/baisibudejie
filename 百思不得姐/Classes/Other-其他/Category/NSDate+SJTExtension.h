//
//  NSDate+SJTExtension.h
//  百思不得姐
//
//  Created by 史江涛 on 16/2/26.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SJTExtension)

/**
 *  比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)form;

/**
 *  是否是今年
 */
- (BOOL)isThisYear;

/**
 *  是否是今天
 */
- (BOOL)isToday;

/**
 *  是否是昨天
 */
- (BOOL)isYesterday;

@end

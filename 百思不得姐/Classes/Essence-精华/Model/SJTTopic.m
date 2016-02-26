//
//  SJTTopic.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/25.
//  Copyright © 2016年 史江涛. All rights reserved.
//  帖子

#import "SJTTopic.h"

@implementation SJTTopic

/*
 今年（MM-dd HH:mm:ss)
    今天
        1分钟内
            刚刚
        1小时内
            xx分钟前
        其他
            xx小时前
    昨天
        昨天（HH:mm:ss）
    其他
        （MM-dd HH:mm:ss)
 非今年（yyyy-MM-dd HH:mm:ss）
 */
// 重写get方法，返回规定的时间
- (NSString *)created_at {
    // 格式化时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 发帖时间
    NSDate *create = [fmt dateFromString:_created_at];
    if (create.isThisYear) {  // 今年
        if (create.isToday) {   // 今天
            // 两个时间相差的时间
            NSDateComponents *cmps =[[NSDate date] deltaFrom:create];
            if (cmps.hour >= 1) {   // 时间>1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) {  // 时间<1小时 并且 大于1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else {    // 小于1分钟
                return @"刚刚";
            }
        } else if (create.isYesterday) {    // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else {    // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else {    // 不是今年
        return _created_at;
    }
}

@end

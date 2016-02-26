//
//  NSDate+SJTExtension.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/26.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "NSDate+SJTExtension.h"

@implementation NSDate (SJTExtension)

/**
 *  比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)form {
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 用NSCalendar比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:form toDate:self options:0];
}

- (BOOL)isThisYear {
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:(NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:(NSCalendarUnitYear) fromDate:self];
    return nowYear == selfYear;
}

//- (BOOL)isToday {
//    // 日历对象
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *nowCmps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
//    return nowCmps.year == selfCmps.year && nowCmps.month == selfCmps.month && nowCmps.day == selfCmps.day;
//}

- (BOOL)isToday {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday {
    /**
     *  2014-12-31 -> 2015-01-01
     *  2014-12-31 23:58:58 -> 2015-01-01 00:00:01
     */
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

@end

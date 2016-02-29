//
//  SJTRecommendCategory.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//  推荐关注 左边的数据模型

#import "SJTRecommendCategory.h"
//#import <MJExtension.h>

@implementation SJTRecommendCategory

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

//+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
//    if ([propertyName isEqualToString:@"ID"]) {
//        return @"id";
//    }
//    return propertyName;
//}

- (NSMutableArray *)users {
    if (!_users) {
        self.users = [[NSMutableArray alloc] init];
    }
    return _users;
}

@end

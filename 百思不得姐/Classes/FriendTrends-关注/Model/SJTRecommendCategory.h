//
//  SJTRecommendCategory.h
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJTRecommendCategory : NSObject
#pragma mark - 字典属性
/** id */
@property (nonatomic, assign) NSInteger ID;

/** 总数 */
@property (nonatomic, assign) NSInteger count;

/** 名字 */
@property (nonatomic, copy) NSString *name;



#pragma mark - 自定义属性辅助开发
/** 这个类别对应的用户数据 */
@property (nonatomic, strong) NSMutableArray *users;
/** 总数 */
@property (nonatomic, assign) NSInteger total;
/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

@end

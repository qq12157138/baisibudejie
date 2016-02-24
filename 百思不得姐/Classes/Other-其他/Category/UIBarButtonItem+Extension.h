//
//  UIBarButtonItem+Extension.h
//  黑马微博2期
//
//  Created by 史江涛 on 16/2/16.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (instancetype)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end

//
//  SJTPregressView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/27.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTPregressView.h"

@implementation SJTPregressView

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [super setProgress:progress animated:animated];
    
    self.primaryColor = [UIColor whiteColor];
    self.secondaryColor = [UIColor whiteColor];
}

@end

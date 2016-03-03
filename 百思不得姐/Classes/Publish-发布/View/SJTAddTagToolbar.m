//
//  SJTAddTagToolbar.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTAddTagToolbar.h"

@interface SJTAddTagToolbar ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation SJTAddTagToolbar


- (void)awakeFromNib {
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:(UIControlStateNormal)];
//    addButton.size = [addButton imageForState:(UIControlStateNormal)].size;
    addButton.size = addButton.currentImage.size;
    addButton.x = SJTTopicCellMargin;
    [self.topView addSubview:addButton];
}

- (void)addbuttonClick {
    
}

@end

//
//  SJTMeCell.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTMeCell.h"

@implementation SJTMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.imageView.image) {
        return;
    }
    
    self.imageView.width = 30;
    self.imageView.height = 30;
    self.imageView.centerY = self.contentView.height * 0.5;
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + SJTTopicCellMargin;
}

@end

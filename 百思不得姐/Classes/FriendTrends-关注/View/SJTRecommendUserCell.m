//
//  SJTRecommendUserCell.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/23.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTRecommendUserCell.h"
#import "SJTRecommendUser.h"
#import <UIImageView+WebCache.h>

@interface SJTRecommendUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation SJTRecommendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUser:(SJTRecommendUser *)user {
    _user = user;
    
    self.screenNameLabel.text = user.screen_name;
    NSString *fansCount = nil;
    if (user.fans_count < 10000) {
        fansCount = [NSString stringWithFormat:@"%zd人关注", user.fans_count];
    } else {
        fansCount = [NSString stringWithFormat:@"%.1f万人关注", user.fans_count / 10000.0];
    }
    self.fansCountLabel.text = fansCount;
    
    // 设置头像
    [self.headerImageView setHeader:user.header];
}

@end

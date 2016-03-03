//
//  SJTRecommendTagCell.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/23.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTRecommendTagCell.h"
#import "SJTRecommendTag.h"
#import <UIImageView+WebCache.h>

@interface SJTRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation SJTRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setRecommendTag:(SJTRecommendTag *)recommendTag {
    _recommendTag = recommendTag;
    
    // 设置头像
    [self.imageListImageView setHeader:recommendTag.image_list];
    
    self.themeNameLabel.text = recommendTag.theme_name;
    NSString *subNumber = nil;
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅", recommendTag.sub_number];
    } else {
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅", recommendTag.sub_number / 10000.0];
    }
    self.subNumberLabel.text = subNumber;
    
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    frame.size.width -= frame.origin.x * 2;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    // 要想外界永远改不了你的控件尺寸，那么就重写bounds和frame
}

@end

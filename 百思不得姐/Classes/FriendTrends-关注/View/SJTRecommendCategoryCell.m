//
//  SJTRecommendCategoryCell.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/22.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTRecommendCategoryCell.h"
#import "SJTRecommendCategory.h"

@interface SJTRecommendCategoryCell()
/**
 *  选中时显示的指示控件
 */
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation SJTRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = SJTGlobalBg;
    self.selectedIndicator.backgroundColor = SJTColor(219, 21, 26);
    
    // 当cell的selection为None时，cell被选中时，内部的子控件就不会进入高亮状态
//    self.textLabel.textColor = SJTColor(78, 78, 78);
//    self.textLabel.highlightedTextColor = SJTColor(219, 21, 26);
    
//    UIView *bg = [[UIView alloc] init];
//    bg.backgroundColor = [UIColor clearColor];
//    self.selectedBackgroundView = bg;
    
}

- (void)setCategory:(SJTRecommendCategory *)category {
    _category = category;
    
    self.textLabel.text = category.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 重新调整内部textLable的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

/**
 *  监听cell点击，当一行被选中就会设置它的setSelected，并且传入yes
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectedIndicator.hidden = !selected;
    
    // 设置选中和不选中的文字颜色
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : SJTColor(78, 78, 78);
    
    // 设置选中和不选中的背景颜色
    self.textLabel.backgroundColor = selected ? [UIColor whiteColor] : SJTGlobalBg;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
}
@end

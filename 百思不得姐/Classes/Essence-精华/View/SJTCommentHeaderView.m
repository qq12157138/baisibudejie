//
//  SJTCommentHeaderView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/1.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTCommentHeaderView.h"

@interface SJTCommentHeaderView()

/** 文字标签 */
@property (nonatomic, weak) UILabel *label;

@end

@implementation SJTCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    // 先从缓存池里找header
    static NSString *ID = @"header";
    SJTCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!header) {  // 缓存池中没有，自己创建
        header = [[SJTCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = SJTGlobalBg;
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label = [[UILabel alloc] init];
        label.textColor = SJTColor(67, 67, 67);
        label.width = 200;
        label.x = SJTTopicCellMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.label.text = title;
}

@end

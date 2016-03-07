//
//  SJTAddTagToolbar.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTAddTagToolbar.h"
#import "SJTAddTagViewController.h"

@interface SJTAddTagToolbar ()
@property (weak, nonatomic) IBOutlet UIView *topView;

/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;

/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;
@end

@implementation SJTAddTagToolbar

- (NSMutableArray *)tagLabels {
    if (!_tagLabels) {
        self.tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib {
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addbuttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:(UIControlStateNormal)];
//    addButton.size = [addButton imageForState:(UIControlStateNormal)].size;
    addButton.size = addButton.currentImage.size;
    addButton.x = SJTTagMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    // 默认拥有2个标签
    [self createTagLabels:@[@"吐槽", @"糗事", @"搞笑"]];
}


- (void)addbuttonClick {
    SJTAddTagViewController *addTagVc = [[SJTAddTagViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [addTagVc setTagsBlock:^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    }];
    addTagVc.tags = [self.tagLabels valueForKeyPath:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:addTagVc animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 再重新添加
    for (int i = 0; i<self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];
        
        // 设置位置
        if (i == 0) {   // 最前面的标签按钮
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else {    // 其他标签按钮
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + SJTTagMargin;
            // 计算当前行剩余的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= tagLabel.width) { //按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else {    // 显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + SJTTagMargin;
            }
        }
    }
    // 最后一个标签按钮的位置
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + SJTTagMargin;
    
    // 更新textField的frame
    if (self.topView.width - leftWidth >= self.addButton.width) {
        self.addButton.y = lastTagLabel.y;
        self.addButton.x = leftWidth;
    } else {
        self.addButton.x = 0;
        self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + SJTTagMargin;
    }
    
    // 整体的高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.addButton.frame) + 45 + 22;
    self.y -= self.height - oldH;
}

/**
 创建标签
 */
- (void)createTagLabels:(NSArray *)tags {
    self.tags = tags;
    // 先让数组中的所有元素删除
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 清空数组
    [self.tagLabels removeAllObjects];
    // 再重新添加
    for (int i = 0; i<tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [tagLabel.layer setMasksToBounds:YES];
        [tagLabel.layer setCornerRadius:SJTTagRadius];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = SJTTagBg;
        tagLabel.text = tags[i];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = SJTTagFont;
        [tagLabel sizeToFit];
        tagLabel.width += 2 * SJTTagMargin;
        tagLabel.height = SJTTagH;
        [self.topView addSubview:tagLabel];
    }
    // 重新布局子控件
    [self setNeedsLayout];
}

@end

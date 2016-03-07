//
//  SJTAddTagViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/4.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTAddTagViewController.h"
#import "SJTTagButton.h"
#import "SJTTagTextField.h"
#import <SVProgressHUD.h>


@interface SJTAddTagViewController () <UITextFieldDelegate>

/** 内容 */
@property (nonatomic, weak) UIView *contentView;

/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;

/** 文本输入框 */
@property (nonatomic, weak) SJTTagTextField *textField;

/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;

@end

@implementation SJTAddTagViewController

#pragma mark - 懒加载
- (NSMutableArray *)tagButtons {
    if (!_tagButtons) {
        self.tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)addButton {
    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [addButton.layer setMasksToBounds:YES];
        [addButton.layer setCornerRadius:SJTTagRadius];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        addButton.titleLabel.font = SJTTagFont;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, SJTTagMargin, 0, SJTTagMargin);
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.backgroundColor = [UIColor whiteColor];
        [addButton setTitleColor:SJTTagBg forState:UIControlStateNormal];
        [addButton.layer setBorderWidth:1.0];
        addButton.layer.borderColor = SJTTagBg.CGColor;
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        [self.view addSubview:contentView];
        self.contentView = contentView;
    }
    return _contentView;
}

- (SJTTagTextField *)textField {
    if (!_textField) {
        __weak typeof(self) weakSelf =self;
        SJTTagTextField *textField = [[SJTTagTextField alloc] init];
        textField.deleteBlock = ^{
            if (!weakSelf.textField.hasText) {
                [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
            }
        };
        [textField addTarget:self action:@selector(textDidChange) forControlEvents:(UIControlEventEditingChanged)];
        [textField becomeFirstResponder];
        textField.delegate = self;
        [self.contentView addSubview:textField];
        self.textField = textField;
    }
    return _textField;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

- (void)setupTags {
    if (self.tags.count) {
        for (NSString *tag in self.tags) {
            self.textField.text = tag;
            [self addButtonClick];
        }
        self.tags = nil;
    }
}

- (void)setupNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(done)];
}

/**
 完成按钮的点击
 */
- (void)done {
    // 传递数据给上一个控制器
//    NSMutableArray *tags = [NSMutableArray array];
//    for (SJTTagButton *tagButton in self.tagButtons) {
//        [tags addObject:tagButton.currentTitle];
//    }
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    // 传递tags给这个block
    !self.tagsBlock ? : self.tagsBlock(tags);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.contentView.x = SJTTagMargin;
    self.contentView.width = self.view.width - 2 * self.contentView.x;
    self.contentView.y = 64 + SJTTagMargin;
    self.contentView.height = SJTScreenH;
    
    self.textField.width = self.contentView.width;
    
    self.addButton.width = self.contentView.width;
    self.addButton.height = 35;
    
    
    [self setupTags];
}

#pragma mark - 监听文字改变
/**
 监听文字改变时
 */
- (void)textDidChange{
    if (self.textField.hasText) {    // 有文字
        // 显示"添加标签"的按钮
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + SJTTagMargin;
        
        // 文字属性
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = SJTTagBg;
        // 富文本（NSMutableAttributedString可以设置每个字的颜色、字体、大小等）
        NSMutableAttributedString *tagTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"添加标签: %@" , self.textField.text] attributes:attrs];
        
        [tagTitle setAttributes:@{NSForegroundColorAttributeName : SJTRandomColor} range:(NSMakeRange(arc4random_uniform(2), 1))];
        [tagTitle setAttributes:@{NSForegroundColorAttributeName : SJTRandomColor} range:(NSMakeRange((arc4random() % 4) + 2, 1))];
        [self.addButton setAttributedTitle:tagTitle forState:UIControlStateNormal];
        
        // 获得最后一个字符
        NSString *text = self.textField.text;
        NSInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if (([lastLetter isEqualToString:@","] || [lastLetter isEqualToString:@"，"]) && len > 1) {
            // 去掉逗号
            self.textField.text = [text substringToIndex:len - 1];
            [self addButtonClick];
        }
        
    } else {    // 没文字
        // 隐藏"添加标签"的按钮
        self.addButton.hidden = YES;
    }
    
    // 更新文本框的frame
    [self updateTextFieldFrame];
}

#pragma mark - 监听按钮点击
/**
 监听"添加标签"按钮点击
 */
- (void)addButtonClick {
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签" maskType:(SVProgressHUDMaskTypeBlack)];
        return;
    }
    
    // 添加一个“标签按钮”
    SJTTagButton *tagButton = [SJTTagButton buttonWithType:(UIButtonTypeCustom)];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [tagButton setTitle:self.textField.text forState:(UIControlStateNormal)];
    [self.contentView addSubview:tagButton];
    // 存储标签按钮
    [self.tagButtons addObject:tagButton];
    
    self.textField.text = nil;
    self.addButton.hidden = YES;
    
    // 更新标签按钮frame
    [self updateTagButtonFrame];
    [self updateTextFieldFrame];
}

/**
 标签按钮被点击
 */
- (void)tagButtonClick:(SJTTagButton *)tagButton {
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    // 更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

#pragma mark - 子控件的frame处理
/**
 专门用来更新标签按钮的frame
 */
- (void)updateTagButtonFrame {
    // 更新标签按钮的frame
    for (int i = 0; i < self.tagButtons.count; i++) {
        SJTTagButton *tagButton = self.tagButtons[i];
        if (i == 0) {   // 最前面的标签按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else {    // 其他标签按钮
            SJTTagButton *lastTagButton = self.tagButtons[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + SJTTagMargin;
            // 计算当前行剩余的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagButton.width) { //按钮显示在当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else {    // 显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + SJTTagMargin;
            }
        }
    }
    
    [self updateTextFieldFrame];
}

/**
 更新textField的frame
 */
- (void)updateTextFieldFrame {
    // 最后一个标签按钮的位置
    SJTTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + SJTTagMargin;
    
    // 更新textField的frame
    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.y = lastTagButton.y;
        self.textField.x = leftWidth;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + SJTTagMargin;
    }
    // 更新添加标签的frame
    self.addButton.y = CGRectGetMaxY(self.textField.frame) + SJTTagMargin;
}

/**
 计算textField文字的宽度
 */
- (CGFloat)textFieldTextWidth {
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}

#pragma mark - UITextFieldDelegate
/**
 监听键盘最右下角按钮的点击（return key）
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.hasText) {
        [self addButtonClick];
    }
    return YES;
}

@end

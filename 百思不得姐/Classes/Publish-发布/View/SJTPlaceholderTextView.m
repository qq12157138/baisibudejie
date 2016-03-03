//
//  SJTPlaceholderTextView.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTPlaceholderTextView.h"

@interface SJTPlaceholderTextView ()
/** 占位文字label */
@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation SJTPlaceholderTextView

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 6;
        placeholderLabel.y = 8;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;   // 这样写也可以，是set方法
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = YES;
        
        // 默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 默认占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 监听文本改变
        [SJTNoteCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

/**
 监听文字改变
 */
- (void)textDidChange {
    // 重画
//    [self setNeedsDisplay];
    
    // 只要有文字就隐藏占位文字label
    self.placeholderLabel.hidden = self.hasText;
}

- (void)dealloc {
    [SJTNoteCenter removeObserver:self];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
//}

// 改用添加label，成为textView的子控件方便联动
///**
// 绘制占位文字（每次画之前，会自动清除之前绘制的内容）
// */
//- (void)drawRect:(CGRect)rect {
//    // 如果文字长度不等于0直接返回，不绘制占位文字
////    if (self.text.length || self.attributedText.length) return;
//    if (self.hasText) return;
//    
//    // 处理rect
//    rect.origin.x = 4;
//    rect.origin.y = 7;
//    rect.size.width -= 2 * rect.origin.x;
//    
//    // 文字属性
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = self.font;
//    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
//    [self.placeholder drawInRect:rect withAttributes:attrs];
//}

/**
  更新占位文字的尺寸
 */
//- (void)updatePlaceholderLabelSize {
    // 文字的最大尺寸
//    CGSize maxSize = CGSizeMake(SJTScreenW - 2 * self.placeholderLabel.x, MAXFLOAT);
//    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
//}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

#pragma mark - 重写setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
    // 等你有尺寸的时候帮我调一下layoutSubviews
    [self setNeedsLayout];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    // 等你有尺寸的时候帮我调一下layoutSubviews
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textDidChange];
    
}

/**
 [self setNeedsLayout];     会在恰当的时刻调用layoutSubviews
 [self setNeedsDisplay];    会在恰当的时刻调用drawRect
 */

@end

//
//  SJTCommentCell.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/1.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTCommentCell.h"
#import "SJTComment.h"
#import <UIImageView+WebCache.h>
#import "SJTUser.h"

@interface SJTCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation SJTCommentCell

- (void)awakeFromNib {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setComment:(SJTComment *)comment {
    _comment = comment;
    
    // 设置头像
    [self.profileImageView setHeader:comment.user.profile_image];
    
    self.sexView.image = [comment.user.sex isEqualToString:SJTUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
//    [NSString stringWithFormat:@"%@%@%@",comment.content,comment.content,comment.content];
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];

    if (comment.voiceurl.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:(UIControlStateNormal)];
    } else {
        self.voiceButton.hidden = YES;
    }
}

/**
 *  重写frame给cell添加边距（也就是为了不让cell粘在一起）
 */
//- (void)setFrame:(CGRect)frame {
//    frame.origin.x = SJTTopicCellMargin;
//    frame.size.width -= SJTTopicCellMargin * 2;
//    
//    [super setFrame:frame];
//}

#pragma mark - MenuController处理
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 不要系统自带的
    return NO;
}

@end

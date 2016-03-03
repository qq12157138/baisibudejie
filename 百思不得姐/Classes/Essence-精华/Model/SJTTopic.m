//
//  SJTTopic.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/25.
//  Copyright © 2016年 史江涛. All rights reserved.
//  帖子

#import "SJTTopic.h"
#import <MJExtension.h>
#import "SJTUser.h"
#import "SJTComment.h"

@implementation SJTTopic
{
    // 自己声明成员变量，因为cellHeight你设置成readonly，防止外界更改，那么编译器就不会帮你生成set方法，那么成员变量也不会生成
    CGFloat _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"samll_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]",
             @"qzone_uid" : @"top_cmt[0].user.qzone_uid"
             };
}
// 指定该属性的类型，并不对该类进行依赖
+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"top_cmt" : [SJTComment class]};
        return @{@"top_cmt" : @"SJTComment"};
}

/*
 今年（MM-dd HH:mm:ss)
    今天
        1分钟内
            刚刚
        1小时内
            xx分钟前
        其他
            xx小时前
    昨天
        昨天（HH:mm:ss）
    其他
        （MM-dd HH:mm:ss)
 非今年（yyyy-MM-dd HH:mm:ss）
 */
// 重写get方法，返回规定的时间
- (NSString *)created_at {
    // 格式化时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 发帖时间
    NSDate *create = [fmt dateFromString:_created_at];
    if (create.isThisYear) {  // 今年
        if (create.isToday) {   // 今天
            // 两个时间相差的时间
            NSDateComponents *cmps =[[NSDate date] deltaFrom:create];
            if (cmps.hour >= 1) {   // 时间>1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) {  // 时间<1小时 并且 大于1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else {    // 小于1分钟
                return @"刚刚";
            }
        } else if (create.isYesterday) {    // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else {    // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else {    // 不是今年
        return _created_at;
    }
}

- (CGFloat)cellHeight {
    // 只计算一次高度，如果有值就不计算
    if (!_cellHeight) {
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * SJTTopicCellMargin, MAXFLOAT);
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell的高度（文字部分
        _cellHeight = SJTTopicCellTextY + textH + SJTTopicCellMargin;
        
        // 根据段子的类型来计算cell 的高度
        if (self.type == SJTTopicPicture) {  // 图片帖子
            // 图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            // 图片显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            
            // 图片高度过长就限制高度
            if (pictureH >= SJTTopicCellPictureMaxH) {
                self.bigPicture = YES;
                pictureH = SJTTopicCellPictureBreakH;
            }
            
            // 计算图片控件的frame
            CGFloat pictureX = SJTTopicCellMargin;
            CGFloat pictureY = SJTTopicCellTextY + textH + SJTTopicCellMargin;
            _pictureViewFrame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + SJTTopicCellMargin;
        } else if (self.type == SJTTopicVoice) {    // 声音帖子
            CGFloat voiceX = SJTTopicCellMargin;
            CGFloat voiceY = SJTTopicCellTextY + textH + SJTTopicCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            _cellHeight += voiceH + SJTTopicCellMargin;
        } else if (self.type == SJTTopicVideo) { // 视频帖子
            CGFloat videoX = SJTTopicCellMargin;
            CGFloat videoY = SJTTopicCellTextY + textH + SJTTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoFrame = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + SJTTopicCellMargin;
        }
        
        // 如果有最热评论
//        SJTComment *cmt = [self.top_cmt firstObject];
//        if (cmt) {
//            NSString *content = [NSString stringWithFormat:@"%@ : %@", cmt.user.username, cmt.content];
//            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
//            _cellHeight += SJTTopicCellTopCmtTitleH + contentH + SJTTopicCellMargin;
//        }
        if (self.top_cmt) {
            NSString *content = [NSString stringWithFormat:@"%@ : %@", self.top_cmt.user.username, self.top_cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += SJTTopicCellTopCmtTitleH + contentH + SJTTopicCellMargin;
        }
        
        
        // 底部工具条高度
        _cellHeight += SJTTopicCellBottomBarH + SJTTopicCellMargin;
    }
    
    return _cellHeight;
}



@end

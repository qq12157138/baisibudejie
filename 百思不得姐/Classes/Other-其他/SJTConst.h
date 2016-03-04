//
//  SJTConst.h
//  百思不得姐
//
//  Created by 史江涛 on 16/2/25.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SJTTopicAll = 1,
    SJTTopicPicture = 10,
    SJTTopicWord = 29,
    SJTTopicVoice = 31,
    SJTTopicVideo = 41
} SJTTopicType;

/** 精华-所有顶部标题高度 */
UIKIT_EXTERN CGFloat const SJTTitleViewH;
/** 精华-所有顶部标题Y */
UIKIT_EXTERN CGFloat const SJTTitleViewY;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const SJTTopicCellMargin;
/** 精华-cell-文字内容的Y值 */
UIKIT_EXTERN CGFloat const SJTTopicCellTextY;
/** 精华-cell-底部工具条高度 */
UIKIT_EXTERN CGFloat const SJTTopicCellBottomBarH;

/** 精华-cell-图片帖子最大高度 */
UIKIT_EXTERN CGFloat const SJTTopicCellPictureMaxH;
/** 精华-cell-图片帖子超过最大高度的固定高度 */
UIKIT_EXTERN CGFloat const SJTTopicCellPictureBreakH;

/** SJTUser模型-性别属性值 */
UIKIT_EXTERN NSString * const SJTUserSexMale;
UIKIT_EXTERN NSString * const SJTUserSexFemale;

/** 精华-cell-最热评论标题的高度 */
UIKIT_EXTERN CGFloat const SJTTopicCellTopCmtTitleH;

/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const SJTTabBarDidSelectNotification;
/** tabBar被选中的通知 - 被点击的控制器的index key */
UIKIT_EXTERN NSString * const SJTSelectedControllerIndexKey;
/** tabBar被选中的通知 - 被点击的控制器的key */
UIKIT_EXTERN NSString * const SJTSelectedControllerKey;

/** 标签-间距 */
UIKIT_EXTERN CGFloat const SJTTagMargin;
/** 标签-高度 */
UIKIT_EXTERN CGFloat const SJTTagH;
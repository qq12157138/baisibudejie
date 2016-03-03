//
//  SJTPostWordViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTPostWordViewController.h"
#import "SJTPlaceholderTextView.h"
#import "SJTAddTagToolbar.h"

@interface SJTPostWordViewController () <UITextViewDelegate>

/** 文本输入控件 */
@property (nonatomic, weak) SJTPlaceholderTextView *textView;

/** 工具条 */
@property (nonatomic, weak) SJTAddTagToolbar *toolbar;
@end

@implementation SJTPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolbar];
}

/**
 监听键盘的弹出和隐藏
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 键盘最终的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0,  keyboardF.origin.y - SJTScreenH);
    }];
}

- (void)setupToolbar {
    SJTAddTagToolbar *toolbar = [SJTAddTagToolbar viewFromXib];
    toolbar.width = self.view.width;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    // 监听键盘
    [SJTNoteCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)setupTextView {
    SJTPlaceholderTextView *textView = [[SJTPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友的膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setupNav {
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:(UIBarButtonItemStyleDone) target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;    // 默认不能点击
    // 强制刷新，否则appearance设置不生效
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post {
    
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end

//
//  SJTLoginRegisterViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/2/24.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTLoginRegisterViewController.h"

@interface SJTLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

/**
 *  登录框距离控制器view左边的间距
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation SJTLoginRegisterViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 设置导航栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 文字属性
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
//    // 富文本（带有属性的文字，可以让文字丰富多彩）
//    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:attrs];
//    self.phoneField.attributedPlaceholder = placeholder;
    
    // 富文本（NSMutableAttributedString可以设置每个字的颜色、字体、大小等）
//    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"手机号"];
//    [placeholder setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:(NSMakeRange(0, 1))];
//    [placeholder setAttributes:@{NSForegroundColorAttributeName : [UIColor yellowColor]} range:(NSMakeRange(1, 1))];
//    [placeholder setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:(NSMakeRange(2, 1))];
//    self.phoneField.attributedPlaceholder = placeholder;
}

- (IBAction)showLoginOrRegister:(UIButton *)button {
    // 切换之前退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) {   // 显示注册
        self.loginViewLeftMargin.constant = -self.view.width;
        [button setTitle:@"已有帐号?" forState:(UIControlStateNormal)];
//        button.selected = YES;
    } else {    // 显示登录
        self.loginViewLeftMargin.constant = 0;
        [button setTitle:@"注册帐号" forState:(UIControlStateNormal)];
//        button.selected = NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        // 马上更新位置
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/**
 *  当前控制器对应的状态栏（白色）
 */
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

@end

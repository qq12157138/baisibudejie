//
//  SJTWebViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/3.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTWebViewController.h"
#import <NJKWebViewProgress.h>

@interface SJTWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webVIew;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/** 进度代理对象 */
@property (nonatomic, strong) NJKWebViewProgress *progress;

@end

@implementation SJTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webVIew.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    self.progress.progressBlock = ^(float progress) {
        weakSelf.progressView.progress = progress;
        weakSelf.progressView.hidden = progress == 1.0;
    };
    
    self.progress.webViewProxyDelegate = self;
    
    [self.webVIew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)refresh:(id)sender {
    [self.webVIew reload];
}
- (IBAction)goBack:(id)sender {
    [self.webVIew goBack];
}
- (IBAction)goForward:(id)sender {
    [self.webVIew goForward];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}

// 网页加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end

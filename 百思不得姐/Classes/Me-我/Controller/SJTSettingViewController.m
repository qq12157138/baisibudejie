//
//  SJTSettingViewController.m
//  百思不得姐
//
//  Created by 史江涛 on 16/3/5.
//  Copyright © 2016年 史江涛. All rights reserved.
//

#import "SJTSettingViewController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>

@interface SJTSettingViewController ()

@end

@implementation SJTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = SJTGlobalBg;
    
    // 图片缓存
    //    NSInteger size = [SDImageCache sharedImageCache].getSize;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingString:@"default/com.hackemist.SDWebImageCache.default"];
    // 获得文件夹内部的所有内容
//    NSArray *contents = [manager contentsOfDirectoryAtPath:cachePath error:nil];
    NSArray *subpaths = [manager subpathsAtPath:cachePath];
}

- (void)getSize {
    // 图片缓存
    //    NSInteger size = [SDImageCache sharedImageCache].getSize;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingString:@"default/com.hackemist.SDWebImageCache.default"];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSInteger totalSize = 0;
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        
//        BOOL dir = NO;
//        [manager fileExistsAtPath:filePath isDirectory:&dir];
//        if (dir) continue;
        
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        totalSize += [attrs fileSize];
    }
    SJTLog(@"%zd", totalSize);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存（已使用%.2fM）", size];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[SDImageCache sharedImageCache] clearDisk];
    
//    [[NSFileManager defaultManager] removeItemAtPath:<#(nonnull NSString *)#> error:nil];
    
    [SVProgressHUD showSuccessWithStatus:@"清除成功"];
    [self.tableView reloadData];
}

@end

//
//  ViewController.m
//  NSThreadDemo
//
//  Created by 张延深 on 2019/11/20.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ThreadCommunicationViewController.h"

@interface ThreadCommunicationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@end

@implementation ThreadCommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线程通信";
}

#pragma mark - Event response

- (IBAction)downloadImage:(UIButton *)sender {
    [NSThread detachNewThreadSelector:@selector(downloadImageTask) toTarget:self withObject:nil];
    [self.indicatorView startAnimating];
    self.downloadBtn.enabled = NO;
}

#pragma mark - Private methods

- (void)downloadImageTask {
    NSLog(@"current thread ----- %@", [NSThread currentThread]);
    // 1.图片url
    NSURL *imgUrl = [NSURL URLWithString:@"https://ysc-demo-1254961422.file.myqcloud.com/YSC-phread-NSThread-demo-icon.jpg"];
    // 2.下载图片
    NSError *err;
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl options:NSDataReadingMappedIfSafe error:&err];
    if (err) {
        NSLog(@"下载图片失败：%@", err);
        return;
    }
    if (imgData) {
        UIImage *image = [UIImage imageWithData:imgData];
        // 3.回到主线程刷新UI
        [self performSelectorOnMainThread:@selector(refreshUI:) withObject:image waitUntilDone:YES];
    }
}

// 刷新界面
- (void)refreshUI:(UIImage *)image {
    NSLog(@"current thread ----- %@", [NSThread currentThread]);
    self.imgView.image = image;
    [self.indicatorView stopAnimating];
    self.downloadBtn.enabled = YES;
}

@end

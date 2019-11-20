//
//  ThreadCommunication2ViewController.m
//  NSThreadDemo
//
//  Created by 张延深 on 2019/11/20.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ThreadCommunication2ViewController.h"

@interface ThreadCommunication2ViewController ()

@property (nonatomic, strong) NSThread *thread;

@end

@implementation ThreadCommunication2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UI线程取消子线程";
    [self initThread];
}

#pragma mark - Event response

- (IBAction)cancelSubThread:(UIButton *)sender {
    if (self.thread.isCancelled) {
        NSLog(@"%@已经取消", self.thread.name);
        return;
    }
    [self.thread cancel];
}

- (void)run {
    for (int i = 0; i < 100; i++) {
        if ([NSThread currentThread].isCancelled) {
            [NSThread exit];
        }
        NSLog(@"-----%@-----:%d", [NSThread currentThread].name, i);
        [NSThread sleepForTimeInterval:0.5];
    }
}

#pragma mark - Private methods

- (void)initThread {
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    self.thread.name = @"子线程";
    [self.thread start];
}

@end

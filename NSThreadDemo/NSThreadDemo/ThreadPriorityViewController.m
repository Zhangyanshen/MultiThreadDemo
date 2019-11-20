//
//  ThreadPriorityViewController.m
//  NSThreadDemo
//
//  Created by 张延深 on 2019/11/20.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ThreadPriorityViewController.h"

@interface ThreadPriorityViewController ()

@end

@implementation ThreadPriorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线程优先级";
    NSLog(@"UI线程优先级为：%lf", [NSThread threadPriority]);
    // 创建第一个线程
    NSThread *thread1 = [self createThreadWithName:@"线程A" selector:@selector(run)];
    NSLog(@"线程A的优先级：%lf", thread1.threadPriority);
    thread1.threadPriority = 0.1;
    // 创建第二个线程
    NSThread *thread2 = [self createThreadWithName:@"线程B" selector:@selector(run)];
    NSLog(@"线程B的优先级：%lf", thread2.threadPriority);
    thread2.threadPriority = 1.0;
    // 启动线程
    [thread1 start];
    [thread2 start];
}

#pragma mark - Event response

- (void)run {
    for (int i = 0; i < 100; i++) {
        NSLog(@"-----%@-----%d", [NSThread currentThread].name, i);
    }
}

#pragma mark - Private methods

- (NSThread *)createThreadWithName:(NSString *)name selector:(SEL)selector {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:selector object:nil];
    thread.name = name;
    return thread;
}

@end

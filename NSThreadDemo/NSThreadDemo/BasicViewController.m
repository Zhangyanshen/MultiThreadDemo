//
//  MainViewController.m
//  NSThreadDemo
//
//  Created by 张延深 on 2019/11/20.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建线程";
//    [self testNSThread];
//    [self testNSThreadAutoStart];
//    [self testImplicitCreateThread];
    
    for (int i = 0; i < 100; i++) {
        NSLog(@"===== %@ ===== %d", [NSThread currentThread], i);
        if (i == 20) {
            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
            [thread start];
            // 将主线程睡眠0.001秒，CPU会去调度上面新创建的线程
            [NSThread sleepForTimeInterval:0.001];
        }
    }
}

#pragma mark - Private methods

// 手动启动线程
- (void)testNSThread {
    // 1.创建线程(新建状态，无动态特征)
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRun) object:nil];
    // 设置线程名字
    [thread setName:@"cn.newbanker.test_thread"];
    // 2.启动线程(就绪状态，什么时候执行，取决于系统调度)
    [thread start];
}

// 创建线程后，自动启动
- (void)testNSThreadAutoStart {
    [NSThread detachNewThreadSelector:@selector(threadRun) toTarget:self withObject:nil];
}

// 隐式创建并启动线程
- (void)testImplicitCreateThread {
    [self performSelectorInBackground:@selector(threadRun) withObject:nil];
    [self performSelector:@selector(threadRun) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(threadRun) withObject:nil waitUntilDone:NO];
}

- (void)threadRun {
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)run {
    for (int i = 0; i < 100; i++) {
        NSLog(@"===== %@ ===== %d", [NSThread currentThread], i);
        if (i == 10) {
            NSLog(@"%@", [NSThread currentThread].isExecuting ? @"正在运行" : @"没有运行");
            NSLog(@"%@", [NSThread currentThread].isFinished ? @"完成" : @"没有完成");
        }
        // 运行到i == 50时，终止当前线程
        if (i == 50) {
            [NSThread exit];
        }
    }
}

@end

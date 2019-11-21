//
//  ViewController.m
//  GCDDemo
//
//  Created by 张延深 on 2019/11/20.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger ticketCount;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testDemo1];
//    [self testDemo2];
//    [self testDemo3];
//    [self testDemo4];
//    [self testDemo5];
//    [self testDemo6];
//    [self testDemo7];
//    [self testDemo8];
//    [self testDemo9];
//    [self testDemo10];
//    [self testDemo11];
//    [self testDemo12];
//    [self testDemo13];
//    [self testDemo14];
//    [self testDemo15];
//    [self testDemo16];
//    [self testDemo17];
//    [self testDemo18];
//    [self testDemo19];
//    [self barrier];
//    [self after_main];
//    [self after_global];
//    [self apply_main];
//    [self apply_serial];
//    [self apply_global];
//    [self groupNotify];
//    [self groupWait];
//    [self groupEnterAndLeave];
//    [self semaphoreSync];
    [self semaphoreSafe];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self once];
}

#pragma mark -

// 1 5 2 4 3
- (void)testDemo1 {
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_async(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

// 1 5 2 死锁
- (void)testDemo2 {
    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

// >= 5
- (void)testDemo3 {
    __block int a = 0;
    while (a < 5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            a++;
        });
    }
    NSLog(@"a == %d", a);
}

#pragma mark - sync

// sync + serial_queue
- (void)testDemo4 {
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    NSLog(@"1");
    dispatch_sync(queue, ^{
        NSLog(@"%@:2", [NSThread currentThread]);
    });
    NSLog(@"3");
}

// sync + concurrent_queue
- (void)testDemo5 {
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_sync(queue, ^{
        NSLog(@"%@:2", [NSThread currentThread]);
    });
    NSLog(@"3");
}

// sync + main_queue 死锁
- (void)testDemo6 {
    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"%@:2", [NSThread currentThread]);
    });
    NSLog(@"3");
}

// sync + global_queue
- (void)testDemo7 {
    NSLog(@"1");
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@:2", [NSThread currentThread]);
    });
    NSLog(@"3");
}

#pragma mark - async

// async + main_queue
- (void)testDemo8 {
    NSLog(@"1");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@:2", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@:3", [NSThread currentThread]);
    });
    NSLog(@"4");
}

// async + global_queue
- (void)testDemo9 {
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@:2", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@:3", [NSThread currentThread]);
    });
    NSLog(@"4");
}

// async + serial_queue
- (void)testDemo10 {
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"%@:2", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@:3", [NSThread currentThread]);
    });
    NSLog(@"4");
}

// async + concurrent_queue
- (void)testDemo11 {
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"%@:2", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@:3", [NSThread currentThread]);
    });
    NSLog(@"4");
}

#pragma mark - 嵌套sync

- (void)testDemo12 {
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"3:%@", [NSThread currentThread]);
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)testDemo13 {
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_sync(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"3:%@", [NSThread currentThread]);
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

// 死锁
- (void)testDemo14 {
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"3:%@", [NSThread currentThread]);
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

// 死锁
- (void)testDemo15 {
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    NSLog(@"1");
    dispatch_sync(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"3:%@", [NSThread currentThread]);
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

#pragma mark - 嵌套async

- (void)testDemo16 {
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"3:%@", [NSThread currentThread]);
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)testDemo17 {
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1");
    dispatch_sync(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"3:%@", [NSThread currentThread]);
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)testDemo18 {
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    NSLog(@"1");
    dispatch_async(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"3:%@", [NSThread currentThread]);
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)testDemo19 {
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    NSLog(@"1");
    dispatch_sync(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"3:%@", [NSThread currentThread]);
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

#pragma mark - dispatch_barrier

- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier:%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"4:%@", [NSThread currentThread]);
    });
}

#pragma mark - dispatch_after 异步

- (void)after_main {
    NSLog(@"begin:%@", [NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"3秒后添加：%@", [NSThread currentThread]);
    });
    NSLog(@"end:%@", [NSThread currentThread]);
}

- (void)after_global {
    NSLog(@"begin:%@", [NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"3秒后添加：%@", [NSThread currentThread]);
    });
    NSLog(@"end:%@", [NSThread currentThread]);
}

#pragma mark - dispatch_once

- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"只执行一次");
    });
}

#pragma mark - dispatch_apply 同步

// 死锁
- (void)apply_main {
    NSLog(@"begin:%@", [NSThread currentThread]);
    dispatch_apply(5, dispatch_get_main_queue(), ^(size_t index) {
        NSLog(@"%zd:%@", index, [NSThread currentThread]);
    });
    NSLog(@"end:%@", [NSThread currentThread]);
}

- (void)apply_serial {
    dispatch_queue_t queue = dispatch_queue_create("serial", NULL);
    NSLog(@"begin:%@", [NSThread currentThread]);
    dispatch_apply(5, queue, ^(size_t index) {
        NSLog(@"%zd:%@", index, [NSThread currentThread]);
    });
    NSLog(@"end:%@", [NSThread currentThread]);
}

// 开启多个线程
- (void)apply_global {
    NSLog(@"begin:%@", [NSThread currentThread]);
    dispatch_apply(5, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"%zd:%@", index, [NSThread currentThread]);
    });
    NSLog(@"end:%@", [NSThread currentThread]);
}

#pragma mark - dispatch_group

// dispatch_group_notify
- (void)groupNotify {
    NSLog(@"begin:%@", [NSThread currentThread]);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1:%@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2:%@", [NSThread currentThread]);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"3:%@", [NSThread currentThread]);
    });
    
    NSLog(@"end:%@", [NSThread currentThread]);
}

// dispatch_group_wait
- (void)groupWait {
    NSLog(@"begin:%@", [NSThread currentThread]);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1:%@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2:%@", [NSThread currentThread]);
    });
    
    NSLog(@"3");
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"end");
}

/*
 dispatch_group_enter、dispatch_group_leave
 - dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数 +1
 - dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数 -1
 - 当 group 中未执行完毕任务数为0的时候，才会使 dispatch_group_wait 解除阻塞，以及执行追加到 dispatch_group_notify 中的任务
 */
- (void)groupEnterAndLeave {
    NSLog(@"begin");
    
    dispatch_group_t group = dispatch_group_create();
    // 执行任务+1
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1:%@", [NSThread currentThread]);
        // 执行任务-1
        dispatch_group_leave(group);
    });
    // 执行任务+1
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2:%@", [NSThread currentThread]);
        // 执行任务-1
        dispatch_group_leave(group);
    });
    
    NSLog(@"3");
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"end");
}

#pragma mark - dispatch_semaphore

/*
 dispatch_semaphore_create：创建一个 Semaphore 并初始化信号的总量
 dispatch_semaphore_signal：发送一个信号，让信号总量加 1
 dispatch_semaphore_wait：可以使总信号量减 1，信号总量小于 0 时就会一直等待（阻塞所在线程），否则就可以正常执行
 */

- (void)semaphoreSync {
    NSLog(@"begin");
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1:%@", [NSThread currentThread]);
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    NSLog(@"2");
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    NSLog(@"number = %d", number);
}

- (void)semaphoreSafe {
    self.semaphore = dispatch_semaphore_create(1);
    
    self.ticketCount = 50;
    
    dispatch_queue_t queue1 = dispatch_queue_create("serial_queue1", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("serial_queue1", NULL);
    
    __weak typeof(self) wself = self;
    dispatch_async(queue1, ^{
        [wself saleTick];
    });
    
    dispatch_async(queue2, ^{
        [wself saleTick];
    });
}

- (void)saleTick {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else {
            NSLog(@"所有火车票均已售完");
            // 相当于解锁
            dispatch_semaphore_signal(self.semaphore);
            break;
        }
        // 相当于解锁
        dispatch_semaphore_signal(self.semaphore);
    }
}

@end

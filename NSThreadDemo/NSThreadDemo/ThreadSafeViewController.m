//
//  ThreadSafeViewController.m
//  NSThreadDemo
//
//  Created by 张延深 on 2019/11/20.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ThreadSafeViewController.h"

@interface Account ()

@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation Account

- (instancetype)init {
    if (self = [super init]) {
        self.lock = [NSLock new];
    }
    return self;
}

- (void)drawAmount:(CGFloat)amount {
    // 第一种方式
//    @synchronized (self) {
//        if (self.balance >= amount) {
//            NSLog(@"%@ 取钱成功！吐出钞票：%lf", [NSThread currentThread].name, amount);
//            self.balance -= amount;
//            NSLog(@"余额为：%lf", self.balance);
//        } else {
//            NSLog(@"%@ 取钱失败！余额不足！", [NSThread currentThread].name);
//        }
//    }
    // 第二种方式
    [self.lock lock];
    if (self.balance >= amount) {
        NSLog(@"%@ 取钱成功！吐出钞票：%lf", [NSThread currentThread].name, amount);
        self.balance -= amount;
        NSLog(@"余额为：%lf", self.balance);
    } else {
        NSLog(@"%@ 取钱失败！余额不足！", [NSThread currentThread].name);
    }
    [self.lock unlock];
}

@end

@interface ThreadSafeViewController ()

@property (nonatomic, strong) Account *account;

@end

@implementation ThreadSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线程安全";
    self.account = [Account new];
    self.account.balance = 1000;
    [self initThread];
}

#pragma mark - Event response

- (void)drawAmount:(NSNumber *)amount {
    [self.account drawAmount:[amount floatValue]];
}

#pragma mark - Private methods

- (void)initThread {
    NSThread *thread1 = [self createThreadWithName:@"甲" selector:@selector(drawAmount:)];
    NSThread *thread2 = [self createThreadWithName:@"乙" selector:@selector(drawAmount:)];
    [thread1 start];
    [thread2 start];
}

- (NSThread *)createThreadWithName:(NSString *)name selector:(SEL)selector {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:selector object:@800.0];
    thread.name = name;
    return thread;
}

@end

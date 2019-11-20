//
//  ConditionViewController.m
//  NSThreadDemo
//
//  Created by 张延深 on 2019/11/20.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ConditionViewController.h"

@interface Account1 ()

@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, assign) BOOL flag;

@end

@implementation Account1

- (instancetype)init {
    if (self = [super init]) {
        self.flag = YES; // flag为YES时可以取钱，为NO时可以存钱
        self.condition = [[NSCondition alloc] init];
    }
    return self;
}

// 取钱
- (void)drawAmount:(CGFloat)amount {
    [self.condition lock];
    if (!self.flag) {
        [self.condition wait];
    } else {
        NSLog(@"%@ 取钱成功！吐出钞票：%lf", [NSThread currentThread].name, amount);
        [NSThread sleepForTimeInterval:0.001];
        self.balance -= amount;
        NSLog(@"余额：%lf", self.balance);
        self.flag = NO;
        // 唤醒其他线程
        [self.condition broadcast];
    }
    [self.condition unlock];
}

// 存钱
- (void)depositAmount:(CGFloat)amount {
    [self.condition lock];
    if (self.flag) {
        [self.condition wait];
    } else {
        NSLog(@"%@ 存款：%lf", [NSThread currentThread].name, amount);
        self.balance += amount;
        NSLog(@"账户余额为：%lf", self.balance);
        self.flag = YES;
        [self.condition broadcast];
    }
    [self.condition unlock];
}

@end

@interface ConditionViewController ()

@property (nonatomic, strong) Account1 *account;

@end

@implementation ConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.account = [[Account1 alloc] init];
    self.account.balance = 1000;
    // 创建3个存钱者线程
    [NSThread detachNewThreadSelector:@selector(depositAmount:) toTarget:self withObject:@800];
    [NSThread detachNewThreadSelector:@selector(depositAmount:) toTarget:self withObject:@800];
    [NSThread detachNewThreadSelector:@selector(depositAmount:) toTarget:self withObject:@800];
    // 创建1个取钱者线程
    [NSThread detachNewThreadSelector:@selector(drawAmount:) toTarget:self withObject:@800];
}

- (void)depositAmount:(NSNumber *)amount {
    [NSThread currentThread].name = @"B";
    for (int i = 0; i < 100; i++) {
        [self.account depositAmount:[amount floatValue]];
    }
}

- (void)drawAmount:(NSNumber *)amount {
    [NSThread currentThread].name = @"A";
    for (int i = 0; i < 100; i++) {
        [self.account drawAmount:[amount floatValue]];
    }
}

@end

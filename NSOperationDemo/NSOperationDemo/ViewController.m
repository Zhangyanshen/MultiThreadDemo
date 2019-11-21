//
//  ViewController.m
//  NSOperationDemo
//
//  Created by 张延深 on 2019/11/21.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "ViewController.h"
#import "YSOperation.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (nonatomic, assign) NSInteger ticketCount;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self useInvocationOperation];
//    [self useBlockOperation];
//    [self useBlockOperationAddExecutionBlock];
//    [self useCustomOperation];
//    [self addOperationToQueue];
//    [self addOperationWithBlockToQueue];
//    [self setMaxConcurrentOperationCount];
//    [self addDependency];
    [self initTicketStatus];
}

#pragma mark - NSBlockOperation

/*
 如果一个NSBlockOperation对象封装了多个操作。NSBlockOperation是否开启新线程，取决于操作的个数。如果添加的操作的个数多，就会自动开启新线程。当然开启的线程数是由系统来决定的。
 */

- (void)useBlockOperation {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@:%d", [NSThread currentThread], i);
        }
    }];
    [op start];
}

- (void)useBlockOperationAddExecutionBlock {
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1:%@", [NSThread currentThread]);
        }
    }];
    
    // 2.添加额外操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2:%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3:%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4:%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"5:%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"6:%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"7:%@", [NSThread currentThread]);
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"8:%@", [NSThread currentThread]);
        }
    }];
    
    // 3.执行操作
    [op start];
}

#pragma mark - NSInvocationOperation

// 不使用NSOperationQueue，直接在主线程使用NSOperation时，不开启新线程，在主线程同步执行
- (void)useInvocationOperation {
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [op start];
}

#pragma mark - 自定义NSOperation

// 在没有使用 NSOperationQueue、在主线程单独使用自定义继承自 NSOperation 的子类的情况下，是在主线程执行操作，并没有开启新线程。
- (void)useCustomOperation {
    YSOperation *op = [[YSOperation alloc] init];
    [op start];
}

#pragma mark - 操作队列

- (void)addOperationToQueue {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建操作
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3) object:nil];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3:%@", [NSThread currentThread]);
        }
    }];
    YSOperation *op4 = [YSOperation new];
    
    // 3.添加操作到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
}

- (void)addOperationWithBlockToQueue {
    // 1.创建队列
    NSOperationQueue *queue = [NSOperationQueue new];
    
    // 2.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1:%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2:%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3:%@", [NSThread currentThread]);
        }
    }];
}

#pragma mark - 最大并发数maxConcurrentOperationCount

/*
 maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行
 - 默认情况下为-1，表示不进行限制，可进行并发执行
 - 为1时，队列为串行队列，只能串行执行
 - 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}
 */
- (void)setMaxConcurrentOperationCount {
    // 1.创建队列
    NSOperationQueue *queue = [NSOperationQueue new];
    // 2.设置最大并发数
//    queue.maxConcurrentOperationCount = 1; // 串行队列
//    queue.maxConcurrentOperationCount = 2; // 并发队列
    queue.maxConcurrentOperationCount = 8; // 并发队列
    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1:%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2:%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3:%@", [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4:%@", [NSThread currentThread]);
        }
    }];
}

#pragma mark - 操作依赖

/*
 NSOperation、NSOperationQueue 最吸引人的地方是它能添加操作之间的依赖关系。通过操作依赖，我们可以很方便的控制操作之间的执行先后顺序
 - - (void)addDependency:(NSOperation *)op; 添加依赖，使当前操作依赖于操作 op 的完成
 - - (void)removeDependency:(NSOperation *)op; 移除依赖，取消当前操作对操作 op 的依赖
 - @property (readonly, copy) NSArray<NSOperation *> *dependencies; 在当前操作开始执行之前完成执行的所有操作对象数组
 */
- (void)addDependency {
    // 1.创建队列
    NSOperationQueue *queue = [NSOperationQueue new];
    
    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1:%@", [NSThread currentThread]);
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2:%@", [NSThread currentThread]);
        }
    }];
    
    // 3.添加依赖
    [op1 addDependency:op2];
    
    // 4.添加操作到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
}

#pragma mark - 操作优先级

/*
 NSOperation提供了queuePriority（优先级）属性，queuePriority属性适用于同一操作队列中的操作，不适用于不同操作队列中的操作。默认情况下，所有新创建的操作对象优先级都是NSOperationQueuePriorityNormal。但是我们可以通过setQueuePriority:方法来改变当前操作在同一队列中的执行优先级
 优先级不能取代依赖关系。如果要控制操作间的启动顺序，则必须使用依赖关系
 */

#pragma mark - 线程通信

- (IBAction)downloadImage:(UIButton *)sender {
    sender.enabled = NO;
    [self.indicatorView startAnimating];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574334895868&di=5a171e564bfbca1fa57587f4c8ea0921&imgtype=0&src=http%3A%2F%2Fimg.sccnn.com%2Fbimg%2F326%2F203.jpg"];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            // 回到主队列
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.imgView.image = image;
                sender.enabled = YES;
                [self.indicatorView stopAnimating];
            }];
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                sender.enabled = YES;
                [self.indicatorView stopAnimating];
            }];
        }
    }];
}

#pragma mark - 线程同步和线程安全

- (void)initTicketStatus {
    self.ticketCount = 50;
    self.lock = [NSLock new];
    
    // 1.创建queue1
    NSOperationQueue *queue1 = [NSOperationQueue new];
    queue1.name = @"北京";
    queue1.maxConcurrentOperationCount = 1;
    
    // 2.创建queue2
    NSOperationQueue *queue2 = [NSOperationQueue new];
    queue2.name = @"上海";
    queue2.maxConcurrentOperationCount = 1;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicket];
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicket];
    }];
    
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

- (void)saleTicket {
    while (1) {
        // 加锁
        [self.lock lock];
        
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"剩余票数：%ld 窗口：%@", self.ticketCount, [NSOperationQueue currentQueue]);
            [NSThread sleepForTimeInterval:1];
        }
        // 解锁
        [self.lock unlock];
        
        if (self.ticketCount <= 0) {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

#pragma mark - Event response

- (void)task1 {
    for (int i = 0; i < 5; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%@:%d", [NSThread currentThread], i);
    }
}

- (void)task2 {
    for (int i = 0; i < 5; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1:%@", [NSThread currentThread]);
    }
}

- (void)task3 {
    for (int i = 0; i < 5; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"2:%@", [NSThread currentThread]);
    }
}

@end

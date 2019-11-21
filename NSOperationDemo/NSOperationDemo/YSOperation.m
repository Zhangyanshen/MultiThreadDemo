//
//  YSOperation.m
//  NSOperationDemo
//
//  Created by 张延深 on 2019/11/21.
//  Copyright © 2019 张延深. All rights reserved.
//

#import "YSOperation.h"

@implementation YSOperation

- (void)main {
    if (self.isCancelled) {
        return;
    }
    for (int i = 0; i < 5; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%@:%d", [NSThread currentThread], i);
    }
}

@end

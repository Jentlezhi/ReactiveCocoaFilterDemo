//
//  ViewController.m
//  ReactiveCocoaFilterDemo
//
//  Created by Jentle on 16/9/8.
//  Copyright © 2016年 Jentle. All rights reserved.
//


#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self filter];
//    [self ignore];
//    [self take];
//    [self takeLast];
//    [self takeUntil];
//    [self distinctUntilChanged];
    [self skip];

}
/**
 *  过滤：每次信号发出，会先执行过滤条件判断。
 */
- (void)filter{
    [[_inputTextField.rac_textSignal filter:^BOOL(id value) {
        return [value length]>6;
    }] subscribeNext:^(id x) {
        _textLabel.text = x;
        NSLog(@"%@",x);
    }];
}
/**
 *  忽略：忽略某些值的信号。
 */
- (void)ignore{
    
    RACSignal *ignoreSignal = [_inputTextField.rac_textSignal ignore:@"1"];
    [ignoreSignal subscribeNext:^(id x) {
        _textLabel.text = x;
    }];
    
}
/**
 *  take:从开始一共取N次的信号，取前面几个信号。
 */
- (void)take{
    RACSubject *subject = [RACSubject subject];
    [[subject take:4] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendNext:@"4"];
    [subject sendNext:@"5"];
}
/**
 *  takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
 */
- (void)takeLast{
    RACSubject *signal = [RACSubject subject];
    [[signal takeLast:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [signal sendNext:@"1"];
    [signal sendNext:@"2"];
    [signal sendNext:@"3"];
    [signal sendNext:@"4"];
    [signal sendNext:@"5"];
    [signal sendCompleted];
}

/**
 *  takeUntil:获取信号直到执行完这个信号。
 */
- (void)takeUntil{
    RACSubject *signal = [RACSubject subject];
    RACSubject *untilSignal = [RACSubject subject];
    [[signal takeUntil:untilSignal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [signal sendNext:@"1"];
    [signal sendNext:@"2"];
    [signal sendNext:@"3"];
    [untilSignal sendNext:@"xxx"];
    //或者发送完成
//    [untilSignal sendCompleted];
    [signal sendNext:@"4"];
    [signal sendNext:@"5"];

}

/**
 *  distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
 */
- (void)distinctUntilChanged{
    RACSubject *signal = [RACSubject subject];
    [[signal distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [signal sendNext:@"1"];
    [signal sendNext:@"1"];
    [signal sendNext:@"2"];
    [signal sendNext:@"2"];
    [signal sendNext:@"1"];
    
}

/**
 *  `skip`:(NSUInteger):跳过几个信号,不接受。
 */
- (void)skip{
    RACSubject *subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendNext:@"4"];
    [subject sendNext:@"5"];
    
}


@end

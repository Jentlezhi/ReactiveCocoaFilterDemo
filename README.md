ReactiveCocoa高级用法之过滤。

    * `filter`:过滤信号，使用它可以获取满足条件的信号.

    ```
    // 过滤:
    // 每次信号发出，会先执行过滤条件判断.
    [_textField.rac_textSignal filter:^BOOL(NSString *value) {
            return value.length > 3;
    }];
    ```

    * `ignore`:忽略完某些值的信号.

    ```
        // 内部调用filter过滤，忽略掉ignore的值
    [[_textField.rac_textSignal ignore:@"1"] subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];

    ```

    * `distinctUntilChanged`:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。

    ```
        // 过滤，当上一次和当前的值不一样，就会发出内容。
    // 在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    [[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];

    ```

    * `take`:从开始一共取N次的信号

    ```
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];

    // 2、处理信号，订阅信号
    [[signal take:1] subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];

    // 3.发送信号
    [signal sendNext:@1];

    [signal sendNext:@2];
    ```

    * `takeLast`:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.

    ```
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];

    // 2、处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];

    // 3.发送信号
    [signal sendNext:@1];

    [signal sendNext:@2];

    [signal sendCompleted];
    ```

    * `takeUntil`:(RACSignal *):获取信号直到执行完这个信号

    ```
    // 监听文本框的改变，知道当前对象被销毁
    [_textField.rac_textSignal takeUntil:self.rac_willDeallocSignal];

    ```


* `skip`:(NSUInteger):跳过几个信号,不接受。

    ```
    // 表示输入第一次，不会被监听到，跳过第一次发出的信号
    [[_textField.rac_textSignal skip:1] subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];
    ```

    * `switchToLatest`:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。

    ```
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];

    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];

    ```

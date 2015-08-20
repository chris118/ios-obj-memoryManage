//
//  ViewController.m
//  ARCLearning
//
//  Created by 王晓鹏 on 15/8/18.
//  Copyright (c) 2015年 xiaopeng. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self Test1];
    
    [self Test2];
    
    [self Test3];
}


// release 基础
-(void)Test1{

    Person* p = [[Person alloc] init];
    p.name = @"Jack";
    
    NSLog(@"name: %@", p.name); // Jack
    NSLog(@"retainCount:  %lu", p.retainCount); // 1
    
    [p retain];
    NSLog(@"retainCount:  %lu", p.retainCount); // 2
    
    [p release];
     NSLog(@"retainCount:  %lu", p.retainCount); //1
    
    [p release]; //"person dealloc invoke"
    
    // 1 这个时候打印count还是1， 不能用retainCount来作为参考，官方文档有介绍
    // 在做测试的时候我们只需要监控 person的dealloc就可以了 调用到dealloc 说明对象已经释放掉了
    NSLog(@"retainCount:  %lu", p.retainCount);
    // NSLog(@"name: %@", p.name); // EXC_BAD_ACCESS 程序崩溃 野指针：这个时候p指针还是有内存地址， 但是指向的内容已经无效了
    
    p = nil;
    NSLog(@"retainCount:  %lu", p.retainCount); // 0
    
    NSLog(@"name: %@", p.name); // 不会崩溃
}

//http://segmentfault.com/q/1010000000123664
//可以看到，每个runloop中都创建一个Autorelease Pool，并在runloop的末尾进行释放，
//所以，一般情况下，每个接受autorelease消息的对象，都会在下个runloop开始前被释放。
//也就是说，在一段同步的代码中执行过程中，生成的对象接受autorelease消息后，一般是不会在代码段执行完成前释放的。
-(void)Test2{
    
    Person* p = nil;
    
    {
        p = [[[Person alloc] init] autorelease];
         NSLog(@"retainCount:  %lu", p.retainCount); // 1
    }
    //出了作用域 Person dealloc没有被调用 说明这个runloop还没有结束 所以P没有被释放
    // 后面会在runloop结束后释放
}

//用线程池手动让 autorelease对象释放掉 而不是等着Runloop结束后释放掉
-(void)Test3{

    Person* p = nil;
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
        p = [[[Person alloc] init] autorelease];
        NSLog(@"retainCount:  %lu", p.retainCount); // 1
    }
    
    [pool drain]; // Person dealloc调用
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

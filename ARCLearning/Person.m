//
//  Person.m
//  ARCLearning
//
//  Created by 王晓鹏 on 15/8/18.
//  Copyright (c) 2015年 xiaopeng. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize name = _name;

-(void)dealloc{
    NSLog(@"person dealloc invoke");
    [super dealloc];
}

@end

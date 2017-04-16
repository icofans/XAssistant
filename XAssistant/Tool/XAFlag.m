//
//  XAFlag.m
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAFlag.h"

@implementation XAFlag

+ (instancetype)shareInstance
{
    static XAFlag *flag = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flag = [[XAFlag alloc] init];
    });
    return flag;
}

@end

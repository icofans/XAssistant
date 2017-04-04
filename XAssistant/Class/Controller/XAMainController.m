//
//  XAMainController.m
//  XAssistant
//
//  Created by 王家强 on 17/3/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAMainController.h"

@interface XAMainController ()

@end

@implementation XAMainController

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // 设置程序窗口初始化宽度
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    CGRect frame = window.frame;
    frame.size.width = 350;
    [window setFrame:frame display:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    

}

@end

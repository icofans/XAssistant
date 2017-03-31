//
//  XAWindowController.m
//  XAssistant
//
//  Created by 王家强 on 17/3/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAWindowController.h"

@interface XAWindowController ()

@end

@implementation XAWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // 设置titlebar为透明
    self.window.titlebarAppearsTransparent = YES;
    // 隐藏title
    self.window.titleVisibility = NSWindowTitleHidden;
    // 隐藏最大化按钮
    [self.window standardWindowButton:NSWindowZoomButton].hidden = YES;
}

@end

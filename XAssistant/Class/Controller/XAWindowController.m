//
//  XAWindowController.m
//  XAssistant
//
//  Created by 王家强 on 17/3/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAWindowController.h"
#import "WAYWindow.h"

@interface XAWindowController ()

//@property (weak) IBOutlet WAYWindow *window;

@end

@implementation XAWindowController

//@dynamic window;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // 设置titlebar为透明
    self.window.titlebarAppearsTransparent = YES;
    // 隐藏title
    self.window.titleVisibility = NSWindowTitleHidden;
    // 隐藏最大化按钮
    [self.window standardWindowButton:NSWindowZoomButton].hidden = YES;
    
    // [self.window setBackgroundColor:[NSColor redColor]];
    
    [self.window performSelector:@selector(setVibrantLightAppearance)];
    [self.window performSelector:@selector(setContentViewAppearanceVibrantDark)];
    
//    [self.window setVibrantDarkAppearance];
//    [self.window setContentViewAppearanceVibrantDark];
}

@end

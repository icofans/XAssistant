//
//  XAMainController.m
//  XAssistant
//
//  Created by 王家强 on 17/3/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAMainController.h"
#import "XAMainView.h"
#import "XAPgyView.h"
#import "CALayer+XAAnimation.h"

@interface XAMainController ()

/** 
 拖拽文件检测View
 */
@property (nonatomic,strong) XAMainView *mainView;

/**
 蒲公英
 */
@property (nonatomic,strong) XAPgyView *pgyView;


@end

@implementation XAMainController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置程序窗口初始化宽度
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    CGRect frame = window.frame;
    frame.size.width = 350;
    [window setFrame:frame display:YES];
    
    [self creatMainView];
    
}

- (void)creatMainView
{
    self.mainView = [[XAMainView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 350, 350))];
    [self.view addSubview:self.mainView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end

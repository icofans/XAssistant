//
//  XAMainController.m
//  XAssistant
//
//  Created by 王家强 on 17/3/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAMainController.h"
#import "PPDragDropView.h"

@interface XAMainController ()<PPDragDropViewDelegate>

/** 
 拖拽文件检测View
 */
@property (weak) IBOutlet PPDragDropView *dragDropView;

@property (weak) IBOutlet NSImageView *placeholderImageView;
@property (weak) IBOutlet NSTextField *placeholderTitle;

/** 
 底部状态
 */
@property (weak) IBOutlet NSTextField *hudTitle;

@end

@implementation XAMainController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置拖拽文件代理
    self.dragDropView.delegate = self;
    
    // 设置程序窗口初始化宽度
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    CGRect frame = window.frame;
    frame.size.width = 350;
    [window setFrame:frame display:YES];
}

#pragma mark - PPDragDropViewDelegate 获取文件路径数据源数组
- (void)dragDropFilePathList:(NSArray<NSString *> *)filePathList
{
    // 获取拖拽文件路径数据源
    for (NSString *filePath in filePathList) {
        NSLog(@"------%@",filePath);
        // 1.检查路径是否为文件夹
        if (![self checkIsFolder:filePath]) {
            self.hudTitle.stringValue = @"拖入的不是文件夹，请重试";
            return;
        }
        // 2.隐藏拖拽提示界面
        [self setPlaceholderViewHidden:filePathList.count>0];
        
        // 3.检查文件夹是否包含xcworkspace或者xcodeproj文件、如果包含，分开处理
    }
}

- (BOOL)checkIsFolder:(NSString *)filePath
{
    BOOL isFolder = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isFolder];
    return isFolder;
}


#pragma mark - PlacehelderView
- (void)setPlaceholderViewHidden:(BOOL)hidden {
    self.hudTitle.stringValue = @"正在检测";
    self.placeholderTitle.hidden = hidden;
    self.placeholderImageView.hidden = hidden;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    

}

@end

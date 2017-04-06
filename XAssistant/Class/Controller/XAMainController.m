//
//  XAMainController.m
//  XAssistant
//
//  Created by 王家强 on 17/3/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAMainController.h"
#import "PPDragDropView.h"
#import "XATaskTool.h"
#import "XAGifView.h"

@interface XAMainController ()<PPDragDropViewDelegate>

/** 
 拖拽文件检测View
 */
@property (weak) IBOutlet PPDragDropView *dragDropView;

/**
 提示图
 */
@property (weak) IBOutlet NSImageView *placeholderImageView;

/**
 描述
 */
@property (weak) IBOutlet NSTextField *placeholderTitle;

/** 
 底部状态
 */
@property (weak) IBOutlet NSTextField *hudTitle;

/**
 加载视图
 */
@property (strong) IBOutlet XAGifView *gifView;

@property (strong) IBOutlet NSTextField *completeTitle;

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
    
    self.gifView.hidden = YES;
}

#pragma mark - PPDragDropViewDelegate 获取文件路径数据源数组
- (void)dragDropFilePathList:(NSArray<NSString *> *)filePathList
{
    // 获取拖拽文件路径数据源
    for (NSString *filePath in filePathList) {
        NSLog(@"------%@",filePath);
        // 1.检查路径是否为文件夹
        if (![self checkIsFolder:filePath]) {
            self.hudTitle.stringValue = @"拖入的不是文件夹或文件路径不存在，请重试";
            return;
        }
        
        // 2.检查文件夹是否包含xcworkspace或者xcodeproj文件、如果包含，分开处理
        NSArray *subFileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
        
        XAProjectType projectType = PROJECT_UNKNOWN;
        NSString *projectName = @"";
        for (NSString *subFileName in subFileArray) {
            // 获取文件完整路径
            NSString *subFilePath = [NSString stringWithFormat:@"%@/%@", filePath,subFileName];
            // 判断文件的拓展名
            NSString *extension = [[subFilePath pathExtension] lowercaseString];
            if ([extension isEqualToString:@"xcworkspace"]) {
                projectType = PROJECT_WORKSPACE;
                projectName = [subFileName componentsSeparatedByString:@"."].firstObject;
            } else if ([extension isEqualToString:@"xcodeproj"]) {
                projectType = PROJECT_NORMAL;
                projectName = [subFileName componentsSeparatedByString:@"."].firstObject;
            }
        }
        // 3.根据获取到的文件结构类型处理
        if (projectType == PROJECT_UNKNOWN) {
            self.hudTitle.stringValue = @"请拖入项目文件夹再试";
            return;
        }
        
        // 隐藏拖拽提示界面
        self.hudTitle.stringValue = @"正在打包";
        [self setPlaceholderViewHidden:YES];
        
        
        // 此部分比较耗时，做成异步
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            typeof(self) __weak copy_self = self;
            [XATaskTool executeWithPath:filePath type:projectType name:projectName cmd:CMD_CLEAN completion:^(NSString *outputString) {
                NSLog(@"----%@",outputString);
                dispatch_async(dispatch_get_main_queue(), ^{
                    copy_self.hudTitle.stringValue = @"清理完成";
                });
            }];
            [XATaskTool executeWithPath:filePath type:projectType name:projectName cmd:CMD_BUILD completion:^(NSString *outputString) {
                NSLog(@"----%@",outputString);
                dispatch_async(dispatch_get_main_queue(), ^{
                    copy_self.hudTitle.stringValue = @"编译完成";
                });
            }];
            [XATaskTool executeWithPath:filePath type:projectType name:projectName cmd:CMD_ARCHIVE completion:^(NSString *outputString) {
                NSLog(@"----%@",outputString);
                dispatch_async(dispatch_get_main_queue(), ^{
                    copy_self.hudTitle.stringValue = @"打包完成";
                    [copy_self loadDone];
                });
            }];
            [XATaskTool executeWithPath:filePath type:projectType name:projectName cmd:CMD_OPEN completion:^(NSString *outputString) {
                NSLog(@"----%@",outputString);
            }];

        });
    }
}


#pragma mark 加载完成
- (void)loadDone
{
    [self.gifView setGifImage:nil];
    self.completeTitle.hidden = NO;
}

#pragma mark 加载动画
- (void)showAnimation
{
    NSImage *image = [NSImage imageNamed:@"load.gif"];
    [self.gifView setWantsLayer:YES];
    [self.gifView setGifImage:image];
}

#pragma mark 检查文件夹
- (BOOL)checkIsFolder:(NSString *)filePath
{
    BOOL isFolder = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isFolder];
    return isFolder;
}

#pragma mark - PlacehelderView
- (void)setPlaceholderViewHidden:(BOOL)hidden {
    self.placeholderTitle.hidden = hidden;
    self.placeholderImageView.hidden = hidden;
    
    self.gifView.hidden = NO;
    self.completeTitle.hidden = YES;
    [self showAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    

}

@end

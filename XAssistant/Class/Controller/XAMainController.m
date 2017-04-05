//
//  XAMainController.m
//  XAssistant
//
//  Created by 王家强 on 17/3/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAMainController.h"
#import "PPDragDropView.h"

typedef NS_OPTIONS(NSUInteger, XAProjectType) {
    PROJECT_UNKNOWN     = 0, // 未知
    PROJECT_NORMAL      = 1, // 普通项目
    PROJECT_WORKSPACE   = 2, // 工作空间类项目
};

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
            self.hudTitle.stringValue = @"拖入的不是文件夹或文件路径不存在，请重试";
            return;
        }
        
        // 2.检查文件夹是否包含xcworkspace或者xcodeproj文件、如果包含，分开处理
        NSArray *subFileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
        
        XAProjectType projectType = PROJECT_UNKNOWN;
        for (NSString *subFileName in subFileArray) {
            // 获取文件完整路径
            NSString *subFilePath = [NSString stringWithFormat:@"%@/%@", filePath,subFileName];
            // 判断文件的拓展名
            NSString *extension = [[subFilePath pathExtension] lowercaseString];
            if ([extension isEqualToString:@"xcworkspace"]) {
                projectType = PROJECT_WORKSPACE;
            } else if ([extension isEqualToString:@"xcodeproj"]) {
                projectType = PROJECT_NORMAL;
            }
        }
        // 3.根据获取到的文件结构类型处理
        if (projectType == PROJECT_UNKNOWN) {
            self.hudTitle.stringValue = @"请拖入项目文件夹再试";
            return;
        }
        
        // 隐藏拖拽提示界面
        [self setPlaceholderViewHidden:filePathList.count>0];
        
        if (projectType == PROJECT_NORMAL) {
            
        }
        if (projectType == PROJECT_WORKSPACE) {
            
        }
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

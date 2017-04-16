//
//  XADragDropView.m
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAMainView.h"
#import "XADragView.h"
#import "XATaskTool.h"
#import "XALabel.h"
#import "CALayer+XAAnimation.h"
#import "NSImageView+XAAnimation.h"
#import "XAPgyView.h"

@interface XAMainView ()<XADragViewDelegate>

/** 标题 */
@property(nonatomic,strong) XALabel *titleLabel;

/** 默认文件夹图 */
@property(nonatomic,strong) NSImageView *imageView;

/** 提示文字 */
@property(nonatomic,strong) XALabel *hudLabel;

/** 拖拽视图 */
@property(nonatomic,strong) XADragView *dragDropView;

/** GIF图 */
@property(nonatomic,strong) NSImageView *gifView;

/** 底部状态 */
@property (nonatomic,strong) XALabel *stateLabel;

/** 完成Label */
@property(nonatomic,strong) XALabel *completeLabel;

/** 上传Label */
@property(nonatomic,strong) XALabel *uploadLabel;

/** 蒲公英 */
@property(nonatomic,strong) NSButton *pgyBtn;

/** 蘑菇 */
@property(nonatomic,strong) NSButton *mgBtn;

/** 蘑菇 */
@property(nonatomic,strong) NSButton *otherBtn1;

/** 蘑菇 */
@property(nonatomic,strong) NSButton *otherBtn2;

@property(nonatomic,strong) XAPgyView *pgyView;

@end

@implementation XAMainView

// 初始化
- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    // titleBar
    self.titleLabel = [[XALabel alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 290, self.frame.size.width, 30))];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = XATextAlignmentCenter;
    self.titleLabel.text = @"打包助手";
    self.titleLabel.textColor = [NSColor whiteColor];
    self.titleLabel.fontSize = 17;
    self.titleLabel.fontName = [NSFont boldSystemFontOfSize:10.0].fontName;
    
    [self setupDragView];
    [self setupCompleteView];
}

#pragma mark dragView
- (void)setupDragView
{
    CGFloat imgW = 130;
    CGRect imgRect = CGRectMake((self.frame.size.width-imgW)/2, (self.frame.size.height-imgW)/2+20, imgW, imgW);
    self.imageView = [[NSImageView alloc] initWithFrame:NSRectFromCGRect(imgRect)];
    [self addSubview:self.imageView];
    self.imageView.image = [NSImage imageNamed:@"img_folder_n"];
    
    NSRect tfRect = NSRectFromCGRect(CGRectMake(0, (self.frame.size.height-imgW)/2-10, 350, 20));
    self.hudLabel = [[XALabel alloc] initWithFrame:tfRect];
    [self addSubview:self.hudLabel];
    self.hudLabel.textAlignment = XATextAlignmentCenter;
    self.hudLabel.text = @"拖拽项目文件夹至此";
    self.hudLabel.textColor = [NSColor whiteColor];
    self.hudLabel.fontSize = 16;
    
    self.gifView = [[NSImageView alloc] initWithFrame:NSRectFromCGRect(CGRectMake((self.frame.size.width-142)/2, (self.frame.size.height-123)/2+23, 142, 123))];
    [self addSubview:self.gifView];
    self.gifView.hidden = YES;
    
    self.dragDropView = [[XADragView alloc] initWithFrame:self.frame];
    [self addSubview:self.dragDropView];
    
    self.stateLabel = [[XALabel alloc] initWithFrame:NSRectToCGRect(CGRectMake(8, 0, 330, 20))];
    [self.dragDropView addSubview:self.stateLabel];
    self.stateLabel.textColor = [NSColor whiteColor];
    self.stateLabel.fontSize = 13;
    self.stateLabel.text = @"准备就绪";
    // 设置拖拽文件代理
    self.dragDropView.delegate = self;
}

#pragma mark completeView
- (void)setupCompleteView
{
    // 完成
    self.completeLabel = [[XALabel alloc] initWithFrame:NSRectToCGRect(CGRectMake(0, 220, self.frame.size.width, 20))];
    [self addSubview:self.completeLabel];
    self.completeLabel.textColor = [NSColor whiteColor];
    self.completeLabel.fontName = [NSFont boldSystemFontOfSize:10].fontName;
    self.completeLabel.textAlignment = XATextAlignmentCenter;
    
    self.uploadLabel = [[XALabel alloc] initWithFrame:NSRectToCGRect(CGRectMake(40, 160, 100, 20))];
    [self addSubview:self.uploadLabel];
    self.uploadLabel.textColor = [NSColor whiteColor];
    self.uploadLabel.fontSize = 15;
    self.uploadLabel.textAlignment = XATextAlignmentLeft;

    // 第三方平台
    CGFloat margin = (350-80-50*4)/3;
    self.pgyBtn = [[NSButton alloc] initWithFrame:NSRectToCGRect(CGRectMake(40, 100, 50, 50))];
    [self.pgyBtn setBordered:NO];
    [self addSubview:self.pgyBtn];
    self.pgyBtn.hidden = YES;
    self.mgBtn = [[NSButton alloc] initWithFrame:NSRectToCGRect(CGRectMake(40+(50+margin), 100, 50, 50))];
    [self.mgBtn setBordered:NO];
    [self addSubview:self.mgBtn];
    self.mgBtn.hidden = YES;
    self.otherBtn1 = [[NSButton alloc] initWithFrame:NSRectToCGRect(CGRectMake(40+(50+margin)*2, 100, 50, 50))];
    [self.otherBtn1 setBordered:NO];
    [self addSubview:self.otherBtn1];
    self.otherBtn1.hidden = YES;
    self.otherBtn2 = [[NSButton alloc] initWithFrame:NSRectToCGRect(CGRectMake(40+(50+margin)*3, 100, 50, 50))];
    [self.otherBtn2 setBordered:NO];
    [self addSubview:self.otherBtn2];
    self.otherBtn2.hidden = YES;
    
    // 添加事件
    [self.pgyBtn setTarget:self];
    [self.pgyBtn setAction:@selector(buttonClick:)];
    [self.mgBtn setTarget:self];
    [self.mgBtn setAction:@selector(buttonClick:)];
    [self.otherBtn1 setTarget:self];
    [self.otherBtn1 setAction:@selector(buttonClick:)];
    [self.otherBtn2 setTarget:self];
    [self.otherBtn2 setAction:@selector(buttonClick:)];
}

#pragma mrk 点击事件
- (void)buttonClick:(NSButton *)sender
{
    [self.layer rippleEffect:^{
        [self.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
    }];
    [self topgyView];
}

#pragma mark 蒲公英视图
- (void)topgyView
{
    typeof(self) __weak weakSelf = self;
    [self.layer addAnimationWithType:kCATransitionPush subType:kCATransitionFromBottom animation:^{
        weakSelf.pgyView = [[XAPgyView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 350, 350))];
        [weakSelf addSubview:weakSelf.pgyView];
    }];
    
}

- (void)draggingDidEntered:(BOOL)isVisble
{
    if (isVisble) {
        self.imageView.image = [NSImage imageNamed:@"img_folder_h"];
        self.hudLabel.text = @"松开完成";
    }
}

- (void)draggingDidExited
{
    self.imageView.image = [NSImage imageNamed:@"img_folder_n"];
    self.hudLabel.text = @"拖拽项目文件夹至此";
}

#pragma mark - PPDragDropViewDelegate 获取文件路径数据源数组
- (void)dragDropFilePathList:(NSArray<NSString *> *)filePathList
{
    // 获取拖拽文件路径数据源
    for (NSString *filePath in filePathList) {
        NSLog(@"------%@",filePath);
        // 1.检查路径是否为文件夹
        if (![self checkIsFolder:filePath]) {
            self.stateLabel.text = @"拖入的不是文件夹或文件路径不存在，请重试";
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
            self.stateLabel.text = @"请拖入项目文件夹再试";
            return;
        }
        
        // 隐藏拖拽提示界面
        self.stateLabel.text = @"正在打包";
        self.hudLabel.text = @"正在清理";
        [self showAnimation];
        
        // 此部分比较耗时，做成异步
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            typeof(self) __weak copy_self = self;
            [XATaskTool executeWithPath:filePath type:projectType name:projectName cmd:CMD_CLEAN completion:^(NSString *outputString) {
                NSLog(@"----%@",outputString);
                copy_self.stateLabel.text = @"清理完成";
                self.hudLabel.text = @"正在编译";
            }];
            [XATaskTool executeWithPath:filePath type:projectType name:projectName cmd:CMD_BUILD completion:^(NSString *outputString) {
                NSLog(@"----%@",outputString);
                copy_self.stateLabel.text = @"编译完成";
                self.hudLabel.text = @"正在打包";
            }];
            [XATaskTool executeWithPath:filePath type:projectType name:projectName cmd:CMD_ARCHIVE completion:^(NSString *outputString) {
                NSLog(@"----%@",outputString);
                copy_self.stateLabel.text = @"打包完成";
                [copy_self stopAnimation];
                [copy_self showComplete];
            }];
//            [XATaskTool executeWithPath:filePath type:projectType name:projectName cmd:CMD_OPEN completion:^(NSString *outputString) {
//                NSLog(@"----%@",outputString);
//            }];
        });
    }
}

#pragma mark 加载动画
- (void)showAnimation
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i<9; i++) {
        NSString *name = [NSString stringWithFormat:@"img_load%d",i];
        NSImage *image = [NSImage imageNamed:name];
        [imageArray addObject:image];
    }
    NSArray *reverseArr = [[imageArray reverseObjectEnumerator] allObjects];
    [imageArray addObjectsFromArray:reverseArr];
    
    self.gifView.animationImages = imageArray;
    
    [self.layer rippleEffect:^{
        self.imageView.hidden = YES;
        self.gifView.hidden = NO;
        [self.gifView startAnimating];
    }];
}

- (void)stopAnimation
{
    [self.gifView stopAnimating];
    self.gifView.hidden = YES;
}

- (void)showComplete
{
    [self.layer rippleEffect:^{
        self.hudLabel.hidden = YES;
        self.pgyBtn.hidden = NO;
        self.mgBtn.hidden = NO;
        self.otherBtn1.hidden = NO;
        self.otherBtn2.hidden = NO;
        self.completeLabel.text = @"打包完成";
        self.uploadLabel.text = @"上传至：";
        [self.pgyBtn setImage:[NSImage imageNamed:@"img_pgy"]];
        [self.mgBtn setImage:[NSImage imageNamed:@"img_01"]];
        [self.otherBtn1 setImage:[NSImage imageNamed:@"img_02"]];
        [self.otherBtn2 setImage:[NSImage imageNamed:@"img_03"]];
    }];
}


#pragma mark 检查文件夹
- (BOOL)checkIsFolder:(NSString *)filePath
{
    BOOL isFolder = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isFolder];
    return isFolder;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

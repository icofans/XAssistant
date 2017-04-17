//
//  XADragView.m
//  XAssistant
//
//  Created by AndyPang on 2017/3/5.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import "XADragView.h"

@implementation XADragView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 注册view拖动事件所监听的数据类型为'文件'类型
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // 注册view拖动事件所监听的数据类型为'文件'类型
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - 当文件拖入到view中
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    // block
    if (self.startBlock) {
        self.startBlock([[pboard types] containsObject:NSFilenamesPboardType]);
    }
    // 代理
    if ([self.delegate respondsToSelector:@selector(draggingDidEntered:)]) {
        [self.delegate draggingDidEntered:[[pboard types] containsObject:NSFilenamesPboardType]];
    }
    // 过滤掉非法的数据类型
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    if ([self.delegate respondsToSelector:@selector(draggingDidExited)]) {
        [self.delegate draggingDidExited];
    }
    
    if (self.endBlock) {
        self.endBlock();
    }
}

#pragma mark - 拖入文件后松开鼠标
- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    // 从粘贴板中提取需要的NSFilenamesPboardType数据
    NSArray *filePathList = [pboard propertyListForType:NSFilenamesPboardType];
    
    // block
    if (self.finishBlock) {
        self.finishBlock(filePathList);
    }
    // 将文件数路径组通过代理回调出去
    if([self.delegate respondsToSelector:@selector(dragDropFilePathList:)]) {
        [self.delegate dragDropFilePathList:filePathList];
    }
    
    return YES;
}

@end

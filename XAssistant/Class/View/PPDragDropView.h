//
//  PPDragDropView.h
//  PPRows
//
//  Created by AndyPang on 2017/3/5.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PPDragDropViewDelegate;

@interface PPDragDropView : NSView

@property (nonatomic, weak) id<PPDragDropViewDelegate> delegate;

@end


@protocol PPDragDropViewDelegate <NSObject>

/**
 回调用户拖拽文件的路径数组
 
 @param filePathList 文件路径数组
 */
- (void)dragDropFilePathList:(NSArray<NSString *> *)filePathList;

@end

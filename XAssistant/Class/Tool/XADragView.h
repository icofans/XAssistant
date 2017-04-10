//
//  PPDragDropView.h
//  PPRows
//
//  Created by AndyPang on 2017/3/5.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol XADragViewDelegate;

typedef void(^XADraggingDidFinishBlock)(NSArray <NSString *> *filePathList);

typedef void(^XADraggingDidEnteredBlock)(BOOL isVisble);

typedef void(^XADraggingDidExitedBlock)(void);

@interface XADragView : NSView

/**
 代理
 */
@property (nonatomic, weak) id<XADragViewDelegate> delegate;

/**
 拖拽完成回调结果
 */
@property(nonatomic,copy) XADraggingDidFinishBlock finishBlock;

/**
 拖拽检测到开始
 */
@property(nonatomic,copy) XADraggingDidEnteredBlock startBlock;

/**
 拖拽检测到结果
 */
@property(nonatomic,copy) XADraggingDidExitedBlock endBlock;


@end


@protocol XADragViewDelegate <NSObject>

/**
 回调用户拖拽文件的路径数组
 
 @param filePathList 文件路径数组
 */
- (void)dragDropFilePathList:(NSArray<NSString *> *)filePathList;

/**
  当检测到拖入文件时
 */
- (void)draggingDidEntered:(BOOL)isVisble;

/**
  拖拽取消
 */
- (void)draggingDidExited;
                              

@end

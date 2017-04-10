//
//  XALabel.h
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// 文字对齐方式
typedef enum : NSUInteger
{
    XATextAlignmentLeft    = 1,
    XATextAlignmentRight   = 2,
    XATextAlignmentCenter  = 3
} XATextAlignment;

@interface XALabel : NSView

/**
  显示的文字
 */
@property (nonatomic, copy) NSString *text;

/**
 字体大小
 */
@property (nonatomic, assign) CGFloat fontSize;

//字体名字
@property (nonatomic, copy) NSString *fontName;

//文字颜色
@property (nonatomic, strong) NSColor *textColor;

//文字清晰度，数值在0～2这个区间中，2最清晰
@property (nonatomic, assign) CGFloat definitionValue;

//文字对齐方式
@property (nonatomic, assign) XATextAlignment textAlignment;

//设置特定range的文字颜色
-(void)setTextColor:(NSColor *)textColor withRange:(NSRange)range;


@end

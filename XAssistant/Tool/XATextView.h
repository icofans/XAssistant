//
//  XATextField.h
//  XAssistant
//
//  Created by 王家强 on 17/4/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XATextView : NSView

/**
 占位字符
 */
@property(nonatomic,copy) NSString *placeholderString;

/**
 左侧Image
 */
@property(nonatomic,strong) NSImage *leftImage;


@end

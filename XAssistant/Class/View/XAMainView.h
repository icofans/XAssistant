//
//  XADragDropView.h
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^XAUploadButtonClickBlock)(void);

@interface XAMainView : NSView

/**
 回调
 */
@property(nonatomic,copy) XAUploadButtonClickBlock clickBlock;


@end

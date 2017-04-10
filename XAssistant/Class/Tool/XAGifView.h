//
//  XAGifView.h
//  XAssistant
//
//  Created by 王家强 on 17/4/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^XAGifViewDidUpdateBlock)(void);

@interface XAGifView : NSView

@property(nonatomic,copy) XAGifViewDidUpdateBlock updateBlock;

- (void)setGifImage:(NSImage*)image;

@end

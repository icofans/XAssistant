//
//  GifView.h
//  GifViewDemo_OC
//
//  Created by SkyNullCode on 4/19/15.
//  Copyright (c) 2015 SkyNullCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//draw gif myself , in order to solve gif not animated in osx 10.8 when wantsLayer is set up YES.
//in osx 10.9 or above,can use NSImageView instead. When wantsLayer is set up YES ,canDrawSubviewsIntoLayer is needed to be YES.
@interface GifView : NSView

- (void)setImage:(NSImage*)image;
- (void)setImageURL:(NSString*)url;

@end

// [self.gifView setWantsLayer:YES];
// [self.gifView setImageURL:@"http://www.12306.cn/mormhweb/images/new02.gif"];

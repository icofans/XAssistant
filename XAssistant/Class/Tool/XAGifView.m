//
//  XAGifView.m
//  XAssistant
//
//  Created by 王家强 on 17/4/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAGifView.h"

@interface XAGifView ()

@property (nonatomic) NSImage *img;
@property (nonatomic) NSBitmapImageRep *gifbitmapRep;
@property (assign) NSInteger currentFrameIdx;
@property (nonatomic)  NSTimer *giftimer;

@end

@implementation XAGifView

- (void)setGifImage:(NSImage*)img {
    if (img) {
        _img = img;
        self.gifbitmapRep = nil;
        if (self.giftimer) {
            [self.giftimer invalidate];
            self.giftimer = nil;
        }
        
        
        // get the image representations, and iterate through them
        NSArray * reps = [self.img representations];
        for (NSImageRep * rep in reps) {
            // find the bitmap representation
            if ([rep isKindOfClass:[NSBitmapImageRep class]] == YES) {
                // get the bitmap representation
                NSBitmapImageRep * bitmapRep = (NSBitmapImageRep *)rep;
                
                // get the number of frames. If it's 0, it's not an animated gif, do nothing
                int numFrame = [[bitmapRep valueForProperty:NSImageFrameCount] intValue];
                if (numFrame == 0)
                    break;
                // just consider equal time slot
                float delayTime = [[bitmapRep valueForProperty:NSImageCurrentFrameDuration] floatValue];
                self.currentFrameIdx = 0;
                self.gifbitmapRep = bitmapRep;
                
                self.giftimer = [NSTimer timerWithTimeInterval:delayTime
                                                        target:self
                                                      selector:@selector(animateGif)
                                                      userInfo:nil
                                                       repeats:YES];
                
                [[NSRunLoop mainRunLoop] addTimer:self.giftimer forMode:NSRunLoopCommonModes];
            }
        }
    } else {
        self.gifbitmapRep = nil;
        [self.giftimer invalidate];
        self.giftimer = nil;
        [self setNeedsDisplay:YES];
    }
}

- (void)drawGif {
    if (self.gifbitmapRep) {
        
        int numFrame = [[self.gifbitmapRep valueForProperty:NSImageFrameCount] intValue];
        
        if (self.currentFrameIdx >= numFrame) {
            self.currentFrameIdx = 0;
        }
        
        [self.gifbitmapRep setProperty:NSImageCurrentFrame withValue:@(self.currentFrameIdx)];
        
        NSRect drawGifRect;
        if (self.img.size.width > self.frame.size.width
            || self.img.size.height > self.frame.size.height) {
            
            float hfactor = self.img.size.width / self.frame.size.width;
            float vfactor = self.img.size.height / self.frame.size.height;
            float factor = fmax(hfactor, vfactor);
            float newWidth =  self.img.size.width / factor;
            float newHeight =  self.img.size.height / factor;
            drawGifRect = NSMakeRect((self.frame.size.width - newWidth) / 2.0,(self.frame.size.height - newHeight) / 2.0, newWidth, newHeight);
        } else {
            drawGifRect = NSMakeRect((self.frame.size.width - self.img.size.width) / 2.0,(self.frame.size.height - self.img.size.height) / 2.0, self.img.size.width, self.img.size.height);
        }
        
        [self.gifbitmapRep drawInRect:drawGifRect
                             fromRect:NSZeroRect
                            operation:NSCompositeSourceOver
                             fraction:1.0f
                       respectFlipped:NO
                                hints:nil];
        
        self.currentFrameIdx++;
    }
}

- (void)animateGif {
    [self setNeedsDisplay:YES];
    if (self.updateBlock) {
        self.updateBlock();
    }
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    [self drawGif];
    
}

- (void)dealloc {
    [self.giftimer invalidate];
    self.giftimer = nil;
}



@end

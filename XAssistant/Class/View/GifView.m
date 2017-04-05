//
//  GifView.m
//  GifViewDemo_OC
//
//  Created by SkyNullCode on 4/19/15.
//  Copyright (c) 2015 SkyNullCode. All rights reserved.
//

#import "GifView.h"

@interface GifView()

@property (nonatomic) NSImage *image;
@property (nonatomic) NSBitmapImageRep *gifbitmapRep;
@property (assign) NSInteger currentFrameIdx;
@property (nonatomic)  NSTimer *giftimer;

@end

@implementation GifView

- (void)setImage:(NSImage*)img {
    if (img) {
        _image = img;
        self.gifbitmapRep = nil;
        if (self.giftimer) {
            [self.giftimer invalidate];
            self.giftimer = nil;
        }
        
        
        // get the image representations, and iterate through them
        NSArray * reps = [self.image representations];
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
        if (self.image.size.width > self.frame.size.width
            || self.image.size.height > self.frame.size.height) {
            
            float hfactor = self.image.size.width / self.frame.size.width;
            float vfactor = self.image.size.height / self.frame.size.height;
            float factor = fmax(hfactor, vfactor);
            float newWidth =  self.image.size.width / factor;
            float newHeight =  self.image.size.height / factor;
            drawGifRect = NSMakeRect((self.frame.size.width - newWidth) / 2.0,(self.frame.size.height - newHeight) / 2.0, newWidth, newHeight);
        } else {
            drawGifRect = NSMakeRect((self.frame.size.width - self.image.size.width) / 2.0,(self.frame.size.height - self.image.size.height) / 2.0, self.image.size.width, self.image.size.height);
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
}

- (void)setImageURL:(NSString*)url {
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"Error description :%@ ,errorCode = %ld ",connectionError.description,connectionError.code);
                               } else {
                                   if (data) {
                                       NSImage *image = [[NSImage alloc]initWithData:data];
                                       if (image) {
                                           [self setImage:image];
                                       } else {
                                           NSLog(@"Error:not Image data");
                                       }
                                   }
                                   
                               }
                               
                           }];
    
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

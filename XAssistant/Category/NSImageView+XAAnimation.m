//
//  NSImageView+XAAnimation.m
//  XAssistant
//
//  Created by 王家强 on 17/4/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "NSImageView+XAAnimation.h"
#import <objc/runtime.h>

@implementation NSImageView (XAAnimation)

static char animationImagesKey;


- (void)setAnimationImages:(NSArray *)animationImages {
    objc_setAssociatedObject(self, &animationImagesKey, animationImages, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)animationImages {
    return objc_getAssociatedObject(self, &animationImagesKey);
}


- (void)startAnimating {
    
    __block NSInteger index = 0;
    
    NSTimeInterval period = 0.25; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"%@",self.animationImages);
        if (!self.animationImages) {
            dispatch_source_cancel(_timer);
            return ;
        }
        //在这里执行事件
        NSImage *image = self.animationImages[index];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
        
        index++;
        if (index == self.animationImages.count-1) {
            index = 0;
        }
    });
    dispatch_resume(_timer);
}

- (void)stopAnimating {
    objc_setAssociatedObject(self, &animationImagesKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}




@end

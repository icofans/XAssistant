//
//  CALayer+XAAnimation.m
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CALayer+XAAnimation.h"

@implementation CALayer (XAAnimation)

- (void)rippleEffect:(XAAnimationCodeBlock)block
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.8];
    [animation setType:@"rippleEffect"];
    [animation setSubtype:kCATransitionFromTop];
    block();
    [self addAnimation:animation forKey:nil];
}

@end

//
//  CALayer+XAAnimation.h
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void(^XAAnimationCodeBlock)(void);

@interface CALayer (XAAnimation)

- (void)rippleEffect:(XAAnimationCodeBlock)block;

@end

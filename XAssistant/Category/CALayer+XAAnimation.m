//
//  CALayer+XAAnimation.m
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CALayer+XAAnimation.h"


@implementation CALayer (XAAnimation)

NSString * const XAAnimationCube= @"cube"; //翻转，立方体的翻转效果
NSString * const XAAnimationSuckEffect= @"suckEffect"; //额这个效果就是右下角变小然后整张图移到左上角消失
NSString * const XAAnimationOglFlip= @"oglFlip"; //绕中心翻转
NSString * const XAAnimationRippleEffect= @"rippleEffect"; //文本抖动了一下
NSString * const XAAnimationP7ageCurl= @"p7ageCurl"; //没看出效果
NSString * const XAAnimationPageUnCurl= @"pageUnCurl"; //翻书的效果
NSString * const XAAnimationCameraIrisHollowClose= @"cameraIrisHollowClose";//相机关闭
NSString * const XAAnimationCameraIrisHollowOpen= @"cameraIrisHollowOpen"; //类似相机照相效果

/**
 文本抖动了一下
 */
- (void)rippleEffect:(XAAnimationCodeBlock)block {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.8];
    [animation setType:XAAnimationRippleEffect];
    [animation setSubtype:kCATransitionFromTop];
    block();
    [self addAnimation:animation forKey:nil];
}

- (void)addAnimationWithType:(NSString *)type subType:(NSString *)subType animation:(XAAnimationCodeBlock)block
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.8];
    [animation setType:type];
    [animation setSubtype:subType];
    block();
    [self addAnimation:animation forKey:nil];
}


@end

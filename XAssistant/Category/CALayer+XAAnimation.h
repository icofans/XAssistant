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

/**
 文本抖动了一下
 */
- (void)rippleEffect:(XAAnimationCodeBlock)block;


/**
 添加动画

 @param block 需要动画的代码
 @param type 类型
 @param subType 子类型
 */
- (void)addAnimationWithType:(NSString *)type
                    subType:(NSString *)subType
                  animation:(XAAnimationCodeBlock)block;


CA_EXTERN NSString * const XAAnimationCube; //翻转，立方体的翻转效果
CA_EXTERN NSString * const XAAnimationSuckEffect; //额这个效果就是右下角变小然后整张图移到左上角消失
CA_EXTERN NSString * const XAAnimationOglFlip; //绕中心翻转
CA_EXTERN NSString * const XAAnimationRippleEffect; //文本抖动了一下
CA_EXTERN NSString * const XAAnimationP7ageCurl; //没看出效果
CA_EXTERN NSString * const XAAnimationPageUnCurl; //翻书的效果
CA_EXTERN NSString * const XAAnimationCameraIrisHollowClose;//相机关闭
CA_EXTERN NSString * const XAAnimationCameraIrisHollowOpen; //类似相机照相效果

@end

//
//  NSImageView+XAAnimation.h
//  XAssistant
//
//  Created by 王家强 on 17/4/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImageView (XAAnimation)

@property(nonatomic,strong) NSArray *animationImages;

- (void)startAnimating;

- (void)stopAnimating;

@end

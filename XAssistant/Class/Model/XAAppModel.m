
//
//  XAAppModel.m
//  XAssistant
//
//  Created by 王家强 on 17/4/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAAppModel.h"

@implementation XAAppModel

- (NSURL *)icon_url
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://o1wh05aeh.qnssl.com/image/view/app_icons/%@",self.appIcon]];
}

@end

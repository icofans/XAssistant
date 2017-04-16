//
//  XAAppModel.h
//  XAssistant
//
//  Created by 王家强 on 17/4/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XAAppModel : NSObject

@property(nonatomic,copy) NSString *appName;

@property(nonatomic,copy) NSString *appIcon;

@property(nonatomic,copy) NSString *appIdentifier;

@property(nonatomic,strong,readonly) NSURL *icon_url;

@end

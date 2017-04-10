//
//  XAFlag.h
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XAFlag : NSObject

/**
  登录标识
 */
@property(nonatomic,assign,getter=isLogin) BOOL login;

/**
 token
 */
@property(nonatomic,strong) NSString *accessToken;

@end

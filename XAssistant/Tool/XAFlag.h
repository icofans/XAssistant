//
//  XAFlag.h
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XAFlag : NSObject

+ (instancetype)shareInstance;

/**
  登录标识
 */
@property(nonatomic,assign,getter=isLogin) BOOL login;


/**
 file
 */
@property(nonatomic,strong) NSString *ipaPath;

/**
 api_key
 */
@property(nonatomic,strong) NSString *api_key;

/**
 user_key
 */
@property(nonatomic,strong) NSString *user_key;



@end

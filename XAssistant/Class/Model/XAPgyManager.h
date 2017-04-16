//
//  XAPgyManager.h
//  XAssistant
//
//  Created by 王家强 on 17/4/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XAPgyManager : NSObject

@property(nonatomic,assign) BOOL needLogin;

+ (instancetype)shareInstance;

- (void)xa_login:(NSString *)account
       password:(NSString *)pwd
      completion:(void(^)(BOOL success,NSString *result))block;

- (void)xa_uploadIpaCompletion:(void(^)(BOOL isSuccess))block;


@end

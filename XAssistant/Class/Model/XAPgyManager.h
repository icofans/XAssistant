//
//  XAPgyManager.h
//  XAssistant
//
//  Created by 王家强 on 17/4/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAAppModel.h"

@interface XAPgyManager : NSObject

@property(nonatomic,assign) BOOL needLogin;

+ (instancetype)shareInstance;


/**
 登录到蒲公英

 @param account 账号
 @param pwd 密码
 @param block 回调
 */
- (void)xa_login:(NSString *)account
       password:(NSString *)pwd
      completion:(void(^)(BOOL success,NSString *result))block;


/**
 上传ipa
 
 @param block 回调
 */
- (void)xa_uploadIpa:(void (^)(NSProgress * progross))uploadProgress
         completion:(void(^)(BOOL isSuccess,NSString *url))block;


/**
 检测App信息

 @param bundleIdentifier id
 @param block 回调
 */
- (void)xa_checkAppInfo:(NSString *)bundleIdentifier
            completion:(void(^)(XAAppModel *info))block;

@end

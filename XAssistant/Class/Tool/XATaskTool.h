//
//  XATaskTool.h
//  XAssistant
//
//  Created by 王家强 on 17/4/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAEnumMacro.h"

@interface XATaskTool : NSObject

/**
  执行task

 @param filePath 文件路径
 @param type 类型
 @param projectName 项目名
 @param cmdType 命令类型
 */
+ (void)executeWithPath:(NSString *)filePath
                  type:(XAProjectType)type
                  name:(NSString *)projectName
                   cmd:(XCommandType)cmdType
            completion:(void(^)(NSString *outputString))block;



@end

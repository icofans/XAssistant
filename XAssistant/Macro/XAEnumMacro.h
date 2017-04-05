//
//  XAEnumMacro.h
//  XAssistant
//
//  Created by 王家强 on 17/4/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef XAEnumMacro_h
#define XAEnumMacro_h

typedef NS_OPTIONS(NSUInteger, XAProjectType) {
    PROJECT_UNKNOWN     = 0, // 未知
    PROJECT_NORMAL      = 1, // 普通项目
    PROJECT_WORKSPACE   = 2, // 工作空间类项目
};

typedef NS_OPTIONS(NSUInteger, XCommandType) {
    CMD_CLEAN       = 0, // clean
    CMD_BUILD       = 1, // 编译
    CMD_ARCHIVE     = 2, // 打包
};

#endif /* XAEnumMacro_h */

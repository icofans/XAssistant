//
//  XAFlag.m
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAFlag.h"

@implementation XAFlag

+ (instancetype)shareInstance
{
    static XAFlag *flag = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flag = [[XAFlag alloc] init];
    });
    return flag;
}

- (void)setAppPath:(NSString *)appPath
{
    _appPath = appPath;
    // 通过AppPath解析Info.plist
    [self analyzingPlist:appPath];
    
}


#pragma mark 解析Plist文件
- (void)analyzingPlist:(NSString *)filePath
{
    NSString *infoPath = [NSString stringWithFormat:@"%@/Contents/Info.plist",filePath];
    
    BOOL isFolder;
    // 标记此路径是否存在
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isFolder];
    
    if (isExist) {
        // 读取InfoPlist
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
        
        NSString *bundleIdentifier = [dict valueForKey:@"CFBundleIdentifier"];
        self.bundleIdentifier = bundleIdentifier;
        
        NSString *version = [dict valueForKey:@"CFBundleShortVersionString"];
        self.version = version;
    }
}

@end

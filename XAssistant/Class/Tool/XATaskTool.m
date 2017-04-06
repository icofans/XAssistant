//
//  XATaskTool.m
//  XAssistant
//
//  Created by 王家强 on 17/4/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XATaskTool.h"

@interface XATaskTool ()

@property(nonatomic,strong) NSTask *task;

@end

@implementation XATaskTool

+ (void)executeWithPath:(NSString *)filePath type:(XAProjectType)type name:(NSString *)projectName cmd:(XCommandType)cmdType completion:(void (^)(NSString *))block
{
    // 初始化并设置shell路径
    NSTask *task = [[NSTask alloc] init];
    if (cmdType == CMD_ARCHIVE) {
        [task setLaunchPath:@"/usr/bin/xcrun"];
    } else if (cmdType == CMD_OPEN) {
        [task setLaunchPath: @"/usr/bin/open"];
    } else {
        [task setLaunchPath: @"/usr/bin/xcodebuild"];
    }
    [task setCurrentDirectoryPath:filePath];
    
    NSArray *arguments;
    NSString *sdk = @"iphoneos";
    NSString *configuration = @"Release";
    switch (cmdType) {
        case CMD_CLEAN:
        {
            // xcodebuild -target targetname clean
            arguments = [NSArray arrayWithObjects:@"-target",projectName,@"clean",nil];
        }
            break;
        case CMD_BUILD:
        {
            // 判断项目类型
            if (type == PROJECT_WORKSPACE) {
                // xcodebuild -scheme shemename -workspace xxx.xcworkspace build
                NSString *workspace = [NSString stringWithFormat:@"%@.xcworkspace",projectName];
                NSString *output = [NSString stringWithFormat:@"SYMROOT=%@/build",filePath];
                arguments = [NSArray arrayWithObjects:@"-scheme",projectName,
                                                      @"-workspace",workspace,
                                                      @"-configuration",configuration,
                                                      @"build",output,nil];
            } else {
                // xcodebuld -target targetname build
                arguments = [NSArray arrayWithObjects:@"-target",projectName,
                                                      @"-configuration",configuration,
                                                      @"build",nil];
            }
        }
            break;
        case CMD_ARCHIVE:
        {
            // xcrun -sdk iphoneos PackageApplication -v targetname.app所在目录/targetname.app" -o 想要输出的目录/文件名.ipa
            // 获取文件路径
            // 关于build product path获取问题。[OSX 应用默认为Release和Debug] [iOS 应用为Release-iphoneos和Debug-iphoneos]
            // 此处需要检测
            NSString *targetPath;
            
            NSString *path1 = [NSString stringWithFormat:@"%@/build/%@/%@.app",filePath,configuration,projectName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path1 isDirectory:nil]) {
                targetPath = path1;
            }
            
            NSString *path2 = [NSString stringWithFormat:@"%@/build/%@-iphoneos/%@.app",filePath,configuration,projectName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path2 isDirectory:nil]) {
                targetPath = path2;
            }
            
            NSLog(@"app路径---%@",targetPath);
            
            NSString *output = [NSString stringWithFormat:@"%@/%@.ipa",filePath,projectName];
            arguments = [NSArray arrayWithObjects:@"-sdk", sdk,
                                                  @"PackageApplication",
                                                  @"-v", targetPath,
                                                  @"-o", output, nil];
        }
            break;
        case CMD_OPEN:
        {
            // xcodebuild -target targetname clean
            NSString *output = [NSString stringWithFormat:@"%@",filePath];
            arguments = [NSArray arrayWithObjects:output,nil];
        }
            break;
            
        default:
            break;
    }
    [task setArguments:arguments];
    
    // 新建输出管道作为Task的输出
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    // 开始task
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    // 获取运行结果
    NSData *data = [file readDataToEndOfFile];
    NSString *resultStr = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    // 回调中做UI更新，回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        block(resultStr);
    });
}


@end

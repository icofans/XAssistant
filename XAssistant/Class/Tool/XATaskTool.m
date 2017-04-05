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
    } else {
        [task setLaunchPath: @"/usr/bin/xcodebuild"];
    }
    [task setCurrentDirectoryPath:filePath];
    
    NSArray *arguments;
    NSString *sdk = @"iphoneos";
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
                NSString *output = [NSString stringWithFormat:@"SYMROOT=%@",filePath];
                arguments = [NSArray arrayWithObjects:@"-scheme",projectName,
                                                      @"-workspace",workspace,
                                                      @"build",output,nil];
            } else {
                
                // xcodebuld -target targetname build
                arguments = [NSArray arrayWithObjects:@"-target",projectName,
                                                      @"build",nil];
            }
        }
            break;
        case CMD_ARCHIVE:
        {
            // xcrun -sdk iphoneos PackageApplication -v targetname.app所在目录/targetname.app" -o 想要输出的目录/文件名.ipa
            // 获取文件路径
            NSString *path = [NSString stringWithFormat:@"./build/Release-iphoneos/%@.app",projectName];
            NSString *output = [NSString stringWithFormat:@"%@/%@.ipa",filePath,projectName];
            arguments = [NSArray arrayWithObjects:@"-sdk", sdk,
                                                  @"PackageApplication",
                                                  @"-v", path,
                                                  @"-o", output, nil];
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
    
    block(resultStr);
}


@end

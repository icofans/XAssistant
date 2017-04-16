//
//  XAPgyManager.m
//  XAssistant
//
//  Created by 王家强 on 17/4/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAPgyManager.h"
#import "AFNetworking.h"

@interface XAPgyManager ()

@property(nonatomic,strong) AFHTTPSessionManager *afManager;

@end

@implementation XAPgyManager

+ (instancetype)shareInstance
{
    static XAPgyManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[XAPgyManager alloc] init];
    });
    return m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.afManager = [[AFHTTPSessionManager alloc] init];
        self.afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (void)xa_login:(NSString *)account password:(NSString *)pwd completion:(void (^)(BOOL, NSString *))block
{
    NSString *url = @"http://www.pgyer.com/user/login";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:account forKey:@"email"];
    [parameters setObject:pwd forKey:@"password"];
    
    // request
    [self.afManager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if([[dict objectForKey:@"code"] integerValue] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"uId"];
            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 获取API信息
            [self getApiCompletion:block];
        } else {
            block(NO,@"账号或密码错误，登录失败");
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)xa_uploadIpaCompletion:(void (^)(BOOL))block
{
    NSString *url = @"https://qiniu-storage.pgyer.com/apiv1/app/upload";
}


    
     
- (void)getApiCompletion:(void(^)(BOOL success,NSString *))block {
    NSString *url = @"http://www.pgyer.com/doc/api";
    [self.afManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (dataString) {
            // 获取_user_key;
            NSString *api_key = [self subStr:dataString start:@"&_api_key=" end:@"&"];
            NSString *user_key = [self subStr:dataString start:@"var uk = '" end:@"'"];
            
            NSLog(@"%@------%@",api_key,user_key);
            block(YES,@"登录成功");
        } else {
            block(NO,@"登录失败，为获取到Key");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (NSString *)subStr:(NSString *)dataString start:(NSString *)start end:(NSString *)end
{
    NSRange startRange = [dataString rangeOfString:start];
    // 截取值
    NSString *tempStr = [dataString substringFromIndex:startRange.location+startRange.length];

    NSRange endRange = [tempStr rangeOfString:end];
    
    NSRange range = NSMakeRange(0,
                        endRange.location);
    
    NSString *result = [tempStr substringWithRange:range];
    return result;
}


@end

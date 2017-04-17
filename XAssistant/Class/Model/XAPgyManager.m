//
//  XAPgyManager.m
//  XAssistant
//
//  Created by 王家强 on 17/4/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAPgyManager.h"
#import "AFNetworking.h"
#import "XAFlag.h"

@interface XAPgyManager ()

@property(nonatomic,strong) AFHTTPSessionManager *afManager;

@property(nonatomic,copy) NSString *api_key;

@property(nonatomic,copy) NSString *user_key;

@property(nonatomic,copy) NSString *app_key;

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
            
            [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"uid"];
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

- (void)xa_uploadIpa:(void (^)(NSProgress *))uploadProgress completion:(void (^)(BOOL,NSString *))block
{
    NSString *url = @"https://qiniu-storage.pgyer.com/apiv1/app/upload";
    
    NSString *filepath = [XAFlag shareInstance].ipaPath;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.api_key forKey:@"_api_key"];
    [parameters setObject:self.user_key forKey:@"uKey"];
    [self.afManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        [formData appendPartWithFileData:data name:@"file" fileName:@"app.ipa" mimeType:@"ipa"];
    } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict[@"code"] integerValue] == 0) {
            NSString *appkey = dict[@"data"][@"appKey"];
            self.app_key = appkey;
            [self getAppinfoCompletion:^(NSString *str) {
                block(YES,str);
            }];
        } else  {
            block(NO,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)xa_checkAppInfo:(NSString *)bundleIdentifier completion:(void (^)(XAAppModel *))block
{
    // 获取key
    NSString *url = @"http://www.pgyer.com/apiv1/user/listMyPublished";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.api_key forKey:@"_api_key"];
    [parameters setObject:self.user_key forKey:@"uKey"];
    [parameters setObject:@"1" forKey:@"page"];
    [self.afManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *list = dict[@"data"][@"list"];
            if (list.count) {
                BOOL isExist = NO;
                for (NSDictionary *dict in list) {
                    if (([dict[@"appType"] interval]==1)&&([dict[@"appIdentifier"] isEqualToString:bundleIdentifier])) {
                        isExist = YES;
                        XAAppModel *model = [[XAAppModel alloc] init];
                        model.appIdentifier = dict[@"appIdentifier"];
                        model.appIcon = [NSString stringWithFormat:@"%@",dict[@"appIcon"]];
                        model.appName = dict[@"appName"];
                        block(model);
                    }
                }
                if (!isExist) { block(nil); }
            } else {
                block(nil);
            }
        } else {
            block(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}

- (void)getAppinfoCompletion:(void(^)(NSString *))block
{
    NSString *url = @"";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.api_key forKey:@"_api_key"];
    [parameters setObject:self.user_key forKey:@"uKey"];
    [parameters setObject:self.app_key forKey:@"aKey"];
    [self.afManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dict[@"code"] integerValue] == 0) {
            NSString *shortUrl = dict[@"data"][@"appShortcutUrl"];
            block([NSString stringWithFormat:@"https://wwww.pgyer.com/%@",shortUrl]);
        } else {
            block(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
     
- (void)getApiCompletion:(void(^)(BOOL success,NSString *))block {
    NSString *url = @"http://www.pgyer.com/doc/api";
    [self.afManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (dataString) {
            // 获取_user_key;
            NSString *api_key = [self subStr:dataString start:@"&_api_key=" end:@"&"];
            NSString *user_key = [self subStr:dataString start:@"var uk = '" end:@"'"];
            
            self.api_key = api_key;
            self.user_key = user_key;
            [[NSUserDefaults standardUserDefaults] setObject:api_key forKey:@"api_key"];
            [[NSUserDefaults standardUserDefaults] setObject:user_key forKey:@"user_key"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
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

//
//  XAPgyView.m
//  XAssistant
//
//  Created by 王家强 on 17/4/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "XAPgyView.h"
#import "XATextView.h"
#import "XALabel.h"
#import "XAPgyManager.h"
#import "MBProgressHUD.h"

@interface XAPgyView ()

/** 标题 */
@property(nonatomic,strong) XALabel *titleLabel;

@property(nonatomic,strong) XATextView *accountTF;

@property(nonatomic,strong) XATextView *passwordTF;

@property(nonatomic,strong) NSButton *loginBtn;

@end

@implementation XAPgyView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    // titleBar
    self.titleLabel = [[XALabel alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 290, self.frame.size.width, 30))];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = XATextAlignmentCenter;
    self.titleLabel.textColor = [NSColor whiteColor];
    self.titleLabel.fontSize = 17;
    self.titleLabel.text = @"蒲公英";
    self.titleLabel.fontName = [NSFont boldSystemFontOfSize:10.0].fontName;
    
    [self creatLoginView];
}

- (void)creatLoginView
{
    self.accountTF = [[XATextView alloc] initWithFrame:NSRectToCGRect(CGRectMake(50, 220, self.frame.size.width-100, 35))];
    [self addSubview:self.accountTF];
    self.accountTF.placeholderString = @"请输入账号";
    self.accountTF.leftImage = [NSImage imageNamed:@"img_account"];
    
    self.passwordTF = [[XATextView alloc] initWithFrame:NSRectToCGRect(CGRectMake(50, 160, self.frame.size.width-100, 35))];
    [self addSubview:self.passwordTF];
    self.passwordTF.placeholderString = @"请输入密码";
    self.passwordTF.leftImage = [NSImage imageNamed:@"img_password"];
    
    self.loginBtn = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(50, 90, self.frame.size.width-100, 40))];
    [self addSubview:self.loginBtn];
    self.loginBtn.font = [NSFont systemFontOfSize:16];
    self.loginBtn.bordered = NO;
    self.loginBtn.image = [NSImage imageNamed:@"img_btn"];
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    
    [self.loginBtn setTarget:self];
    [self.loginBtn setAction:@selector(buttonClick:)];
    
}

#pragma mrk 点击事件
- (void)buttonClick:(NSButton *)sender
{
    // 获取账号密码
    NSString *account = self.accountTF.text;
    NSString *pwd = self.passwordTF.text;
    
    if (!account.length || !pwd.length) {
        [self showError:@"请检查输入"];
    }
    if (![self validateEmail:account]) {
        [self showError:@"邮箱地址不正确"];
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
    
    // Set the hud to display with a color
    typeof(self) __weak weakSelf = self;
    [HUD showAnimated:YES whileExecutingBlock:^{
        NSLog(@"p------%@-------%@",account,pwd);
        [[XAPgyManager shareInstance] xa_login:account password:pwd completion:^(BOOL success, NSString *result) {
            if (success) {
                
            } else {
                [weakSelf showError:result];
            }
        }];
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
    
    
    
    
    
    
}

- (void)showError:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Some message...";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}


- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

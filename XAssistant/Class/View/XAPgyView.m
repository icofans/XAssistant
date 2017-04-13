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
    
}




- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

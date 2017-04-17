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
#import "CALayer+XAAnimation.h"
#import "NSImageView+XAAnimation.h"
#import "XAFlag.h"

@interface XAPgyView ()

/** 标题 */
@property(nonatomic,strong) XALabel *titleLabel;

@property(nonatomic,strong) XATextView *accountTF;

@property(nonatomic,strong) XATextView *passwordTF;

@property(nonatomic,strong) NSButton *loginBtn;


/** 提示文字 */
@property(nonatomic,strong) XALabel *hudLabel;

/** GIF图 */
@property(nonatomic,strong) NSImageView *gifView;

/** 底部状态 */
@property (nonatomic,strong) XALabel *stateLabel;

@property (nonatomic,strong) NSImageView *completeImageV;

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
    
    [self creatUploadView];
    
    [self creatCompleteView];
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
    self.passwordTF.secureTextEntry = YES;
    
    self.loginBtn = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(50, 90, self.frame.size.width-100, 40))];
    [self addSubview:self.loginBtn];
    self.loginBtn.font = [NSFont systemFontOfSize:16];
    self.loginBtn.bordered = NO;
    self.loginBtn.image = [NSImage imageNamed:@"img_btn"];
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;

    [self.loginBtn setTarget:self];
    [self.loginBtn setAction:@selector(buttonClick:)];
    
    // 获取本地的信息
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    [self.accountTF setText:uid];
    [self.passwordTF setText:pwd];
    
}

#pragma mrk 点击事件
- (void)buttonClick:(NSButton *)sender
{
    // 获取账号密码
    NSString *account = self.accountTF.text;
    NSString *pwd = self.passwordTF.text;
    
    if (!account.length) {
        [self showError:@"请输入帐号"];
        return;
    } else if (!pwd.length) {
        [self showError:@"请输入密码"];
        return;
    }
    if (![self validateEmail:account]) {
        [self showError:@"邮箱地址不正确"];
        return; }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
    
    HUD.color = [NSColor colorWithDeviceRed:0.1 green:0.1 blue:0.1 alpha:0.90];
    // Set the hud to display with a color
    typeof(self) __weak weakSelf = self;
    [HUD showAnimated:YES whileExecutingBlock:^{
        NSLog(@"p------%@-------%@",account,pwd);
        [[XAPgyManager shareInstance] xa_login:account password:pwd completion:^(BOOL success, NSString *result) {
            if (success) {
                // 登录成功 上传
                [weakSelf toUpload];
            } else {
                [weakSelf showError:result];
            }
        }];
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];   
}

- (void)toUpload
{
    // 获取用户名
    NSString *uName = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    [self showAnimation];
    [self.layer rippleEffect:^{
        self.accountTF.hidden = YES;
        self.passwordTF.hidden = YES;
        self.loginBtn.hidden = YES;
        self.hudLabel.hidden = NO;
        [self.gifView startAnimating];
        self.titleLabel.text = uName;
    }];
    
    typeof(self) __weak weakSelf = self;
    [[XAPgyManager shareInstance] xa_uploadIpa:^(NSProgress *progross) {
        long completedUnitCount = progross.completedUnitCount;
        long totalUnitCount = progross.totalUnitCount;
        double percent = (completedUnitCount*1.0)/(totalUnitCount/100.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.stateLabel.text = [NSString stringWithFormat:@"上传中:%.0f%%",percent];
        });
    } completion:^(BOOL isSuccess,NSString *str) {
        weakSelf.titleLabel.text = @"打包助手";
        weakSelf.stateLabel.text = [NSString stringWithFormat:@"上传完成:%@",str];
        [weakSelf toComplete];
    }];
}

- (void)toComplete
{
    [self.layer rippleEffect:^{
        self.completeImageV.hidden = NO;
        [self stopAnimation];
        self.hudLabel.hidden = YES;
    }];
}

#pragma mark 上传视图
- (void)creatUploadView
{
    self.gifView = [[NSImageView alloc] initWithFrame:NSRectFromCGRect(CGRectMake((self.frame.size.width-142)/2, (self.frame.size.height-123)/2+23, 142, 123))];
    [self addSubview:self.gifView];
    self.gifView.hidden = YES;
    
    NSRect tfRect = NSRectFromCGRect(CGRectMake(0, (self.frame.size.height-130)/2-10, 350, 20));
    self.hudLabel = [[XALabel alloc] initWithFrame:tfRect];
    [self addSubview:self.hudLabel];
    self.hudLabel.textAlignment = XATextAlignmentCenter;
    self.hudLabel.text = @"上传中";
    self.hudLabel.textColor = [NSColor whiteColor];
    self.hudLabel.fontSize = 16;
    self.hudLabel.hidden = YES;
    
    // 进度
    self.stateLabel = [[XALabel alloc] initWithFrame:NSRectToCGRect(CGRectMake(8, 0, 330, 20))];
    [self addSubview:self.stateLabel];
    self.stateLabel.textColor = [NSColor whiteColor];
    self.stateLabel.fontSize = 13;
}

#pragma mark 加载动画
- (void)showAnimation
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i<9; i++) {
        NSString *name = [NSString stringWithFormat:@"img_load%d",i];
        NSImage *image = [NSImage imageNamed:name];
        [imageArray addObject:image];
    }
    NSArray *reverseArr = [[imageArray reverseObjectEnumerator] allObjects];
    [imageArray addObjectsFromArray:reverseArr];
    
    self.gifView.hidden = NO;
    self.gifView.animationImages = imageArray;
}

- (void)stopAnimation
{
    [self.gifView stopAnimating];
    self.gifView.hidden = YES;
}

- (void)creatCompleteView
{
    CGFloat imgW = 164;
    CGRect imgRect = CGRectMake((self.frame.size.width-imgW)/2, (self.frame.size.height-imgW)/2, imgW, imgW);
    self.completeImageV = [[NSImageView alloc] initWithFrame:NSRectToCGRect(imgRect)];
    [self addSubview:self.completeImageV];
    
    self.completeImageV.image = [NSImage imageNamed:@"img_complete"];
    self.completeImageV.hidden = YES;
}


- (void)showError:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
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

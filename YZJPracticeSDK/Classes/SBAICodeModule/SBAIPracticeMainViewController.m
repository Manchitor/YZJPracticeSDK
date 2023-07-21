//
//  SBAIPracticeMainViewController.m
//  SBAIPractice_Example
//
//  Created by 刘永吉 on 2023/6/29.
//  Copyright © 2023 Manchitor. All rights reserved.
//

#import "SBAIPracticeMainViewController.h"
#import "SBAIPracticeListViewController.h"

#import "SBAIPractice.h"

@interface SBAIPracticeMainViewController ()

@property (nonatomic,strong) UITextField *accountTextField;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UIButton *clearButton;

@property (nonatomic,strong) UIButton *practiceButton;

@property (nonatomic,strong) UIButton *logoutButton;

@end

@implementation SBAIPracticeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupconfig];
    [self setupui];
}

#pragma mark ----------初始化页面配置
-(void)setupconfig{
    self.navigationItem.title = @"智能陪练";
    NSLog(@"SBAIPracticeVersion:2.0.0");
}

#pragma mark ----------初始化页面UI
-(void)setupui{
    [self.view addSubview:self.accountTextField];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.practiceButton];
    [self.practiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.practiceButton.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.logoutButton];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clearButton.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark --------页面事件
-(void)login{
    [self.view endEditing:YES];
    if (tf_isEmptyString(self.accountTextField.text)){
        tf_toastMsg(@"请输入您的账号");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"18721218206" forKey:@"phone"];
    [params setObject:self.accountTextField.text forKey:@"userId"];
    [params setObject:@"liuyongji" forKey:@"userName"];
    [MBProgressHUD showHUD];
    [SBAILoginRequest sb_loginRequest:params Success:^(BOOL isSuccess, SBAIResponseModel *responseObject) {
        [MBProgressHUD hideHUD];
        if (isSuccess){
            tf_toastMsg(@"登录成功");
            SBAIPracticeLoginModel *model = [SBAIPracticeLoginModel mj_objectWithKeyValues:responseObject.data];
            
            [[NSUserDefaults standardUserDefaults] setObject:[model mj_JSONString] forKey:@"SB_AI_LOGIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [RequestManager reloadHeaderData];
        }else{
            tf_toastMsg(responseObject.msg);
        }
    }];
}

-(void)practice{
    [self.view endEditing:YES];
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];
    if (loginModel.token) {
        SBAIPracticeListViewController *vc = [[SBAIPracticeListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        tf_toastMsg(@"请先登录");
    }
}

-(void)clear{
    [self.view endEditing:YES];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否清除文件资源缓存" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *path = [SBFileTool absolutePath:@"practice_video_file" filePathType:SBFileToolPathTypeCache];
        if ([SBFileTool isfileExistsAtPath:path]){
            [SBFileTool removePath:path];
        }else{
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)logout{
    [self.view endEditing:YES];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SB_AI_LOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    tf_toastMsg(@"退出登录成功");
    self.accountTextField.text = @"";
}

#pragma mark ----------懒加载
-(UITextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.textColor = HEXCOLOR(0x333333);
        _accountTextField.font = FONT_SYS_NOR(15);
        _accountTextField.placeholder = @"请输入账号";
        [_accountTextField setPlaceholderColor:HEXCOLOR(0xCCCCCC)];
        _accountTextField.layer.cornerRadius = 22;
        _accountTextField.layer.borderColor = HEXCOLOR(0xe6e6e6).CGColor;
        _accountTextField.layer.borderWidth = 1;
        _accountTextField.clipsToBounds = YES;
        _accountTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
        _accountTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _accountTextField;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 22;
        _loginButton.layer.borderColor = HEXCOLOR(0xf8f8f8).CGColor;
        _loginButton.layer.borderWidth = 1;
        _loginButton.clipsToBounds = YES;
        _loginButton.backgroundColor = HEXCOLOR(0x52A0FF);
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIButton *)practiceButton{
    if (!_practiceButton) {
        _practiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_practiceButton setTitle:@"陪练列表" forState:UIControlStateNormal];
        [_practiceButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        _practiceButton.layer.cornerRadius = 22;
        _practiceButton.layer.borderColor = HEXCOLOR(0xf8f8f8).CGColor;
        _practiceButton.layer.borderWidth = 1;
        _practiceButton.clipsToBounds = YES;
        _practiceButton.backgroundColor = HEXCOLOR(0x52A0FF);
        [_practiceButton addTarget:self action:@selector(practice) forControlEvents:UIControlEventTouchUpInside];
    }
    return _practiceButton;
}

-(UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setTitle:@"清除缓存" forState:UIControlStateNormal];
        [_clearButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        _clearButton.layer.cornerRadius = 22;
        _clearButton.layer.borderColor = HEXCOLOR(0xf8f8f8).CGColor;
        _clearButton.layer.borderWidth = 1;
        _clearButton.clipsToBounds = YES;
        _clearButton.backgroundColor = HEXCOLOR(0x52A0FF);
        [_clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

-(UIButton *)logoutButton{
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        _logoutButton.layer.cornerRadius = 22;
        _logoutButton.layer.borderColor = HEXCOLOR(0xf8f8f8).CGColor;
        _logoutButton.layer.borderWidth = 1;
        _logoutButton.clipsToBounds = YES;
        _logoutButton.backgroundColor = HEXCOLOR(0x52A0FF);
        [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}
@end

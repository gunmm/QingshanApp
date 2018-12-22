//
//  LoginViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginResponse.h"
#import "StandMainMMController.h"
#import "DriverMainMMController.h"
#import "RegisterViewController.h"
#import "JPUSHService.h"



@interface LoginViewController ()

@property NSInteger jpushCount;
@property (weak, nonatomic) IBOutlet UIButton *versionBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView {
    self.title = @"登录";
    self.loginBtn.layer.cornerRadius = 6;
    self.loginBtn.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.verionBtnTop.constant = STATUS_HEIGHT;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [_versionBtn setTitle:appCurVersion forState:UIControlStateNormal];
    if([[Config shareConfig] getUserName].length > 0) {
        self.usernameTextField.text = [[Config shareConfig] getUserName];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (IBAction)loginAct:(UIButton *)sender {
    
    
    [self.view endEditing:YES];
    
    NSString *userName = _usernameTextField.text;
    if ([Utils isEmpty:userName])
    {
        [HUDClass showHUDWithLabel:@"用户名和密码不能为空" view:self.view];
        return;
    }
    
    NSString *pwd = _passwordTextFiled.text;
    if ([Utils isEmpty:pwd])
    {
        [HUDClass showHUDWithLabel:@"用户名和密码不能为空" view:self.view];
        return;
    }
    [[Config shareConfig] setUserName:userName];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:userName forKey:@"phoneNumber"];
    [param setObject:[Utils md5:pwd] forKey:@"password"];
    [param setObject:@"iOS" forKey:@"plateform"];


    [NetWorking loginPostDataWithParameters:param withUrl:@"login" withBlock:^(id result) {
        LoginResponse *loginResponse = [LoginResponse mj_objectWithKeyValues:result];
        UserModel *loginModel = loginResponse.object;
        
        if (!([loginModel.type isEqualToString:@"5"] || [loginModel.type isEqualToString:@"6"])) {
            [HUDClass showHUDWithText:@"角色错误！"];
            return;
        }
        
        
        [[Config shareConfig] setUserName:loginModel.phoneNumber];
        [[Config shareConfig] setName:loginModel.nickname];
        [[Config shareConfig] setUserImage:loginModel.personImageUrl];
        [[Config shareConfig] setUserId:loginModel.userId];
        [[Config shareConfig] setType:loginModel.type];
        [[Config shareConfig] setToken:loginModel.accessToken];
        [[Config shareConfig] setBankCardNumber:loginModel.bankCardNumber];
        [[Config shareConfig] setDriverType:loginModel.driverType];

        if ([loginModel.type isEqualToString:@"5"]) {
            StandMainMMController *standMainVC = [[StandMainMMController alloc] initStandMainMMVC];
            [self.view.window setRootViewController:standMainVC];
        }else if ([loginModel.type isEqualToString:@"6"]) {
            DriverMainMMController *driverMainVC = [[DriverMainMMController alloc] initDriverMainMMVC];
            [self.view.window setRootViewController:driverMainVC];
        }
        [self registerJpush];

    } withFailedBlock:^(NSString *errorResult) {
    }];
    
}

- (IBAction)changeVersionBtnAct:(UIButton *)sender {
    
    [AlertView alertViewWithTitle:@"请输入IP" withMessage:@"" withPlaceholder:@"请输入IP" withType:UIAlertControllerStyleAlert withKeykeyboardType:UIKeyboardTypeDefault withTextBlock:^(NSString *text) {
        [[Config shareConfig] setServer:text];
    } withCancelBlock:^{
        
    }];
}

- (IBAction)registerAct:(id)sender {
    self.navigationController.navigationBar.hidden = NO;
    RegisterViewController *registerVc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (IBAction)passwordAct:(UIButton *)sender {
    self.navigationController.navigationBar.hidden = NO;
    RegisterViewController *registerVc = [[RegisterViewController alloc] init];
    registerVc.isBackPassword = YES;
    [self.navigationController pushViewController:registerVc animated:YES];
}



- (void)registerJpush
{
    __weak typeof(self) weakSelf = self;
    [JPUSHService setTags:nil alias:[[Config shareConfig] getToken] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"zhenhao---rescode: %d, tags: %@, alias: %@", iResCode, iTags , iAlias);
        
        if (0 == iResCode)
        {
            NSLog(@"zhenhao:jpush register successfully!");
        }
        else
        {
            NSString *err = [NSString stringWithFormat:@"%d:注册消息服务器失败，请重新再试", iResCode];
            NSLog(@"zhenhao:%@", err);
            
            if (weakSelf.jpushCount < 5)
            {
                weakSelf.jpushCount++;
                [weakSelf registerJpush];
            }
            else
            {
                [HUDClass showHUDWithLabel:@"消息推送服务注册失败，请重新登录!" view:self.view];
                [Utils backToLogin];
            }
        }
    }];
}


@end

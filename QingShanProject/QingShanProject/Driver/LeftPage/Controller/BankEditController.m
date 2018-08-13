//
//  BankEditController.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BankEditController.h"

@interface BankEditController ()

@property (copy, nonatomic) NSString *securityCode;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger nowCount;

@end

@implementation BankEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
}

- (void)initView {
    _sendBtn.layer.borderWidth = 0.5;
    _sendBtn.layer.borderColor = mainColor.CGColor;
    _sendBtn.layer.cornerRadius = 4;
    _sendBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendCode)];
    [_sendBtn addGestureRecognizer:tap];
    _sendBtn.userInteractionEnabled = YES;
    
    
    _submitBtn.layer.cornerRadius = 4;
    _submitBtn.layer.masksToBounds = YES;
    
   
    
    
    _bankNumberTextF.text = _bankNumberStr;
}

- (void)sendCode {
    [self.view endEditing:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    __weak typeof(self) weakSelf = self;
    
    
    [NetWorking postDataWithParameters:param withUrl:@"getBankCode" withBlock:^(id result) {
        weakSelf.securityCode = [result objectForKey:@"object"];
        [HUDClass showHUDWithText:@"验证码发送成功！"];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hiddenView) userInfo:nil repeats:YES];
        self.nowCount = 60;
        self.sendBtn.userInteractionEnabled = NO;
        self.sendBtn .text = [NSString stringWithFormat:@"%ldS",self.nowCount];
        self.sendBtn.textColor = [UIColor grayColor];
        
    } withFailedBlock:^(NSString *errorResult) {
    }];
}

- (void)hiddenView {
    _nowCount --;
    if (_nowCount < 0) {
        [_timer invalidate];
        _sendBtn.userInteractionEnabled = YES;
        _sendBtn.text = @"再次发送";
        _sendBtn.textColor = mainColor;
    }else{
        _sendBtn.text = [NSString stringWithFormat:@"%ldS",_nowCount];
    }
}


- (void)initNavBar {
    self.title = @"银行卡号";
}

- (IBAction)postCodeAct:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    __weak typeof(self) weakSelf = self;
    
    
    [NetWorking postDataWithParameters:param withUrl:@"getBankCode" withBlock:^(id result) {
        weakSelf.securityCode = [result objectForKey:@"object"];
        [HUDClass showHUDWithText:@"验证码发送成功！"];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hiddenView) userInfo:nil repeats:YES];
        self.nowCount = 60;
        self.sendBtn.userInteractionEnabled = NO;
        self.sendBtn .text = [NSString stringWithFormat:@"%ldS",self.nowCount];
        self.sendBtn.textColor = [UIColor grayColor];
        
    } withFailedBlock:^(NSString *errorResult) {
    }];
    
}

- (IBAction)submitAct:(id)sender {
    if (_bankNumberTextF.text.length == 0) {
        [HUDClass showHUDWithText:@"银行卡号不能为空！"];
        return;
    }
    
    if (![_codeTextF.text isEqualToString:self.securityCode]) {
        [HUDClass showHUDWithText:@"验证码不正确！"];
        return;
    }
    [AlertView alertViewWithTitle:@"提示" withMessage:@"请仔细检查确认银行卡号无误后再提交" withConfirmTitle:@"继续提交" withCancelTitle:@"重新确认" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *userParam = [NSMutableDictionary dictionary];
        [userParam setObject:self.bankNumberTextF.text forKey:@"bankCardNumber"];
        [userParam setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
        [NetWorking postDataWithParameters:userParam withUrl:@"updateUserInfo" withBlock:^(id result) {
            [HUDClass showHUDWithText:@"更新成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        } withFailedBlock:^(NSString *errorResult) {
        }];
    } withCancelBlock:^{
        
    }];
}

- (void)dealloc {
    [_timer invalidate];
}


@end

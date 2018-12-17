//
//  RegisterViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/15.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "RegisterViewController.h"
#import "TextAndIconCell.h"

#import "RegisterFooterView.h"

@interface RegisterViewController () <UITableViewDelegate, UITableViewDataSource>
{
}

@property (strong, nonatomic) UITableView *theTableView;
@property (nonatomic, strong) TextAndIconCell *phoneCell;
@property (nonatomic, strong) TextAndIconCell *codeCell;
@property (nonatomic, strong) TextAndIconCell *typeCell;
@property (nonatomic, strong) TextAndIconCell *passwordCell;
@property (nonatomic, strong) TextAndIconCell *prePasswordCell;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger nowCount;


@property (copy, nonatomic) NSString *securityCode;





@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBar];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)initNavBar {
    self.title = @"注册";
    if (_isBackPassword) {
        self.title = @"设置密码";
    }
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:236/255.0 alpha:1];
}

- (void)initView {
    [self initTableView];
}

- (void)initTableView {
    _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 220) style:UITableViewStylePlain];
    
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    _theTableView.scrollEnabled = NO;
    _theTableView.rowHeight = 44;
    [self.view addSubview:_theTableView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _theTableView.bottom, kDeviceWidth, 141)];
    [self.view addSubview:bgView];
    
    RegisterFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterFooterView" owner:nil options:nil] lastObject];
    footerView.frame = CGRectMake(0, 0, kDeviceWidth, 141);
    
    if (_isBackPassword) {
        _theTableView.frame = CGRectMake(10, 10, kDeviceWidth-20, 176);
        [footerView.registerBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    }
    [bgView addSubview:footerView];
    __weak typeof(self) weakSelf = self;
    footerView.registerBtnBlock = ^{
        [weakSelf registerBtnAct];
    };
}

- (void)registerBtnAct {
    [self.view endEditing:YES];

    if (_phoneCell.contentText.text.length == 0) {
        [HUDClass showHUDWithText:@"请输入手机号码！"];
        return;
    }
    
    if (_codeCell.contentText.text.length == 0) {
        [HUDClass showHUDWithText:@"请输入验证码！"];
        return;
    }
    
    if (![_codeCell.contentText.text isEqualToString:_securityCode]) {
        [HUDClass showHUDWithText:@"验证码不正确！"];
        return;
    }
    
    if (_typeCell.contentText.text.length == 0 && !_isBackPassword) {
        [HUDClass showHUDWithText:@"请选择角色！"];
        return;
    }
    
    if (_passwordCell.contentText.text.length == 0) {
        [HUDClass showHUDWithText:@"请输入密码！"];
        return;
    }
    
    if (_prePasswordCell.contentText.text.length == 0) {
        [HUDClass showHUDWithText:@"请输入密码！"];
        return;
    }
    
    if (![_prePasswordCell.contentText.text isEqualToString:_passwordCell.contentText.text]) {
        [HUDClass showHUDWithText:@"两次输入密码不一致！"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *urlStr = @"resetPassword";
    if (!_isBackPassword) {
        urlStr = @"register";
        if ([_typeCell.contentText.text isEqualToString:@"货运站点"]) {
            [param setObject:@"5" forKey:@"type"];
            
        }else{
            [param setObject:@"6" forKey:@"type"];
        }
    }
    [param setObject:_phoneCell.contentText.text forKey:@"phoneNumber"];
    [param setObject:[Utils md5:_passwordCell.contentText.text] forKey:@"password"];
    

    __weak RegisterViewController *weakSelf = self;
    
    [NetWorking loginPostDataWithParameters:param withUrl:urlStr withBlock:^(id result) {
        if (self.isBackPassword) {
            [HUDClass showHUDWithText:@"修改密码成功！"];
        }else{
            [HUDClass showHUDWithText:@"注册成功！"];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } withFailedBlock:^(NSString *errorResult) {
    }];
    
    
}


#pragma mark -------<UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak RegisterViewController *weakSelf = self;

    if (indexPath.row == 0) {
        if (_phoneCell) {
            return _phoneCell;
        }
        TextAndIconCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextAndIconCell" owner:nil options:nil] lastObject];
        _phoneCell = cell;
        cell.contentText.placeholder = @"请输入电话号码";
        cell.contentText.keyboardType = UIKeyboardTypeNumberPad;
        cell.contentTextFRight.constant = 8;
        cell.operateBtn.hidden = YES;
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e620" color:mainColor font:25];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.row == 1) {
        if (_codeCell) {
            return _codeCell;
        }
        TextAndIconCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextAndIconCell" owner:nil options:nil] lastObject];
        _codeCell = cell;
        cell.contentText.placeholder = @"请输入验证码";
        cell.contentText.keyboardType = UIKeyboardTypeNumberPad;

        cell.operateBtn.text = @"获取验证码";
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e60e" color:mainColor font:22];
        
        cell.operationBtnBlock = ^{
            
            [weakSelf sendCode];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.row == 2) {
        if (_typeCell) {
            return _typeCell;
        }
        TextAndIconCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextAndIconCell" owner:nil options:nil] lastObject];
        _typeCell = cell;
        cell.contentText.placeholder = @"请选择角色";
        cell.contentText.enabled = NO;
        cell.operateBtn.hidden = YES;
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e62a" color:mainColor font:27];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.clipsToBounds = YES;
        return cell;
    }else if (indexPath.row == 3) {
        if (_passwordCell) {
            return _passwordCell;
        }
        TextAndIconCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextAndIconCell" owner:nil options:nil] lastObject];
        _passwordCell = cell;
        cell.contentText.placeholder = @"请输入密码";
        cell.contentText.secureTextEntry = YES;
        cell.contentTextFRight.constant = 8;
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e640" color:mainColor font:26];
        [NavBgImage showIconFontForView:cell.operateBtn iconName:@"\U0000e600" color:mainColor font:25];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.operationBtnBlock = ^{
            [weakSelf operatePassWord];
        };

        return cell;
    }else if (indexPath.row == 4) {
        if (_prePasswordCell) {
            return _prePasswordCell;
        }
        TextAndIconCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextAndIconCell" owner:nil options:nil] lastObject];
        _prePasswordCell = cell;
        cell.contentText.placeholder = @"请再次输入密码";
        cell.contentTextFRight.constant = 8;
        cell.contentText.secureTextEntry = YES;
        cell.operateBtn.hidden = YES;
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e640" color:mainColor font:26];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 && _isBackPassword) {
        return 0;
    }
    
    return 44;
}


- (void)sendCode {
    [self.view endEditing:YES];

    if (![Utils correctTel:_phoneCell.contentText.text]) {
        [HUDClass showHUDWithText:@"请输入正确的手机号码！"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_phoneCell.contentText.text forKey:@"phoneNumber"];
    [param setObject:[NSString stringWithFormat:@"%@",_isBackPassword?@"1":@"0"] forKey:@"type"];

    __weak RegisterViewController *weakSelf = self;

    
    [NetWorking loginPostDataWithParameters:param withUrl:@"getCode" withBlock:^(id result) {
        weakSelf.securityCode = [result objectForKey:@"object"];
        [HUDClass showHUDWithText:@"验证码发送成功！"];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hiddenView) userInfo:nil repeats:YES];
        self.nowCount = 60;
        self.codeCell.operateBtn.userInteractionEnabled = NO;
        self.codeCell.operateBtn.text = [NSString stringWithFormat:@"%ldS",self.nowCount];
        self.codeCell.operateBtn.textColor = [UIColor grayColor];
        
    } withFailedBlock:^(NSString *errorResult) {
    }];
}

- (void)hiddenView {
    _nowCount --;
    if (_nowCount < 0) {
        [_timer invalidate];
        _codeCell.operateBtn.userInteractionEnabled = YES;
        _codeCell.operateBtn.text = @"再次发送";
        _codeCell.operateBtn.textColor = mainColor;
    }else{
        _codeCell.operateBtn.text = [NSString stringWithFormat:@"%ldS",_nowCount];
    }
}

- (void)operatePassWord {
    if (_passwordCell.isTrue) {
        [NavBgImage showIconFontForView:_passwordCell.operateBtn iconName:@"\U0000e601" color:mainColor font:25];
        _passwordCell.contentText.secureTextEntry = NO;
        _prePasswordCell.contentText.secureTextEntry = NO;

    }else{
        [NavBgImage showIconFontForView:_passwordCell.operateBtn iconName:@"\U0000e600" color:mainColor font:25];
        _passwordCell.contentText.secureTextEntry = YES;
        _prePasswordCell.contentText.secureTextEntry = YES;


    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==  2) {
        [self selectType];
    }
}

- (void)selectType {
    NSArray *titleArray = @[
                            @"货运司机"
                            ];
    __weak RegisterViewController *weakSelf = self;
    [[CustomSelectAlertView alloc] initAlertWithTitleArray:[titleArray mutableCopy] withBtnSelectBlock:^(NSInteger tagg) {
        weakSelf.typeCell.contentText.text = titleArray[tagg-1];
    }];
}




@end

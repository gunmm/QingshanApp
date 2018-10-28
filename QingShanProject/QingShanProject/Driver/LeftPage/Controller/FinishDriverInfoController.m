//
//  FinishDriverInfoController.m
//  QingShanProject
//
//  Created by gunmm on 2018/10/28.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "FinishDriverInfoController.h"
#import "DriverDeatilBtnView.h"

@interface FinishDriverInfoController ()

@property (nonatomic, strong) DriverDeatilBtnView *driverDeatilBtnView;


@end

@implementation FinishDriverInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initView {
    self.title = @"信息完善";
    self.view.backgroundColor = bgColor;
    self.tableView.tableFooterView = [UIView new];
    
    _driverDeatilBtnView = [[[NSBundle mainBundle] loadNibNamed:@"DriverDeatilBtnView" owner:nil options:nil] lastObject];
    _driverDeatilBtnView.backgroundColor = bgColor;
    
    _driverDeatilBtnView.frame = CGRectMake(0, 0, kDeviceWidth, 200);
    
    UIView *footerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    [footerBgView addSubview:_driverDeatilBtnView];
    self.tableView.tableFooterView = footerBgView;
    
    _driverDeatilBtnView.deleteBtn.hidden = YES;
    
    [_driverDeatilBtnView.changeBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;

    _driverDeatilBtnView.changeDriverBlock = ^{
        if (weakSelf.nickNameTextF.text.length == 0) {
            [HUDClass showHUDWithText:@"姓名不能为空！"];
            return;
        }
        
        if (weakSelf.idCardTextF.text.length == 0) {
            [HUDClass showHUDWithText:@"身份证号不能为空！"];
            return;
        }
        
        if (weakSelf.drivingLicenceTextF.text.length == 0) {
            [HUDClass showHUDWithText:@"驾驶证号不能为空！"];
            return;
        }
        
        [AlertView alertViewWithTitle:@"提示" withMessage:@"请确保证件号码真实有效后提交，提交后不可修改" withConfirmTitle:@"确定" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
            [param setObject:weakSelf.nickNameTextF.text forKey:@"nickname"];
            [param setObject:weakSelf.idCardTextF.text forKey:@"userIdCardNumber"];
            [param setObject:weakSelf.drivingLicenceTextF.text forKey:@"driverLicenseNumber"];
            [param setObject:weakSelf.specialTextF.text forKey:@"driverQualificationNumber"];

            
            
            [NetWorking postDataWithParameters:param withUrl:@"updateUserInfo" withBlock:^(id result) {
                [HUDClass showHUDWithText:@"信息更新成功！"];
                if (weakSelf.mainPageRefrenshUserDataBlock) {
                    weakSelf.mainPageRefrenshUserDataBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } withFailedBlock:^(NSString *errorResult) {
                
            }];
            
            
        } withCancelBlock:^{
            
        }];
    };
    
}

- (void)initData {
    if (self.userModel.nickname.length > 0) {
        _nickNameTextF.text = self.userModel.nickname;
    }
    
    if (self.userModel.userIdCardNumber.length > 0) {
        _idCardTextF.text = self.userModel.userIdCardNumber;
    }
    
    if (self.userModel.driverLicenseNumber.length > 0) {
        _drivingLicenceTextF.text = self.userModel.driverLicenseNumber;
    }
    
    if (self.userModel.driverQualificationNumber.length > 0) {
        _specialTextF.text = self.userModel.driverQualificationNumber;
    }
    
    
}





@end

//
//  DriverDetailController.m
//  QingShanProject
//
//  Created by gunmm on 2018/10/17.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverDetailController.h"
#import "ImagePreController.h"
#import "DriverDeatilBtnView.h"
#import "UserInfoRes.h"



@interface DriverDetailController ()

@property (nonatomic, strong) DriverDeatilBtnView *driverDeatilBtnView;

@end

@implementation DriverDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
}

- (void)initNavBar {
    self.title = @"司机详情";
}

- (void)initView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = bgColor;
    
    self.driverImageView.layer.cornerRadius = 6;
    self.driverImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
    [self.driverImageView addGestureRecognizer:tap];
    
    [Utils setImageWithImageView:self.driverImageView withUrl:_model.personImageUrl];
    self.driverNameLabel.text = _model.nickname;
    [self.driverPhoneBtn setTitle:_model.phoneNumber forState:UIControlStateNormal];
    self.driverIdCardLabel.text = _model.userIdCardNumber;
    self.driverLicenseLabel.text = _model.driverLicenseNumber;
    self.driverQualificationLabel.text = _model.driverQualificationNumber;
    self.driverScoreLabel.text = [NSString stringWithFormat:@"%.1f", _model.score];
    
    _driverDeatilBtnView = [[[NSBundle mainBundle] loadNibNamed:@"DriverDeatilBtnView" owner:nil options:nil] lastObject];
    _driverDeatilBtnView.backgroundColor = bgColor;
    _driverDeatilBtnView.frame = CGRectMake(0, 0, kDeviceWidth, 200);
    self.tableView.tableFooterView = _driverDeatilBtnView;
    
    [self setBtnViewData];
    
    
    __weak typeof(self) weakSelf = self;
    _driverDeatilBtnView.changeDriverBlock = ^{
        [AlertView alertViewWithTitle:@"提示" withMessage:[NSString stringWithFormat:@"确认将司机切换为：%@", weakSelf.model.nickname] withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
            if (weakSelf.refreshDriverBlock) {
                weakSelf.refreshDriverBlock();
            }
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
            [param setObject:weakSelf.model.userId forKey:@"smallDriverId"];
            [NetWorking postDataWithParameters:param withUrl:@"pointDriverForVehicle" withBlock:^(id result) {
                [HUDClass showHUDWithText:@"切换成功！"];
                [weakSelf loadData];
            } withFailedBlock:^(NSString *errorResult) {
                [HUDClass showHUDWithText:@"切换失败！请重试"];
            }];
            
            
        } withCancelBlock:^{
            
        }];
    };
    
    _driverDeatilBtnView.deleteDriverBlock = ^{
        if (weakSelf.refreshDriverBlock) {
            weakSelf.refreshDriverBlock();
        }
    };
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_model.userId forKey:@"driverId"];
    
    [NetWorking postDataWithParameters:param withUrl:@"getDriverInfoById" withBlock:^(id result) {
        UserInfoRes *userInfoRes = [UserInfoRes mj_objectWithKeyValues:result];
        self.model = userInfoRes.object;
        [self setBtnViewData];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}


- (void)setBtnViewData {
    if ([_model.vehicleBindingDriverId isEqualToString:_model.userId]) {
        _driverDeatilBtnView.changeBtn.enabled = NO;
        _driverDeatilBtnView.changeBtn.backgroundColor = [UIColor grayColor];
        [_driverDeatilBtnView.changeBtn setTitleColor:bgColor forState:UIControlStateNormal];
        [_driverDeatilBtnView.changeBtn setTitle:@"当前司机" forState:UIControlStateNormal];
    }else {
        _driverDeatilBtnView.changeBtn.enabled = YES;
        _driverDeatilBtnView.changeBtn.backgroundColor = mainColor;
        [_driverDeatilBtnView.changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_driverDeatilBtnView.changeBtn setTitle:@"切换" forState:UIControlStateNormal];
    }
    
}

//点击方法
- (void)tapImageAct:(UITapGestureRecognizer *)recognizer{
    if (_model.personImageUrl.length > 0) {
        UIImageView *imageView = (UIImageView *) recognizer.view;
        ImagePreController *imagePreController = [[ImagePreController alloc] init];
        imagePreController.imageView = imageView;
        [self.navigationController presentViewController:imagePreController animated:NO completion:nil];
    }
    
}

- (IBAction)phoneBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35)];
    view.backgroundColor = bgColor;
    
    return view;
}



@end

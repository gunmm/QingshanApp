//
//  DriverInfoController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/29.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverInfoController.h"
#import "ImageCropperController.h"
#import "CarTypeModel.h"
#import "CarTypeRes.h"
#import "WMPhotoBrowser.h"
#import "ImagePreController.h"
#import "UserInfoRes.h"
#import "BankEditController.h"

@interface DriverInfoController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImageCropperDelegate>


@property (nonatomic, copy) NSString *headImageStr;

@end

@implementation DriverInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initStrData];
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)initStrData {
    _headImageStr = @"";
}

- (void)initNavBar {
    self.title = @"个人信息";
}


- (void)initView {
    _headImageView.layer.cornerRadius = 6;
    _headImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
    [_headImageView addGestureRecognizer:tap];
    
    self.tableView.backgroundColor = bgColor;
    self.tableView.tableFooterView = [UIView new];
    
    _editBankBtn.layer.cornerRadius = 4;
    _editBankBtn.layer.masksToBounds = YES;
    _editBankBtn.layer.borderWidth = 1;
    _editBankBtn.layer.borderColor = bgColor.CGColor;
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    [NetWorking postDataWithParameters:param withUrl:@"getUserInfoById" withBlock:^(id result) {
        UserInfoRes *userInfoRes = [UserInfoRes mj_objectWithKeyValues:result];
        self.userModel = userInfoRes.object;
        [self initData];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)initData {
    _headImageStr = _userModel.personImageUrl;
    if (_headImageStr.length > 0) {
        [[Config shareConfig] setUserImage:_headImageStr];
        [Utils setImageWithImageView:_headImageView withUrl:_headImageStr];
    }
    
    _userNameTextF.text = _userModel.nickname;
    _phoneNumberTextF.text = _userModel.phoneNumber;
    _idCardTextF.text = _userModel.userIdCardNumber;
    _belongSiteTextF.text = _userModel.belongSiteName.length > 0 ? _userModel.belongSiteName : @"--";
    _scoreTextF.text = [NSString stringWithFormat:@"%.1f", _userModel.score];
    _bankCardTextF.text = _userModel.bankCardNumber;
    
    _plateNumberTextF.text = _userModel.plateNumber.length > 0 ? _userModel.plateNumber : @"--";
    _carTypeTextF.text = _userModel.vehicleTypeName.length > 0 ? _userModel.vehicleTypeName : @"--";
    _gpsTypeTextF.text = _userModel.gpsTypeName.length > 0 ? _userModel.gpsTypeName : @"--";
    _gpsNumberTextF.text = _userModel.gpsSerialNumber.length > 0 ? _userModel.gpsSerialNumber : @"--";
    
    _jiashizhengTextF.text = _userModel.driverLicenseNumber.length > 0 ? _userModel.driverLicenseNumber : @"--";
    
    _zigezhengTextF.text = _userModel.driverQualificationNumber.length > 0 ? _userModel.driverQualificationNumber : @"--";

    [[Config shareConfig] setBankCardNumber:_userModel.bankCardNumber];
    
    if ([[[Config shareConfig] getType] isEqualToString:@"5"]) {
        _plateNumberTextF.text = _userModel.mainGoodsName;
        _plateNumberKeyLabel.text = @"主营货物";
    }
   
}

//点击方法
- (void)tapImageAct:(UITapGestureRecognizer *)recognizer{
    if (_headImageStr.length > 0) {
        UIImageView *imageView = (UIImageView *) recognizer.view;
        ImagePreController *imagePreController = [[ImagePreController alloc] init];
        imagePreController.imageView = imageView;
        [self.navigationController presentViewController:imagePreController animated:NO completion:nil];
    }
    
}


//编辑银行卡
- (IBAction)editBankBtnAct:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DriverInformation" bundle:nil];
    BankEditController *bankEditController = [board instantiateViewControllerWithIdentifier:@"bank_edit"];
    bankEditController.bankNumberStr = _userModel.bankCardNumber;
    [self.navigationController pushViewController:bankEditController animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35)];
    view.backgroundColor = bgColor;
   
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self opratePhoto];
        }
    }
}

- (void)opratePhoto {
    NSArray *titleArray = @[@"拍摄", @"从手机相册选择"];
    __weak DriverInfoController *weakSelf = self;
    [[CustomSelectAlertView alloc] initAlertWithTitleArray:[titleArray mutableCopy] withBtnSelectBlock:^(NSInteger tagg) {
        if (tagg == 1) {
            [weakSelf opencamera];
        }else if(tagg == 2){
            [weakSelf openPhotoFile];
        }
    }];
}


- (void)opencamera {
    //打开相册
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    
    //设置图片来源
    pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //设置代理
    pickerC.delegate = self;
    
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (void)openPhotoFile {
    //打开相册
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    
    //设置图片来源
    pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置代理
    pickerC.delegate = self;
    
    [self presentViewController:pickerC animated:YES completion:nil];
}


//图片被选中后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //相册界面消失
    [picker dismissViewControllerAnimated:YES completion:^{
        ImageCropperController *imgCropperVC = [[ImageCropperController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
    
}

#pragma mark ImageCropperDelegate
- (void)imageCropper:(ImageCropperController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    NSString *imageStr = [Utils image2Base64:editedImage];
    if (!(imageStr.length > 0)) {
        [HUDClass showHUDWithText:@"操作图像失败，请重试！"];
        [cropperViewController dismissViewControllerAnimated:YES completion:^{
        }];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:imageStr forKey:@"imgStr"];
    
    [NetWorking postDataWithParameters:param withUrl:@"uploadImage" withBlock:^(id result) {
        NSString *imgstr = [result objectForKey:@"object"];
        NSMutableDictionary *userParam = [NSMutableDictionary dictionary];
        [userParam setObject:imgstr forKey:@"personImageUrl"];
        [userParam setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
        [NetWorking postDataWithParameters:userParam withUrl:@"updateUserInfo" withBlock:^(id result) {
            self.headImageView.image = editedImage;
            self.headImageStr = imgstr;
            [[Config shareConfig] setUserImage:imgstr];
            [HUDClass showHUDWithText:@"图像修改成功！"];
        } withFailedBlock:^(NSString *errorResult) {
            self.headImageStr = self.userModel.personImageUrl;
        }];
    } withFailedBlock:^(NSString *errorResult) {
    }];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imageCropperDidCancel:(ImageCropperController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[Config shareConfig] getType] isEqualToString:@"5"]) {
        if (section == 1) {
            return 1;
        }
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8) && [[[Config shareConfig] getType] isEqualToString:@"5"]) {
        return 0;
    }else if (indexPath.section == 0 && indexPath.row == 8 && [[[Config shareConfig] getDriverType] isEqualToString:@"2"]) {
        return 0;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}



@end

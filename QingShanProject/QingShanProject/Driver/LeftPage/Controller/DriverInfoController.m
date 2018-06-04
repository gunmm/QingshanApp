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

@interface DriverInfoController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImageCropperDelegate>


@property (nonatomic, copy) NSString *imageType;
@property (nonatomic, copy) NSString *headImageStr;
@property (nonatomic, copy) NSString *card1ImageStr;
@property (nonatomic, copy) NSString *card2ImageStr;
@property (nonatomic, copy) NSString *card3ImageStr;

@property (nonatomic, strong) NSArray *carTypeList;
@property (nonatomic, strong) NSMutableArray *carTypeListTitle;

@property (nonatomic, copy) NSString *carTypeValueStr;






@end

@implementation DriverInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initStrData];
    [self initView];
    [self loadDictionaryData];
}

- (void)initStrData {
    _headImageStr = @"";
    _card1ImageStr = @"";
    _card2ImageStr = @"";
    _card3ImageStr = @"";
    _carTypeValueStr = @"";

}

- (void)initNavBar {
    self.title = @"编辑资料";
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClicked)];
    [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:saveBtn];
}

- (void)saveBtnClicked {
    if (_nickNameTextF.text.length == 0) {
        [HUDClass showHUDWithText:@"姓名不能为空！"];
        return;
    }
    
    if ([[[Config shareConfig] getType] isEqualToString:@"2"]) {
        if (_carTypeTextF.text.length == 0) {
            [HUDClass showHUDWithText:@"车辆不能为空！"];
            return;
        }
        
        if (_plateNumberTextF.text.length == 0) {
            [HUDClass showHUDWithText:@"车牌号不能为空！"];
            return;
        }
        
        if (_card1ImageStr.length == 0) {
            [HUDClass showHUDWithText:@"驾驶证不能为空！"];
            return;
        }
        
        if (_card2ImageStr.length == 0) {
            [HUDClass showHUDWithText:@"行驶证不能为空！"];
            return;
        }
        
        if (_card3ImageStr.length == 0) {
            [HUDClass showHUDWithText:@"其他证不能为空！"];
            return;
        }
    }
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [param setObject:_headImageStr forKey:@"personImageUrl"];
    [param setObject:_nickNameTextF.text forKey:@"nickname"];
    if ([[[Config shareConfig] getType] isEqualToString:@"2"]) {
        [param setObject:_carTypeValueStr forKey:@"vehicleType"];
        [param setObject:_plateNumberTextF.text forKey:@"plateNumber"];
        [param setObject:_card1ImageStr forKey:@"driverLicenseImageUrl"];
        [param setObject:_card2ImageStr forKey:@"driverVehicleImageUrl"];
        [param setObject:_card3ImageStr forKey:@"driverThirdImageUrl"];
    }
    
    [NetWorking postDataWithParameters:param withUrl:@"updateUserInfo" withBlock:^(id result) {
        [HUDClass showHUDWithText:@"资料更新成功！"];
        if (self.infoEditBlock) {
            self.infoEditBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
    
    
    
    
}

- (void)initView {
    _headImageView.layer.cornerRadius = 6;
    _headImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
    [_headImageView addGestureRecognizer:tap];
    
    _card1ImageView.layer.cornerRadius = 4;
    _card1ImageView.layer.masksToBounds = YES;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
    [_card1ImageView addGestureRecognizer:tap];
    
    _card2ImageView.layer.cornerRadius = 4;
    _card2ImageView.layer.masksToBounds = YES;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
    [_card2ImageView addGestureRecognizer:tap];
    
    _card3ImageView.layer.cornerRadius = 4;
    _card3ImageView.layer.masksToBounds = YES;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
    [_card3ImageView addGestureRecognizer:tap];
    
    _carTypeTextF.enabled = NO;

    self.tableView.backgroundColor = bgColor;
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)initData {
    if (_userModel.nickname.length > 0) {
        _nickNameTextF.text = _userModel.nickname;
    }
    
    if (_userModel.vehicleType.length > 0) {
        _carTypeValueStr = _userModel.vehicleType;
        for (CarTypeModel *model in self.carTypeList) {
            if ([model.keyText isEqualToString:_userModel.vehicleType]) {
                _carTypeTextF.text = model.desc;
            }
        }
    }
    
    if (_userModel.plateNumber.length > 0) {
        _plateNumberTextF.text = _userModel.plateNumber;
    }
    
    if (_userModel.personImageUrl.length > 0) {
        [Utils setImageWithImageView:_headImageView withUrl:_userModel.personImageUrl];
        _headImageStr = _userModel.personImageUrl;
    }
    
    if (_userModel.driverLicenseImageUrl.length > 0) {
        [Utils setImageWithImageView:_card1ImageView withUrl:_userModel.driverLicenseImageUrl];

        _card1ImageStr = _userModel.driverLicenseImageUrl;
    }
    
    if (_userModel.driverVehicleImageUrl.length > 0) {
        [Utils setImageWithImageView:_card2ImageView withUrl:_userModel.driverVehicleImageUrl];

        _card2ImageStr = _userModel.driverVehicleImageUrl;
    }
    
    if (_userModel.driverThirdImageUrl.length > 0) {
        [Utils setImageWithImageView:_card3ImageView withUrl:_userModel.driverThirdImageUrl];

        _card3ImageStr = _userModel.driverThirdImageUrl;
    }
}

- (void)loadDictionaryData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"车辆类型" forKey:@"name"];
    
    [NetWorking bgPostDataWithParameters:param withUrl:@"getDictionaryList" withBlock:^(id result) {
        [CarTypeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"desc" : @"description",
                     };
        }];
        [CarTypeRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"CarTypeModel",
                     };
        }];
        CarTypeRes *carTypeRes = [CarTypeRes mj_objectWithKeyValues:result];
        self.carTypeList = carTypeRes.object;
        self.carTypeListTitle = [NSMutableArray array];
        for (CarTypeModel *model in self.carTypeList) {
            [self.carTypeListTitle addObject:model.desc];
        }
        
        [self initData];
    } withFailedBlock:^(NSString *errorResult) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
   
}

//点击方法
- (void)tapImageAct:(UITapGestureRecognizer *)recognizer{
    UIImageView *imageView = (UIImageView *) recognizer.view;
    ImagePreController *imagePreController = [[ImagePreController alloc] init];
    imagePreController.imageView = imageView;
    [self.navigationController presentViewController:imagePreController animated:NO completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35)];
    view.backgroundColor = bgColor;
   
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _imageType = @"1";
            [self opratePhoto];
        }else if (indexPath.row == 2) {
            __weak DriverInfoController *weakSelf = self;
            [[CustomSelectAlertView alloc] initAlertWithTitleArray:self.carTypeListTitle withBtnSelectBlock:^(NSInteger tagg) {
                weakSelf.carTypeTextF.text = weakSelf.carTypeListTitle[tagg-1];
                CarTypeModel *model = weakSelf.carTypeList[tagg-1];
                weakSelf.carTypeValueStr = model.keyText;
            }];
        }
    }else {
        if(![_userModel.driverCertificationStatus isEqualToString:@"2"]){
            if (indexPath.row == 0) {
                _imageType = @"2";
                [self opratePhoto];
            }else if (indexPath.row == 1) {
                _imageType = @"3";
                [self opratePhoto];
            }else if (indexPath.row == 2) {
                _imageType = @"4";
                [self opratePhoto];
            }
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
    if ([_imageType isEqualToString:@"1"]){
        //相册界面消失
        [picker dismissViewControllerAnimated:YES completion:^{
            ImageCropperController *imgCropperVC = [[ImageCropperController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
            imgCropperVC.delegate = self;
            [self presentViewController:imgCropperVC animated:YES completion:^{
                // TO DO
            }];
        }];
    }else{
        NSString *imageStr = [Utils image2Base64:image];
        if (!(imageStr.length > 0)) {
            [HUDClass showHUDWithText:@"操作图像失败，请重试！"];
            [picker dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:imageStr forKey:@"imgStr"];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            if ([self.imageType isEqualToString:@"2"]) {
                
                [NetWorking postDataWithParameters:param withUrl:@"uploadImage" withBlock:^(id result) {
                    NSString *imgstr = [result objectForKey:@"object"];
                    self.card1ImageView.image = image;
                    self.card1ImageStr = imgstr;
                } withFailedBlock:^(NSString *errorResult) {
                }];
                
            }else if ([self.imageType isEqualToString:@"3"]){
                [NetWorking postDataWithParameters:param withUrl:@"uploadImage" withBlock:^(id result) {
                    NSString *imgstr = [result objectForKey:@"object"];
                    self.card2ImageView.image = image;
                    self.card2ImageStr = imgstr;
                } withFailedBlock:^(NSString *errorResult) {
                }];
            }else if ([self.imageType isEqualToString:@"4"]){
                [NetWorking postDataWithParameters:param withUrl:@"uploadImage" withBlock:^(id result) {
                    NSString *imgstr = [result objectForKey:@"object"];
                    self.card3ImageView.image = image;
                    self.card3ImageStr = imgstr;
                } withFailedBlock:^(NSString *errorResult) {
                }];
            }
        }];
    }
    
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
        self.headImageView.image = editedImage;
        self.headImageStr = imgstr;
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
    if ([[[Config shareConfig] getType] isEqualToString:@"2"]) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[Config shareConfig] getType] isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 2 || indexPath.row == 3) {
                return 0;
            }
        }
    }
    
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}



@end

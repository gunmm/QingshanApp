//
//  DriverDetailController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/31.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverDetailController.h"
#import "DriverInfoController.h"
#import "UserInfoRes.h"
#import "DetailInfoHeaderView.h"
#import "ImagePreController.h"


@interface DriverDetailController ()
{
    
}

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) DetailInfoHeaderView *headView;





@end

@implementation DriverDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initNavBar];
//    [self initView];
//    [self loadData];
}


//- (void)initNavBar {
//    self.title = @"个人资料";
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked)];
//    [editBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
//    [self.navigationItem setRightBarButtonItem:editBtn];
//}
//
//- (void)editBtnClicked {
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DriverInformation" bundle:nil];
//    DriverInfoController *driverInfoController = [board instantiateViewControllerWithIdentifier:@"driver_info"];
//    driverInfoController.userModel = _userModel;
//    [self.navigationController pushViewController:driverInfoController animated:YES];
//    
//    __weak typeof(self) weakSelf = self;
//    driverInfoController.infoEditBlock = ^{
//        [weakSelf loadData];
//    };
//}
//
//- (void)loadData {
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
//    
//    [NetWorking postDataWithParameters:param withUrl:@"getUserInfoById" withBlock:^(id result) {
//        UserInfoRes *userInfoRes = [UserInfoRes mj_objectWithKeyValues:result];
//        self.userModel = userInfoRes.object;
//        [[Config shareConfig] setName:userInfoRes.object.nickname];
//        [[Config shareConfig] setUserImage:userInfoRes.object.personImageUrl];
//        [self setDataWithModel];
//    } withFailedBlock:^(NSString *errorResult) {
//        
//    }];
//    
//}
//
//
//- (void)setDataWithModel {
//    _plateLabel.text = _userModel.plateNumber;
//    [Utils setImageWithImageView:_card1Image withUrl:_userModel.driverLicenseImageUrl];
//    [Utils setImageWithImageView:_card2Image withUrl:_userModel.driverVehicleImageUrl];
//    [Utils setImageWithImageView:_card3Image withUrl:_userModel.driverThirdImageUrl];
//    
//    
//    [Utils setImageWithImageView:_headView.headImgV withUrl:_userModel.personImageUrl];
//
//    
//    _headView.nickNameLabel.text = _userModel.nickname;
//    
//    if ([[[Config shareConfig] getType] isEqualToString:@"2"]) {
//        _headView.carTypeLabel.text = _userModel.carTypeName;
//        
//        if ([_userModel.driverCertificationStatus isEqualToString:@"0"]) {
//            _headView.renzhengStatusLabel.textColor = [UIColor redColor];
//            _headView.renzhengStatusLabel.text = @"未认证";
//        }else if ([_userModel.driverCertificationStatus isEqualToString:@"1"]) {
//            _headView.renzhengStatusLabel.textColor = [UIColor redColor];
//            _headView.renzhengStatusLabel.text = @"认证中，系统会在一个工作日内完成认证";
//        }else if ([_userModel.driverCertificationStatus isEqualToString:@"2"]) {
//            _headView.renzhengStatusLabel.textColor = [UIColor greenColor];
//            _headView.renzhengStatusLabel.text = @"认证通过";
//            
//        }else if ([_userModel.driverCertificationStatus isEqualToString:@"9"]) {
//            _headView.renzhengStatusLabel.textColor = [UIColor redColor];
//            _headView.renzhengStatusLabel.text = @"认证未通过，请重新上传资料";
//            
//        }
//
//    }
//
//    
//
//}
//
//
//- (void)initView {
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 263)];
//    bgView.backgroundColor = [UIColor redColor];
//    _headView = [[[NSBundle mainBundle] loadNibNamed:@"DetailInfoHeaderView" owner:nil options:nil] lastObject];
//    _headView.frame = CGRectMake(0, 0, kDeviceWidth, 263);
//    [bgView addSubview:_headView];
//    self.tableView.tableHeaderView = bgView;
//    self.tableView.tableFooterView = [UIView new];
//    _card1Image.layer.cornerRadius =2;
//    _card1Image.layer.masksToBounds = YES;
//    
//    _card2Image.layer.cornerRadius =2;
//    _card2Image.layer.masksToBounds = YES;
//    
//    _card3Image.layer.cornerRadius =2;
//    _card3Image.layer.masksToBounds = YES;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
//    [_headView.headImgV addGestureRecognizer:tap];
//    
//    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
//    [_card1Image addGestureRecognizer:tap];
//    
//    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
//    [_card2Image addGestureRecognizer:tap];
//    
//    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAct:)];
//    [_card3Image addGestureRecognizer:tap];
//    
//    if ([[Config shareConfig] getUserImage].length > 0) {
//        [_headView.headImgV sd_setImageWithURL:[NSURL URLWithString:[[Config shareConfig] getUserImage]] placeholderImage:[UIImage imageNamed:@"slidmain_user_head.png"] options:SDWebImageAllowInvalidSSLCertificates];
//    }
//    
//    if ([[Config shareConfig] getName].length > 0) {
//        _headView.nickNameLabel.text = [[Config shareConfig] getName];
//    }
//    
//}
//
////点击方法
//- (void)tapImageAct:(UITapGestureRecognizer *)recognizer{
//    UIImageView *imageView = (UIImageView *) recognizer.view;
//    ImagePreController *imagePreController = [[ImagePreController alloc] init];
//    imagePreController.imageView = imageView;
//    [self.navigationController presentViewController:imagePreController animated:NO completion:nil];
//}
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([[[Config shareConfig] getType] isEqualToString:@"2"]) {
//        return 1;
//    }
//    return 0;
//}

@end

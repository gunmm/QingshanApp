//
//  DriverMainPageController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverMainPageController.h"
#import "UserInfoRes.h"
#import "UserModel.h"
#import "OrderModel.h"
#import "OrderListRes.h"
#import "DriverOrderListCell.h"
#import "Location.h"
#import "MessageBtn.h"
#import "MessageListController.h"
#import "DriverOrderDetailController.h"
#import "FinishDriverInfoController.h"
#import "UMShareUtils.h"

@interface DriverMainPageController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) UIButton *workBtn;

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray <OrderModel *> *dataList;

@property (nonatomic, strong) NotHaveDataView *notHaveView;

@property (nonatomic, assign) NSInteger currentpage;
@property (nonatomic, assign) double lastLatitude;
@property (nonatomic, assign) double lastLongitude;
@property (nonatomic, assign) NSInteger numberCount;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIView *redView;








@end

@implementation DriverMainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self loadAgreementData];
    [self loadUserData];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithAppear];
    [self queryMessageCount];
}



- (void)initNavBar {

    _workBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 70, 30)];
    [_workBtn setTitle:@"开始接单" forState:UIControlStateNormal];
    _workBtn.layer.cornerRadius = 2;
    _workBtn.layer.masksToBounds = YES;
    _workBtn.layer.borderWidth = 0.5;
    _workBtn.layer.borderColor = mainColor.CGColor;
    [_workBtn setTitleColor:mainColor forState:UIControlStateNormal];
    _workBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _workBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_workBtn addTarget:self action:@selector(workBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    view.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = _workBtn;
    self.title = @"执行中";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化按钮
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [NavBgImage showIconFontForView:personBtn iconName:@"\U0000e62f" color:mainColor font:25];

    [personBtn addTarget:self action:@selector(personAct) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *personItem = [[UIBarButtonItem alloc] initWithCustomView:personBtn];
    self.navigationItem.leftBarButtonItem = personItem;
    
    

    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [NavBgImage showIconFontForView:_messageBtn iconName:@"\U0000e617" color:mainColor font:25];
    
    
    _redView = [[UIView alloc] initWithFrame:CGRectMake(22, 7, 6, 6)];
    _redView.layer.cornerRadius = 3;
    _redView.layer.masksToBounds = YES;
    _redView.backgroundColor = [UIColor redColor];
    _redView.hidden = YES;
    [_messageBtn addSubview:_redView];
    
    [_messageBtn addTarget:self action:@selector(messageAct) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:_messageBtn];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [NavBgImage showIconFontForView:shareBtn iconName:@"\U0000e63f" color:mainColor font:23];
    
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    self.navigationItem.rightBarButtonItems = @[shareItem, messageItem];

}

- (void)shareBtnClicked {
    [[UMShareUtils shareConfig] shareWeb];
}


- (void)messageAct {
    MessageListController *messageListController = [[MessageListController alloc] init];
    [self.navigationController pushViewController:messageListController animated:YES];
}

- (void)personAct {
    if (self.driverMainPageShowLeft) {
        self.driverMainPageShowLeft();
    }
}

- (void)workBtnClicked {
    //w弹出完善信息页面
    [self pushAddInfoPage];
    __weak typeof(self) weakSelf = self;

    if (_userModel.superDriver.length == 0 && [_userModel.driverType isEqualToString:@"2"]) {
        [AlertView alertViewWithTitle:@"提示" withMessage:@"绑定已在站点注册车主的车辆后方可接单" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
            [weakSelf loadUserData];
        }];
        return;
    }
    if ([_workBtn.titleLabel.text isEqualToString:@"开始接单"]) {
        [AlertView alertViewWithTitle:@"确认开始接单" withMessage:@"开始接单后，附近有新的订单将会推送到您的手机" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
            [self updateDriverStatusWithStatus:@"0"];

        } withCancelBlock:^{
            
        }];
      
    }else if ([_workBtn.titleLabel.text isEqualToString:@"停止接单"]) {
        [AlertView alertViewWithTitle:@"确认停止接单" withMessage:@"停止接单后，您将不会收到新订单推送" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
            [self updateDriverStatusWithStatus:@"2"];

        } withCancelBlock:^{
            
        }];
        
    }
}

- (void)updateDriverStatusWithStatus:(NSString *)status {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [param setObject:status forKey:@"status"];

    
    [NetWorking postDataWithParameters:param withUrl:@"operateWork" withBlock:^(id result) {
        if ([status isEqualToString:@"0"]) {
            [self.workBtn setTitle:@"停止接单" forState:UIControlStateNormal];
            self.workBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [self.workBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [HUDClass showHUDWithText:@"开始接单操作成功！"];

        }else if ([status isEqualToString:@"2"]) {
            [self.workBtn setTitle:@"开始接单" forState:UIControlStateNormal];
            self.workBtn.layer.borderColor = mainColor.CGColor;
            [self.workBtn setTitleColor:mainColor forState:UIControlStateNormal];
            [HUDClass showHUDWithText:@"停止接单操作成功！"];

        }
        NSLog(@"");
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)queryMessageCount {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    [NetWorking bgPostDataWithParameters:param withUrl:@"queryUnreadMessageCount" withBlock:^(id result) {
        if ([[result objectForKey:@"object"] isEqualToString:@"0"]) {
            self.redView.hidden = YES;
        }else{
            self.redView.hidden = NO;
        }
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)loadUserData {
    _workBtn.hidden = YES;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    [NetWorking postDataWithParameters:param withUrl:@"getUserInfoById" withBlock:^(id result) {
        UserInfoRes *userInfoRes = [UserInfoRes mj_objectWithKeyValues:result];
        self.userModel = userInfoRes.object;
        [self setDataWithModel];
        self.workBtn.hidden = NO;
        [[Config shareConfig] setName:self.userModel.nickname];
        [[Config shareConfig] setUserImage:self.userModel.personImageUrl];
        
         //w弹出完善信息页面
        [self pushAddInfoPage];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)pushAddInfoPage {
    __weak typeof(self) weakSelf = self;

    if ([_userModel.driverType isEqualToString:@"2"]) {
        if (_userModel.nickname.length == 0 || _userModel.userIdCardNumber.length == 0 || _userModel.driverLicenseNumber.length == 0) {
            [AlertView alertViewWithTitle:@"提示" withMessage:@"信息未完善，前往完善" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"DriverInformation" bundle:nil];
                FinishDriverInfoController *finishDriverInfoController = [board instantiateViewControllerWithIdentifier:@"finish_driver_info"];
                finishDriverInfoController.userModel = self.userModel;
                [self.navigationController pushViewController:finishDriverInfoController animated:YES];
                
                finishDriverInfoController.mainPageRefrenshUserDataBlock = ^{
                    [weakSelf loadUserData];
                };
            }];
            return;
        }
        
    }
}

- (void)loadAgreementData {
    [NetWorking bgPostDataWithParameters:@{} withUrl:@"orderAgreement" withBlock:^(id result) {
        NSDictionary *object = [result objectForKey:@"object"];
        NSString *driverAgreement = [object objectForKey:@"driverAgreement"];
        NSString *servicePhone = [object objectForKey:@"servicePhone"];

        [[Config shareConfig] setDriverAgreement:driverAgreement];
        [[Config shareConfig] setServicePhone:servicePhone];

    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)setDataWithModel {

    if ([_userModel.status isEqualToString:@"2"] || [_userModel.status isEqualToString:@"3"]) {
        [_workBtn setTitle:@"开始接单" forState:UIControlStateNormal];
        _workBtn.layer.borderColor = mainColor.CGColor;
        [_workBtn setTitleColor:mainColor forState:UIControlStateNormal];
//        [[Location sharedLocation] stopLocationService];


    }else {
        [_workBtn setTitle:@"停止接单" forState:UIControlStateNormal];
        _workBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [_workBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [[Location sharedLocation] startLocationService];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationComplete:)
//                                                     name:Location_Complete object:nil];

    }

}

- (void)initData {
    _currentpage = 0;
}

- (void)loadDataWithAppear {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [param setObject:@" and (`order`.status = '1' or `order`.status = '2' or `order`.status = '3') " forKey:@"condition"];

    [param setObject:@"0" forKey:@"page"];
    [param setObject:[NSString stringWithFormat:@"%ld",(_currentpage + 1)*10] forKey:@"rows"];
    
    
    [NetWorking postDataWithParameters:param withUrl:@"getDriverOrderList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        
        [OrderListRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"OrderModel",
                     };
        }];
        OrderListRes *orderListRes = [OrderListRes mj_objectWithKeyValues:result];
        self.dataList = [orderListRes.object mutableCopy];

        
        if (self.dataList.count > 0) {
            [self.notHaveView removeFromSuperview];
        }else{
            [self.notHaveView removeFromSuperview];
            self.notHaveView = [[NotHaveDataView alloc] init];
            self.notHaveView.contentLabel.text = @"暂无订单";
            [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e61f" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
            self.notHaveView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT);
            
            [self.theTableView addSubview:self.notHaveView];
        }
        
        
        [self.theTableView reloadData];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)loadDataWithType:(NSString *)loadType {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [param setObject:@" and (`order`.status = '1' or `order`.status = '2' or `order`.status = '3') " forKey:@"condition"];

    [param setObject:[NSString stringWithFormat:@"%ld",_currentpage] forKey:@"page"];
    [param setObject:@"10" forKey:@"rows"];
    
    [NetWorking postDataWithParameters:param withUrl:@"getDriverOrderList" withBlock:^(id result) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        
        [OrderListRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"OrderModel",
                     };
        }];
        OrderListRes *orderListRes = [OrderListRes mj_objectWithKeyValues:result];
        if ([loadType isEqualToString:@"1"]) {
            self.dataList = [orderListRes.object mutableCopy];
        }else {
            if ((orderListRes.object.count > 0)) {
                [self.dataList addObjectsFromArray:orderListRes.object];
            }else{
                [HUDClass showHUDWithText:@"没有更多数据！"];
            }
        }
        
        if (self.dataList.count > 0) {
            [self.notHaveView removeFromSuperview];
        }else{
            [self.notHaveView removeFromSuperview];
            self.notHaveView = [[NotHaveDataView alloc] init];
            self.notHaveView.contentLabel.text = @"暂无订单";
            [NavBgImage showIconFontForView:self.notHaveView.iconLabel iconName:@"\U0000e61f" color:[UIColor colorWithRed:66/255.0 green:67/255.0 blue:81/255.0 alpha:0.7] font:60];
            self.notHaveView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT);

            [self.theTableView addSubview:self.notHaveView];
        }
        
        [self.theTableView reloadData];
        
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}



- (void)initView {
    [self initTableView];

}

- (void)initTableView {
    _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - STATUS_AND_NAVBAR_HEIGHT) style:UITableViewStylePlain];
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    _theTableView.tableFooterView = [UIView new];
    _theTableView.estimatedRowHeight = 0;
    [self.view addSubview:_theTableView];
    
    __weak typeof(self) weakSelf = self;
    _theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentpage = 0;
        [weakSelf performSelector:@selector(loadDataWithType:) withObject:@"1" afterDelay:1];
    }];
    
    _theTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentpage++;
        [weakSelf performSelector:@selector(loadDataWithType:) withObject:@"2" afterDelay:1];
    }];
    
}

#pragma mark -------<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DriverOrderListCell";
    DriverOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverOrderListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    __weak typeof(self) weakSelf = self;

    
    cell.beginAppointOrderBlock = ^(OrderModel *model) {
        [weakSelf beginAppointOrderWithModel:model];
    };
    
    
    cell.reciverGoodsBlock = ^(OrderModel *model) {
        [weakSelf updateOrderWithModel:model withStatus:@"3"];
    };
    
    cell.finishOrderBlock = ^(OrderModel *model) {
        [weakSelf updateOrderWithModel:model withStatus:@"4"];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = _dataList[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
        if ([model.status isEqualToString:@"1"]) {
            return 120;
        }
        return 200;
    }
    if ([model.status isEqualToString:@"1"]) {
        return 146;
    }
    return 226;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DriverOrderDetailController *driverOrderDetailController = [[DriverOrderDetailController alloc] init];
    driverOrderDetailController.orderId = _dataList[indexPath.row].orderId;
    [self.navigationController pushViewController:driverOrderDetailController animated:YES];
    
}


- (void)beginAppointOrderWithModel:(OrderModel *)model {
    [AlertView alertViewWithTitle:@"提示" withMessage:@"确认开始执行该预约订单" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
        [param setObject:model.orderId forKey:@"orderId"];
        
        [NetWorking postDataWithParameters:param withUrl:@"setAppointOrderBegin" withBlock:^(id result) {
            [self loadDataWithAppear];
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}


- (void)updateOrderWithModel:(OrderModel *)model withStatus:(NSString *)status {
    
    [AlertView alertViewWithTitle:@"提示" withMessage:[NSString stringWithFormat:@"%@", [status isEqualToString:@"2"] ? @"确认接到货物" : @"确认订单完成"] withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:model.orderId forKey:@"orderId"];
        [param setObject:status forKey:@"status"];
        
        [NetWorking postDataWithParameters:param withUrl:@"updateOrderStatus" withBlock:^(id result) {
            [self loadDataWithAppear];
            
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}



#pragma mark - 定位完成

- (void)onLocationComplete:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    
    if (!userInfo) {
        NSLog(@"定位失败");
        return;
    }
    
    CLLocation *userLocation = userInfo[User_Location];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    NSDictionary *bmLoc = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D bdCoor = BMKCoorDictionaryDecode(bmLoc);
    
//    NSLog(@"*****lat:%f, *****lng:%f", bdCoor.latitude, bdCoor.longitude);
    
    if (_lastLatitude == bdCoor.latitude && _lastLongitude == bdCoor.longitude) {
        return;
    }else{
        _lastLatitude = bdCoor.latitude;
        _lastLongitude = bdCoor.longitude;
    }
    
    _numberCount ++;
    if (_numberCount >= 5) {
        _numberCount = 0;
    }else{
        return;
    }
    
    
    NSLog(@"上传了--------lat:%f, ---------lng:%f", bdCoor.latitude, bdCoor.longitude);

    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    [param setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    [param setObject:[NSNumber numberWithDouble:bdCoor.latitude] forKey:@"nowLatitude"];
    [param setObject:[NSNumber numberWithDouble:bdCoor.longitude] forKey:@"nowLongitude"];

    [NetWorking bgPostDataWithParameters:param withUrl:@"updateLocation" withBlock:^(id result) {

    } withFailedBlock:^(NSString *errorResult) {

    }];
  
}



- (void)dealloc
{
    //取消接收定位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}




@end

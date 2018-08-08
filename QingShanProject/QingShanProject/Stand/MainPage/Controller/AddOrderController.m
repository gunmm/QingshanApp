//
//  AddOrderController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "AddOrderController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "CustomSelectView.h"
#import "SelectTableViewCell.h"
#import "TextTableViewCell.h"
#import "OrderConfirmView.h"
#import "CarTypeModel.h"
#import "CarTypeRes.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "CustomIOS7AlertView.h"
#import "PriceDeatilView.h"
#import "PayDetailView.h"
#import "TouchScrollView.h"
#import "InvoiceDetailView.h"




@interface AddOrderController () <BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDelegate, UITableViewDataSource, CustomSelectViewDelegate, BMKRouteSearchDelegate>
{
    BMKLocationService *_locService;
    MBProgressHUD *hud;
}

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) BMKRouteSearch *routeSearch;

@property (strong, nonatomic) TouchScrollView *bgScrollView;

@property (strong, nonatomic) UITableView *theTableView;
@property (nonatomic, strong) CustomSelectView *customSelectView;

@property (nonatomic, strong) SelectTableViewCell *appointTimeCell;
@property (nonatomic, strong) SelectTableViewCell *typeSelectCell;
@property (nonatomic, strong) TextTableViewCell *nameCell;
@property (nonatomic, strong) TextTableViewCell *phoneCell;
@property (nonatomic, strong) TextTableViewCell *remarkCell;


@property (nonatomic, strong) OrderConfirmView *confirmView;

@property (nonatomic, strong) NSArray *carTypeList;
@property (nonatomic, strong) NSMutableArray *carTypeListTitle;

@property (nonatomic, copy) NSString *carTypeValueStr;
@property (nonatomic, assign) double starDistance;
@property (nonatomic, assign) double starPrice;
@property (nonatomic, assign) double unitPrice;
@property (strong, nonatomic) CustomIOS7AlertView *customIOS7AlertView;





@property (nonatomic, strong) BMKDrivingRouteLine *routeLine;

@property (nonatomic, strong) NSDictionary *invoiceParam;















@end

@implementation AddOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDictionaryData];
    [self initNavBar];
    [self initView];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _locService.delegate = self;
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    _mapView.delegate = nil;
    _routeSearch.delegate = nil;

}

- (void)loadDictionaryData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"车辆类型" forKey:@"name"];
    
    
    [NetWorking postDataWithParameters:param withUrl:@"getDictionaryList" withBlock:^(id result) {
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
        
        if (self.typeSelectCell) {
            self.typeSelectCell.contentLabel.text = self.carTypeListTitle[0];
            CarTypeModel *model = self.carTypeList[0];
            self.carTypeValueStr = model.keyText;
            self.starDistance = model.startDistance;
            self.starPrice = model.startPrice;
            self.unitPrice = model.unitPrice;
        }
        [self routePlan];

    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}


- (void)initNavBar {
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (IS_IPHONE_5_8 ? 44 : 20)+5, 34, 34)];
    [backBtn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAct) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/2-50, IS_IPHONE_5_8 ? 44 : 20, 100, 44)];
    titleLabel.text = @"下单";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    UIView *divisionView = [[UIView alloc]initWithFrame:CGRectMake(0, (IS_IPHONE_5_8 ? 44 : 20)+45, kDeviceWidth, 0.5)];
    divisionView.backgroundColor = devide_line_color;
    [self.view addSubview:divisionView];
}

- (void)backAct {
    if (self.backDismissBlock) {
        self.backDismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)initView {
    [self initScrollView];
    [self initMap];
    [self initTableView];
    [self initConfirmView];
}

- (void)initScrollView {
    _bgScrollView = [[TouchScrollView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAVBAR_HEIGHT+2, kDeviceWidth, kDeviceHeight - STATUS_AND_NAVBAR_HEIGHT - 2)];
    _bgScrollView.backgroundColor = bgColor;
    _bgScrollView.bounces = NO;
    if (_bgScrollView.height < (200 + 10 + 44*(_isNow?4:5) + 146 + 20)) {
        _bgScrollView.contentSize = CGSizeMake(kDeviceWidth, 200 + 10 + 44*(_isNow?4:5) + 146 + 20);
    }else{
        _bgScrollView.contentSize = CGSizeMake(kDeviceWidth, _bgScrollView.height);
    }
    [self.view addSubview:_bgScrollView];
}

- (void)initConfirmView {
    _confirmView = [[[NSBundle mainBundle] loadNibNamed:@"OrderConfirmView" owner:nil options:nil] lastObject];
    _confirmView.frame = CGRectMake(10, _theTableView.bottom, kDeviceWidth-20, 146);
    [_bgScrollView addSubview:_confirmView];
    
    
    __weak typeof(self) weakSelf = self;
    _confirmView.confirmBlock = ^{
        [weakSelf confirmAct];
    };
    
    _confirmView.priceDetailBtnBlock = ^{
        PriceDeatilView *priceDetailView = [[[NSBundle mainBundle] loadNibNamed:@"PriceDeatilView" owner:nil options:nil] lastObject];
        priceDetailView.frame = CGRectMake(0, 0, kDeviceWidth, 269);
        priceDetailView.carTypeList = weakSelf.carTypeList;
        priceDetailView.carTypeValueStr = weakSelf.carTypeValueStr;
        priceDetailView.routeLine = weakSelf.routeLine;
        priceDetailView.closeBtnActBlock = ^{
            [weakSelf.customIOS7AlertView close];
        };
        weakSelf.customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        [weakSelf.customIOS7AlertView setButtonTitles:nil];
        [weakSelf.customIOS7AlertView setContainerView:priceDetailView];
        [weakSelf.customIOS7AlertView showFromBottom];
    };
    
    
    _confirmView.invoiceBtnBlock = ^(NSString *selectType) {
        if ([selectType isEqualToString:@"0"]) {
            [AlertView alertViewWithTitle:@"提示" withMessage:@"需要发票 则\n必须预先线上支付运输费用" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
                InvoiceDetailView *invoiceDetailView = [[[NSBundle mainBundle] loadNibNamed:@"InvoiceDetailView" owner:nil options:nil] lastObject];
                invoiceDetailView.frame = CGRectMake(0, 0, kDeviceWidth, 355);
                weakSelf.customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                weakSelf.customIOS7AlertView.tapClose = NO;
                [weakSelf.customIOS7AlertView setButtonTitles:nil];
                [weakSelf.customIOS7AlertView setContainerView:invoiceDetailView];
                [weakSelf.customIOS7AlertView showFromBottom];
                
                invoiceDetailView.confirmInvoiceBlock = ^(NSDictionary *invoiceParam) {
                    weakSelf.invoiceParam = invoiceParam;
                    [weakSelf.confirmView.invoiceBtn setTitle:@"已选发票" forState:UIControlStateNormal];
                    [weakSelf.confirmView.invoiceBtn setBackgroundColor:mainColor];
                    [weakSelf.confirmView.invoiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [weakSelf.customIOS7AlertView close];
                };
                
                invoiceDetailView.cancelInvoiceBlock = ^{
                    [weakSelf.confirmView.invoiceBtn setBackgroundColor:[UIColor whiteColor]];
                    [weakSelf.confirmView.invoiceBtn setTitle:@"发票" forState:UIControlStateNormal];
                    [weakSelf.confirmView.invoiceBtn setTitleColor:mainColor forState:UIControlStateNormal];
                    weakSelf.invoiceParam = nil;
                    [weakSelf.customIOS7AlertView close];
                };
            } withCancelBlock:^{
                
            }];
        }else {
            InvoiceDetailView *invoiceDetailView = [[[NSBundle mainBundle] loadNibNamed:@"InvoiceDetailView" owner:nil options:nil] lastObject];
            invoiceDetailView.frame = CGRectMake(0, 0, kDeviceWidth, 355);
            invoiceDetailView.paramDictionary = weakSelf.invoiceParam;
            weakSelf.customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
            weakSelf.customIOS7AlertView.tapClose = NO;
            [weakSelf.customIOS7AlertView setButtonTitles:nil];
            [weakSelf.customIOS7AlertView setContainerView:invoiceDetailView];
            [weakSelf.customIOS7AlertView showFromBottom];
            
            invoiceDetailView.confirmInvoiceBlock = ^(NSDictionary *invoiceParam) {
                weakSelf.invoiceParam = invoiceParam;
                [weakSelf.confirmView.invoiceBtn setTitle:@"已选发票" forState:UIControlStateNormal];
                [weakSelf.confirmView.invoiceBtn setBackgroundColor:mainColor];
                [weakSelf.confirmView.invoiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [weakSelf.customIOS7AlertView close];
            };
            
            invoiceDetailView.cancelInvoiceBlock = ^{
                [weakSelf.confirmView.invoiceBtn setBackgroundColor:[UIColor whiteColor]];
                [weakSelf.confirmView.invoiceBtn setTitle:@"发票" forState:UIControlStateNormal];
                [weakSelf.confirmView.invoiceBtn setTitleColor:mainColor forState:UIControlStateNormal];
                weakSelf.invoiceParam = nil;
                [weakSelf.customIOS7AlertView close];
            };
        }
        
    };
}

- (void)confirmAct {
    
    if (!_confirmView.isSelect) {
        [AlertView preAlertViewWithTitle:@"请先同意协议" withMessage:@"" withType:UIAlertControllerStyleAlert withConfirmBlock:^{}];
        return;
    }
    if(!_isNow){
        if (_appointTimeCell.contentLabel.text.length == 0) {
            [HUDClass showHUDWithText:@"预约时间不能为空！"];
            return;
        }
    }
    if (_typeSelectCell.contentLabel.text.length == 0) {
        [HUDClass showHUDWithText:@"车辆类型不能为空！"];
        return;
    }
    
    if (_nameCell.contentTextF.text.length == 0) {
        [HUDClass showHUDWithText:@"联系人不能为空！"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [AlertView alertViewWithTitle:@"提示" withMessage:@"请核对好所选择的车辆类型的 运载量 和 容量\n下单后不可修改" withConfirmTitle:@"继续下单" withCancelTitle:@"重新选择" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        if (!weakSelf.invoiceParam) {
            [self addOrderWithPayType:@"3" withPayId:@""];
        }else{
            PayDetailView *payDetailView = [[[NSBundle mainBundle] loadNibNamed:@"PayDetailView" owner:nil options:nil] lastObject];
            payDetailView.frame = CGRectMake(0, 0, kDeviceWidth, 256);
            self.customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
            [self.customIOS7AlertView setButtonTitles:nil];
            [self.customIOS7AlertView setContainerView:payDetailView];
            [self.customIOS7AlertView showFromBottom];
            
            
            
            payDetailView.payBtnActBlock = ^(NSString *payType) {
                [weakSelf.customIOS7AlertView close];
                if ([payType isEqualToString:@"1"]) {
                    //跳转支付宝支付
                    [self addOrderWithPayType:@"1" withPayId:@"zfb-zfid-0001"];
                }else if ([payType isEqualToString:@"2"]) {
                    //跳转微信支付
                    [self addOrderWithPayType:@"2" withPayId:@"wx-wxid-0001"];
                }
            };
        }
    } withCancelBlock:^{
        
    }];
    
}

- (void)addOrderWithPayType:(NSString *)payType withPayId:(NSString *)payId {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *orderParam = [NSMutableDictionary dictionary];
    if (_isNow) {
        [orderParam setObject:@"1" forKey:@"type"];
    }else {
        [orderParam setObject:@"2" forKey:@"type"];
        [orderParam setObject:_appointTimeCell.contentLabel.text forKey:@"appointTime"];
    }
    [orderParam setObject:[[Config shareConfig] getUserId] forKey:@"createManId"];
    [orderParam setObject:_nameCell.contentTextF.text forKey:@"linkMan"];
    [orderParam setObject:_phoneCell.contentTextF.text forKey:@"linkPhone"];
    
    [orderParam setObject:_carTypeValueStr forKey:@"carType"];
    [orderParam setObject:_remarkCell.contentTextF.text forKey:@"note"];
    
    
    [orderParam setObject:_sendAddress forKey:@"sendAddress"];
    [orderParam setObject:_sendDetailAddress forKey:@"sendDetailAddress"];
    [orderParam setObject:[NSNumber numberWithDouble:_sendPt.latitude] forKey:@"sendLatitude"];
    [orderParam setObject:[NSNumber numberWithDouble:_sendPt.longitude] forKey:@"sendLongitude"];
    
    [orderParam setObject:_receiveAddress forKey:@"receiveAddress"];
    [orderParam setObject:_receiveDetailAddress forKey:@"receiveDetailAddress"];
    [orderParam setObject:[NSNumber numberWithDouble:_receivePt.latitude] forKey:@"receiveLatitude"];
    [orderParam setObject:[NSNumber numberWithDouble:_receivePt.longitude] forKey:@"receiveLongitude"];
    
    double price = ((self.routeLine.distance/1000 - self.starDistance)>0 ? (self.routeLine.distance/1000 - self.starDistance) : 0) * self.unitPrice + self.starPrice;
    [orderParam setObject:[NSNumber numberWithDouble:((long)price)] forKey:@"price"];
    [orderParam setObject:[NSNumber numberWithDouble:self.routeLine.distance/1000] forKey:@"distance"];
    [orderParam setObject:payType forKey:@"freightFeePayType"]; //支付方式   1:支付宝支付    2:微信支付   3:现金支付
    if ([payType isEqualToString:@"3"]) {
        [orderParam setObject:@"0" forKey:@"freightFeePayStatus"];
    }else {
        [orderParam setObject:@"1" forKey:@"freightFeePayStatus"];
        [orderParam setObject:payId forKey:@"freightFeePayId"];
    }

    [param setObject:orderParam forKey:@"orderParam"];
    if (_invoiceParam) {
        [param setObject:_invoiceParam forKey:@"invoiceParam"];
    }
    
    
    [NetWorking postDataWithParameters:param withUrl:@"addOrder" withBlock:^(id result) {
        [HUDClass showHUDWithText:@"下单成功！"];
        NSString *orderId = [result objectForKey:@"object"];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.dismissBlock) {
                self.dismissBlock(self.sendPt,[[NSDate date] timeIntervalSince1970] * 1000, orderId);
            }
        }];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)initTableView {
    
    _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, _mapView.bottom + 10, kDeviceWidth-20, 44*(_isNow?4:5)) style:UITableViewStylePlain];
    _theTableView.delegate = self;
    _theTableView.dataSource = self;
    _theTableView.backgroundColor = [UIColor clearColor];
    
    _theTableView.tableFooterView = [UIView new];
    _theTableView.scrollEnabled = NO;
    
    _theTableView.layer.backgroundColor = [UIColor clearColor].CGColor;
    _theTableView.layer.shadowColor = [UIColor blackColor].CGColor;
    _theTableView.layer.shadowOpacity = 0.3f;
    _theTableView.layer.shadowOffset = CGSizeMake(0,0);
    _theTableView.layer.frame = _theTableView.frame;
    _theTableView.clipsToBounds = NO;
    [_bgScrollView addSubview:_theTableView];
    
}

- (void)initMap {
    CGFloat mapViewHeight = 0;
    if (_bgScrollView.height < (200 + 10 + 44*(_isNow?4:5) + 146 + 20)) {
        mapViewHeight = 200;
    }else{
        mapViewHeight = _bgScrollView.height - (10 + 44*(_isNow?4:5) + 146 + 20);
        
    }
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, mapViewHeight)];
    
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;
    [_bgScrollView addSubview:_mapView];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake( 0,  _mapView.bottom, kDeviceWidth, 10 + 44*(_isNow?4:5) + 146 + 20)];
    bgView.backgroundColor = bgColor;
    
    [_bgScrollView addSubview:bgView];
    
    
    _locService = [[BMKLocationService alloc] init];
    [self startLocation];
}

#pragma mark------地图代理
////开始定位
- (void)startLocation {
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    hud = [HUDClass showLoadingHUD];
}

/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 *此时结束定位，只获取一次用户位置信息
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    [HUDClass hideLoadingHUD:hud];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    
    [_mapView updateLocationData:userLocation];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    //结束定位
    [_locService stopUserLocationService];
    
    
    //添加大头针
    BMKPointAnnotation *beginPoint = [[BMKPointAnnotation alloc]init];
    beginPoint.coordinate = _sendPt;
    beginPoint.title = @"起点";
    [_mapView addAnnotation:beginPoint];
    
    BMKPointAnnotation *endPoint = [[BMKPointAnnotation alloc]init];
    endPoint.coordinate = _receivePt;
    endPoint.title = @"终点";
    [_mapView addAnnotation:endPoint];
    
    [self BMapSetPointCenterWithPoint11:_sendPt withPoint2:_receivePt];
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation.title isEqualToString:@"起点"]) {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location2"];
        annotationView.image = [UIImage imageNamed:@"begin"];
        annotationView.centerOffset = CGPointMake(0, -20);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, 50, 100, 0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _sendAddress;
        label.font = [UIFont boldSystemFontOfSize:12];
        [label sizeToFit];
        label.left = -label.width/2+16.5;
        [annotationView addSubview:label];
        return annotationView;
    }else if ([annotation.title isEqualToString:@"终点"]) {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location2"];
        annotationView.image = [UIImage imageNamed:@"end"];
        annotationView.centerOffset = CGPointMake(0, -20);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, 50, 100, 0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _receiveAddress;
        label.font = [UIFont boldSystemFontOfSize:12];
        [label sizeToFit];
        label.left = -label.width/2+16.5;
        [annotationView addSubview:label];
        return annotationView;
    }
    
    return [mapView viewForAnnotation:annotation];
}


- (void)BMapSetPointCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2 {
    int zoom = 10;
    
    double lat1 = point1.latitude;
    double lng1 = point1.longitude;
    
    double lat2 = point2.latitude;
    double lng2 = point2.longitude;
    
    double pointLng = (lng1 + lng2) / 2;
    double pointLat = (lat1 + lat2) / 2;
    
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(pointLat, pointLng);
    
    int zooms[] = {50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 25000, 50000,
        100000, 200000, 500000, 1000000, 2000000};
    BMKMapPoint dPoint1 = BMKMapPointForCoordinate(point1);
    BMKMapPoint dPoint2 = BMKMapPointForCoordinate(point2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(dPoint1, dPoint2);
    
    for (int i = 0; i < 16; i++) {
        if ((zooms[i] - distance) > 0) {
            zoom = 18 - i + 2;
            break;
        }
    }
    _mapView.zoomLevel = zoom;
    [_mapView setCenterCoordinate:coordinate animated:YES];
}


- (CustomSelectView *)customSelectView {
    if (_customSelectView == nil) {
        _customSelectView = [CustomSelectView customSelectView];
        _customSelectView.delegate = self;
        [self.view addSubview:_customSelectView];
    }else {
        [self.view bringSubviewToFront:_customSelectView];
    }
    return _customSelectView;
}



#pragma mark--------UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if (_appointTimeCell) {
            return _appointTimeCell;
        }
        SelectTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectTableViewCell" owner:nil options:nil] lastObject];
        _appointTimeCell = cell;
        cell.keyLabel.text = @"预约时间";
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e644" color:[NavBgImage getColorByString:@"预约时"] font:25];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        return cell;
    }else if (indexPath.row == 1) {
        if (_typeSelectCell) {
            return _typeSelectCell;
        }
        SelectTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectTableViewCell" owner:nil options:nil] lastObject];
        _typeSelectCell = cell;
        cell.keyLabel.text = @"车辆类型";
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e6c0" color:[NavBgImage getColorByString:@"类型"] font:22];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2) {
        if (_nameCell) {
            return _nameCell;
        }
        TextTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextTableViewCell" owner:nil options:nil] lastObject];
        _nameCell = cell;
        cell.keyLabel.text = @"联系人";
        cell.contentTextF.placeholder = @"联系人";
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e60d" color:[NavBgImage getColorByString:@"联系人"] font:22];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 3) {
        if (_phoneCell) {
            return _phoneCell;
        }
        TextTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextTableViewCell" owner:nil options:nil] lastObject];
        _phoneCell = cell;
        cell.keyLabel.text = @"电话";
        cell.contentTextF.placeholder = @"电话";
        cell.contentTextF.keyboardType = UIKeyboardTypeNumberPad;
        cell.contentTextF.enabled = NO;
        cell.contentTextF.text = [[Config shareConfig] getUserName];
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e88b" color:[NavBgImage getColorByString:@"电话电话"] font:28];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 4) {
        if (_remarkCell) {
            return _remarkCell;
        }
        TextTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TextTableViewCell" owner:nil options:nil] lastObject];
        _remarkCell = cell;
        cell.keyLabel.text = @"备注";
        cell.contentTextF.placeholder = @"备注";
        [NavBgImage showIconFontForView:cell.iconLabel iconName:@"\U0000e648" color:[NavBgImage getColorByString:@"备注"] font:25];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (_isNow) {
            return 0;
        }
        return 44;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.customSelectView showDateChooserWithMode:UIDatePickerModeDateAndTime];
    }else if (indexPath.row == 1) {
        [self selectType];
    }

}

- (void)selectType {
   
    __weak typeof(self) weakSelf = self;
    [[CustomSelectAlertView alloc] initAlertWithTitleArray:self.carTypeListTitle withBtnSelectBlock:^(NSInteger tagg) {
        weakSelf.confirmView.priceLabel.text = @"计价中";

        weakSelf.typeSelectCell.contentLabel.text = weakSelf.carTypeListTitle[tagg-1];
        CarTypeModel *model = weakSelf.carTypeList[tagg-1];
        weakSelf.carTypeValueStr = model.keyText;
        weakSelf.starDistance = model.startDistance;
        weakSelf.starPrice = model.startPrice;
        weakSelf.unitPrice = model.unitPrice;
        
        if (weakSelf.routeLine) {
            double price = ((self.routeLine.distance/1000 - self.starDistance)>0 ? (self.routeLine.distance/1000 - self.starDistance) : 0) * self.unitPrice + self.starPrice;
            weakSelf.confirmView.priceLabel.text = [NSString stringWithFormat:@"¥ %ld",(long)price];
        }else {
            [weakSelf routePlan];
        }

    }];
}

#pragma mark - CustomSelectView delegate
- (void)customSelectViewDidSelectedDate:(NSDate *)date DateString:(NSString *)dateString {
    if (![dateString isEqualToString:@""]) {
        _appointTimeCell.contentLabel.text = [dateString substringToIndex:16];
    }
}


- (void)routePlan
{
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;
    
    BMKDrivingRoutePlanOption *options = [[BMKDrivingRoutePlanOption alloc] init];
    
    options.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    
    start.pt = _sendPt;
    
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    
    CLLocationCoordinate2D endCor = _receivePt;
   
    
    
    
    
    end.pt = endCor;
    
    options.from = start;
    options.to = end;
    
    BOOL suc = [_routeSearch drivingSearch:options];
    
    if (suc) {
        NSLog(@"路线查找成功");
    }
    
}

#pragma mark - BMKRouteSearchDelegate

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
//    searcher.delegate = nil;
    
    if (error == BMK_SEARCH_NO_ERROR) {
        if (result.routes.count > 0) {
            BMKDrivingRouteLine *drivingRouteLine = result.routes[0];
            self.routeLine = drivingRouteLine;
            double price = ((self.routeLine.distance/1000 - self.starDistance)>0 ? (self.routeLine.distance/1000 - self.starDistance) : 0) * self.unitPrice + self.starPrice;
            self.confirmView.priceLabel.text = [NSString stringWithFormat:@"¥ %ld",(long)price];
            self.confirmView.priceDetailBtn.hidden = NO;
        }
        
        
    } else {
        NSLog(@"error code:%u", error);
    }
}






@end

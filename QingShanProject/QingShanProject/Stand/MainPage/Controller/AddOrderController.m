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



@interface AddOrderController () <BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDelegate, UITableViewDataSource, CustomSelectViewDelegate>
{
    BMKLocationService *_locService;
    MBProgressHUD *hud;
}

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) UITableView *theTableView;
@property (nonatomic, strong) CustomSelectView *customSelectView;

@property (nonatomic, strong) SelectTableViewCell *appointTimeCell;
@property (nonatomic, strong) SelectTableViewCell *typeSelectCell;
@property (nonatomic, strong) TextTableViewCell *nameCell;
@property (nonatomic, strong) TextTableViewCell *phoneCell;
@property (nonatomic, strong) TextTableViewCell *remarkCell;


@property (nonatomic, strong) OrderConfirmView *confirmView;











@end

@implementation AddOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView {
    [self initMap];
    [self initTableView];
    [self initConfirmView];
}

- (void)initConfirmView {
    _confirmView = [[[NSBundle mainBundle] loadNibNamed:@"OrderConfirmView" owner:nil options:nil] lastObject];
    _confirmView.frame = CGRectMake(10, kDeviceHeight-156, kDeviceWidth-20, 146);
    [self.view addSubview:_confirmView];
    __weak AddOrderController *weakSelf = self;
    _confirmView.confirmBlock = ^{
        [weakSelf confirmAct];
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
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (_isNow) {
        [param setObject:@"1" forKey:@"type"];
    }else {
        [param setObject:@"2" forKey:@"type"];
        [param setObject:_appointTimeCell.contentLabel.text forKey:@"appointTime"];
    }
    [param setObject:[[Config shareConfig] getUserId] forKey:@"createManId"];
    [param setObject:_nameCell.contentTextF.text forKey:@"linkMan"];
    [param setObject:_phoneCell.contentTextF.text forKey:@"linkPhone"];
    
    [param setObject:_typeSelectCell.contentLabel.text forKey:@"carType"];
    [param setObject:_remarkCell.contentTextF.text forKey:@"note"];

    
    [param setObject:_sendAddress forKey:@"sendAddress"];
    [param setObject:[NSNumber numberWithDouble:_sendPt.latitude] forKey:@"sendLatitude"];
    [param setObject:[NSNumber numberWithDouble:_sendPt.longitude] forKey:@"sendLongitude"];
    
    [param setObject:_receiveAddress forKey:@"receiveAddress"];
    [param setObject:[NSNumber numberWithDouble:_receivePt.latitude] forKey:@"receiveLatitude"];
    [param setObject:[NSNumber numberWithDouble:_receivePt.longitude] forKey:@"receiveLongitude"];


    [NetWorking postDataWithParameters:param withUrl:@"addOrder" withBlock:^(id result) {
        [HUDClass showHUDWithText:@"下单成功！"];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.dismissBlock) {
                self.dismissBlock(self.sendPt,[[NSDate date] timeIntervalSince1970]);
            }
        }];
    } withFailedBlock:^(NSString *errorResult) {

    }];

  
}

- (void)initTableView {
    
    _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kDeviceHeight-166-44*(_isNow?4:5), kDeviceWidth-20, 44*(_isNow?4:5)) style:UITableViewStylePlain];
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
    [self.view addSubview:_theTableView];
    
    
}

- (void)initMap {
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAVBAR_HEIGHT+2, kDeviceWidth, kDeviceHeight-166-44*(_isNow?4:5)-10-STATUS_AND_NAVBAR_HEIGHT-2)];
    
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;
        [self.view addSubview:_mapView];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake( 0,  _mapView.bottom, kDeviceWidth, kDeviceHeight-_mapView.bottom)];
    bgView.backgroundColor = bgColor;
    [self.view addSubview:bgView];
    
    
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
    NSArray *titleArray = @[@"小面包车(800kg/1.8*1.2*1.1m/2.4m³)",
                            @"中面包车(1.2t/2.8*1.5*1.3m/5.5m³)",
                            @"小货车(1.5t/2.1*1.7*1.6m/5.7m³)",
                            @"中货车(1.8t/4.3*2.1*1.8m/16.3m³)",
                            @"大半挂车(∞t/∞m/∞m³)"
                            ];
    __weak AddOrderController *weakSelf = self;
    [[CustomSelectAlertView alloc] initAlertWithTitleArray:[titleArray mutableCopy] withBtnSelectBlock:^(NSInteger tagg) {
        weakSelf.typeSelectCell.contentLabel.text = titleArray[tagg-1];
    }];
}

#pragma mark - CustomSelectView delegate
- (void)customSelectViewDidSelectedDate:(NSDate *)date DateString:(NSString *)dateString {
    if (![dateString isEqualToString:@""]) {
        _appointTimeCell.contentLabel.text = [dateString substringToIndex:16];
    }
}






@end

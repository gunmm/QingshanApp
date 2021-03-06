//
//  StandMainPageController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "StandMainPageController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "AddOrderView.h"
#import "SelectAddressController.h"
#import "AddOrderController.h"
#import "SeekViewController.h"
#import "DriverOnWayController.h"
#import "OrderFinshController.h"
#import "MessageBtn.h"
#import "MessageListController.h"
#import "UMShareUtils.h"


@interface StandMainPageController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate, BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;
    MBProgressHUD *hud;
    CGFloat fakeToRealHeight;
}

@property (strong, nonatomic) BMKMapView *mapView;
@property (nonatomic, strong) BMKPointAnnotation *centerPoint;
@property (nonatomic, strong) AddOrderView *addOrderView;
@property (strong, nonatomic) BMKGeoCodeSearch *geoCodeSearch;



@property (nonatomic, assign) CLLocationCoordinate2D sendAddressPt;
@property (nonatomic, assign) CLLocationCoordinate2D receiveAddressPt;

@property (nonatomic, copy) NSString *sendDetailAddress;
@property (nonatomic, copy) NSString *receiveDetailAddress;


@property (nonatomic, copy) NSString *signSend;
@property (nonatomic, assign) NSInteger resCount;
@property (nonatomic, copy) NSString *nowReciverCityString;
@property (nonatomic, copy) NSString *nowSendCityString;
@property (nonatomic, copy) NSString *nowLocCityString;



@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIView *redView;




@property (nonatomic, strong) NSArray *geoCodeResultList;








@end

@implementation StandMainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self loadAgreementData];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _geoCodeSearch.delegate = self;
    _locService.delegate = self;
    _mapView.delegate = self;
    
    [self queryMessageCount];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    _geoCodeSearch.delegate = nil;
//    _locService.delegate = nil;
//    _mapView.delegate = nil;
}

- (void)initNavBar {
    self.title = @"主页面";
    self.view.backgroundColor = [UIColor whiteColor];
    _signSend = @"1";
    //初始化按钮
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
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




- (void)personAct {
    if (self.standMainPageShowLeft) {
        self.standMainPageShowLeft();
    }
}

- (void)messageAct {
    MessageListController *messageListController = [[MessageListController alloc] init];
    [self.navigationController pushViewController:messageListController animated:YES];
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

- (void)loadAgreementData {
    [NetWorking bgPostDataWithParameters:@{} withUrl:@"orderAgreement" withBlock:^(id result) {
        NSDictionary *object = [result objectForKey:@"object"];
        NSString *masterAgreement = [object objectForKey:@"masterAgreement"];
        NSString *servicePhone = [object objectForKey:@"servicePhone"];

        [[Config shareConfig] setMasterAgreement:masterAgreement];
        [[Config shareConfig] setServicePhone:servicePhone];

        
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}


- (void)initView {
    [self initGeoCodeSearch];
    [self initMap];
    [self initBtnView];
    [self initAddOrderView];
}

- (void)initGeoCodeSearch {
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
}

- (void)initAddOrderView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, kDeviceHeight-146-STATUS_AND_NAVBAR_HEIGHT-TABBAR_BOTTOM_HEIGHT-5, kDeviceWidth-10, 146)];
    [self.view addSubview:bgView];
    _addOrderView = [[[NSBundle mainBundle] loadNibNamed:@"AddOrderView" owner:nil options:nil] lastObject];
    _addOrderView.frame = CGRectMake(0, 0, kDeviceWidth-10, 146);
    [bgView addSubview:_addOrderView];
    

    __weak typeof(self) weakSelf = self;
    _addOrderView.sendTapActBlock = ^{
        SelectAddressController *selectAddressVc = [[SelectAddressController alloc] init];
        selectAddressVc.beginSerchString = weakSelf.addOrderView.sendTextField.text;
        selectAddressVc.beginSerchPt = weakSelf.sendAddressPt;
        selectAddressVc.nowCityString = weakSelf.nowSendCityString;
        if ([weakSelf.nowSendCityString isEqualToString:weakSelf.nowLocCityString]) {
            selectAddressVc.oldArray = weakSelf.geoCodeResultList;
        }
        
        
        [weakSelf.navigationController presentViewController:selectAddressVc animated:YES completion:nil];
        selectAddressVc.cityNameBlock = ^(NSString *cityName) {
            weakSelf.nowSendCityString = cityName;
        };
        selectAddressVc.cellClickBlock = ^(NSString *name, NSString *address, CLLocationCoordinate2D pt) {
            weakSelf.addOrderView.sendTextField.text = name;
            weakSelf.sendAddressPt = pt;
            weakSelf.sendDetailAddress = address;
            weakSelf.signSend = @"0";
            weakSelf.mapView.centerCoordinate = pt;

        };
    };
    
    _addOrderView.receiveTapActBlock = ^{
        if (weakSelf.addOrderView.sendTextField.text.length == 0) {
            [HUDClass showHUDWithText:@"请先选择发货地址！"];
            return;
        }
        SelectAddressController *selectAddressVc = [[SelectAddressController alloc] init];
        selectAddressVc.beginSerchString = weakSelf.addOrderView.receiveTextField.text;
        selectAddressVc.beginSerchPt = weakSelf.receiveAddressPt;
        selectAddressVc.nowCityString = weakSelf.nowReciverCityString;

        [weakSelf.navigationController presentViewController:selectAddressVc animated:YES completion:nil];
        
        selectAddressVc.cityNameBlock = ^(NSString *cityName) {
            weakSelf.nowReciverCityString = cityName;
        };
        
        selectAddressVc.cellClickBlock = ^(NSString *name, NSString *address, CLLocationCoordinate2D pt) {
            weakSelf.addOrderView.receiveTextField.text = name;
            weakSelf.receiveAddressPt = pt;
            if(name.length > 0){
                AddOrderController *addOrderVc = [[AddOrderController alloc] init];
                addOrderVc.sendPt = weakSelf.sendAddressPt;
                addOrderVc.sendCity = weakSelf.nowSendCityString;
                addOrderVc.sendAddress = weakSelf.addOrderView.sendTextField.text;
                addOrderVc.sendDetailAddress = weakSelf.sendDetailAddress;
                addOrderVc.receivePt = weakSelf.receiveAddressPt;
                addOrderVc.receiveAddress = weakSelf.addOrderView.receiveTextField.text;
                addOrderVc.receiveDetailAddress = address;
                addOrderVc.isNow = weakSelf.addOrderView.isNow;
                [weakSelf.navigationController presentViewController:addOrderVc animated:YES completion:nil];
                addOrderVc.backDismissBlock = ^{
//                    weakSelf.addOrderView.receiveTextField.text = @"";
                };
                addOrderVc.dismissBlock = ^(CLLocationCoordinate2D pt, long long createTime, NSString *orderId) {
                    [weakSelf startLocation];
                    weakSelf.addOrderView.receiveTextField.text = @"";
                    SeekViewController *seekViewController = [[SeekViewController alloc] init];
                    seekViewController.sendPt = pt;
                    seekViewController.createTime = createTime;
                    seekViewController.orderId = orderId;
                    [weakSelf.navigationController pushViewController:seekViewController animated:YES];
//                    seekViewController.seekPopBlock = ^(NSString *orderId, NSString *orderType) {
//                            DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
//                            onwayVc.orderId = orderId;
//                            [weakSelf.navigationController pushViewController:onwayVc animated:YES];
//                    };
                };
                
               
            }
        };
    };
}

- (void)initBtnView {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth-45, kDeviceHeight-146-STATUS_AND_NAVBAR_HEIGHT-TABBAR_BOTTOM_HEIGHT-5-45, 40, 40)];
    [NavBgImage showIconFontForView:backBtn iconName:@"\U0000e786" color:[UIColor blackColor] font:30];
    [self.view addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnAct) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnAct {
    [self startLocation];

}

- (void)initMap {
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, -151, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT+151)];
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;
    _mapView.zoomEnabledWithTap = NO;

    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc] init];
    [self startLocation];
}

#pragma mark------反地理编码代理
/** 反地理编码 */
- (void)reverseLocation:(CLLocationCoordinate2D)userLocation {
    BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    reverseGeocodeSearchOption.location = userLocation;
    BOOL result = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if (!result) {
        _resCount ++;
        if (_resCount <= 10) {
            [self performSelector:@selector(reverse) withObject:nil afterDelay:0.1];
        }
    }else{
        _resCount = 0;
    }
}

- (void)reverse {
    [self reverseLocation:_mapView.centerCoordinate];

}


/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if(result.poiList.count > 0){
            BMKPoiInfo *info = result.poiList[0];
            for (BMKPoiInfo *poiInfo in result.poiList) {
                poiInfo.province = result.addressDetail.province;
                poiInfo.city = result.addressDetail.city;
                poiInfo.area = result.addressDetail.district;
            }
            _geoCodeResultList = result.poiList;
            _addOrderView.sendTextField.text = info.name;
            _nowLocCityString = result.addressDetail.city;
            _nowSendCityString = result.addressDetail.city;
            _nowReciverCityString = result.addressDetail.city;
//            _sendDetailAddress = result.address;
            if ([(DIRECTLY_CITY_ARRAY) containsObject:result.addressDetail.city]) {
                _sendDetailAddress = [NSString stringWithFormat:@"%@%@", result.addressDetail.city, result.addressDetail.district];
            }else {
                _sendDetailAddress = [NSString stringWithFormat:@"%@%@%@", result.addressDetail.province, result.addressDetail.city, result.addressDetail.district];
            }
            NSLog(@"address:%@\n des:%@",result.address,result.sematicDescription);
        }
    }else {
        
    }
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
    _signSend = @"0";
    
    [HUDClass hideLoadingHUD:hud];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    
    [_mapView updateLocationData:userLocation];
   
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    //结束定位
    [_locService stopUserLocationService];
    
    _sendAddressPt = userLocation.location.coordinate;
    
    //添加拖动的大头针
    _centerPoint = [[BMKPointAnnotation alloc]init];
    _centerPoint.coordinate = userLocation.location.coordinate;
    _centerPoint.title = @"检索中点";
    [_mapView addAnnotation:_centerPoint];
    
    // 经纬度反编码
    [self reverseLocation:userLocation.location.coordinate];
    
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation.title isEqualToString:@"检索中点"]) {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location2"];
        annotationView.image = [UIImage imageNamed:@"start_annotation"];
        annotationView.centerOffset = CGPointMake(0, -20);
        return annotationView;
        
    }
    return [mapView viewForAnnotation:annotation];
    
}


- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    _centerPoint.coordinate = _mapView.centerCoordinate;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    _sendAddressPt = mapView.centerCoordinate;
    if ([_signSend isEqualToString:@"1"]) {
        [self reverseLocation:_centerPoint.coordinate];
    }else{
        _signSend = @"1";
    }
}






@end

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


@interface StandMainPageController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate, BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;
    MBProgressHUD *hud;
}

@property (strong, nonatomic) BMKMapView *mapView;
@property (nonatomic, strong) BMKPointAnnotation *centerPoint;
@property (nonatomic, strong) AddOrderView *addOrderView;
@property (strong, nonatomic) BMKGeoCodeSearch *geoCodeSearch;

@property (nonatomic, copy) NSString *locationAddressName;


@property (nonatomic, assign) CLLocationCoordinate2D sendAddressPt;
@property (nonatomic, assign) CLLocationCoordinate2D receiveAddressPt;

@property (nonatomic, copy) NSString *signSend;
@property (nonatomic, assign) NSInteger resCount;
@property (nonatomic, copy) NSString *nowCityString;

@property (nonatomic, strong) MessageBtn *messageBtn;





@end

@implementation StandMainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _geoCodeSearch.delegate = self;
    _locService.delegate = self;
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _geoCodeSearch.delegate = nil;
    _locService.delegate = nil;
    _mapView.delegate = nil;
}

- (void)initNavBar {
    self.title = @"主页面";
    self.view.backgroundColor = [UIColor whiteColor];
    _signSend = @"1";
    //初始化按钮
    UIButton *personBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    personBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    personBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [NavBgImage showIconFontForView:personBtn iconName:@"\U0000e62f" color:mainColor font:25];
    
    [personBtn addTarget:self action:@selector(personAct) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *personItem = [[UIBarButtonItem alloc] initWithCustomView:personBtn];
    self.navigationItem.leftBarButtonItem = personItem;
    
    
    _messageBtn = [[MessageBtn alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    _messageBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    _messageBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [NavBgImage showIconFontForView:_messageBtn iconName:@"\U0000e617" color:mainColor font:25];
    
    [_messageBtn addTarget:self action:@selector(messageAct) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:_messageBtn];
    self.navigationItem.rightBarButtonItem = messageItem;
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, kDeviceHeight-146-STATUS_AND_NAVBAR_HEIGHT-5, kDeviceWidth-10, 146)];
    [self.view addSubview:bgView];
    _addOrderView = [[[NSBundle mainBundle] loadNibNamed:@"AddOrderView" owner:nil options:nil] lastObject];
    _addOrderView.frame = CGRectMake(0, 0, kDeviceWidth-10, 146);
    [bgView addSubview:_addOrderView];
    

    __weak StandMainPageController *weakSelf = self;
    _addOrderView.sendTapActBlock = ^{
        SelectAddressController *selectAddressVc = [[SelectAddressController alloc] init];
        selectAddressVc.beginSerchString = weakSelf.addOrderView.sendTextField.text;
        selectAddressVc.beginSerchPt = weakSelf.sendAddressPt;
        selectAddressVc.nowCityString = weakSelf.nowCityString;
        [weakSelf.navigationController presentViewController:selectAddressVc animated:YES completion:nil];
        selectAddressVc.cellClickBlock = ^(NSString *name, NSString *address, CLLocationCoordinate2D pt) {
            weakSelf.addOrderView.sendTextField.text = name;
            weakSelf.sendAddressPt = pt;
            weakSelf.signSend = @"0";
            weakSelf.mapView.centerCoordinate = pt;

        };
    };
    
    _addOrderView.receiveTapActBlock = ^{
        SelectAddressController *selectAddressVc = [[SelectAddressController alloc] init];
        selectAddressVc.beginSerchString = weakSelf.addOrderView.receiveTextField.text;
        selectAddressVc.beginSerchPt = weakSelf.receiveAddressPt;
        selectAddressVc.nowCityString = weakSelf.nowCityString;

        [weakSelf.navigationController presentViewController:selectAddressVc animated:YES completion:nil];
        selectAddressVc.cellClickBlock = ^(NSString *name, NSString *address, CLLocationCoordinate2D pt) {
            weakSelf.addOrderView.receiveTextField.text = name;
            weakSelf.receiveAddressPt = pt;
            if(name.length > 0){
                AddOrderController *addOrderVc = [[AddOrderController alloc] init];
                addOrderVc.sendPt = weakSelf.sendAddressPt;
                addOrderVc.sendAddress = weakSelf.addOrderView.sendTextField.text;
                addOrderVc.receivePt = weakSelf.receiveAddressPt;
                addOrderVc.receiveAddress = weakSelf.addOrderView.receiveTextField.text;
                addOrderVc.isNow = weakSelf.addOrderView.isNow;
                [weakSelf.navigationController presentViewController:addOrderVc animated:YES completion:nil];
                addOrderVc.backDismissBlock = ^{
                    weakSelf.addOrderView.receiveTextField.text = @"";
                };
                addOrderVc.dismissBlock = ^(CLLocationCoordinate2D pt, long long createTime, NSString *orderId) {
                    weakSelf.addOrderView.receiveTextField.text = @"";
                    SeekViewController *seekViewController = [[SeekViewController alloc] init];
                    seekViewController.sendPt = pt;
                    seekViewController.createTime = createTime;
                    seekViewController.orderId = orderId;
                    [weakSelf.navigationController pushViewController:seekViewController animated:YES];
                    seekViewController.seekPopBlock = ^(NSString *orderId, NSString *orderType) {
                        if ([orderType isEqualToString:@"1"]) {
                            DriverOnWayController *onwayVc = [[DriverOnWayController alloc] init];
                            onwayVc.orderId = orderId;
                            [weakSelf.navigationController pushViewController:onwayVc animated:YES];
                            
                            onwayVc.orderCompleteBlock = ^(OrderModel *model) {
                                OrderFinshController *finishvC = [[OrderFinshController alloc] init];
                                finishvC.model = model;
                                [weakSelf.navigationController pushViewController:finishvC animated:YES];
                            };
                        }
                    };
                };
                
               
            }
        };
    };
}

- (void)initBtnView {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth-45, kDeviceHeight-146-STATUS_AND_NAVBAR_HEIGHT-5-45, 40, 40)];
    [NavBgImage showIconFontForView:backBtn iconName:@"\U0000e786" color:[UIColor blackColor] font:30];
    [self.view addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnAct) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnAct {
    [self startLocation];

}

- (void)initMap {
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT)];
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;

    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc] init];
    [self startLocation];
}

#pragma mark------反地理编码代理
/** 反地理编码 */
- (void)reverseLocation:(CLLocationCoordinate2D)userLocation {
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation;
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
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
//        if (result.poiList.count > 1) {
//            BMKPoiInfo *info = result.poiList[1];
//            _addOrderView.sendTextField.text = info.name;
//            _locationAddressName = info.name;
//            NSLog(@"address:%@\n des:%@",result.address,result.sematicDescription);
//        }else
        if(result.poiList.count > 0){
            BMKPoiInfo *info = result.poiList[0];
            _addOrderView.sendTextField.text = info.name;
            _locationAddressName = info.name;
            _nowCityString = result.addressDetail.city;
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
    
    
    //添加拖动的大头针
    _centerPoint = [[BMKPointAnnotation alloc]init];
    _centerPoint.coordinate = userLocation.location.coordinate;
    _centerPoint.title = @"检索中点";
    [_mapView addAnnotation:_centerPoint];
    
    
    _sendAddressPt = userLocation.location.coordinate;
    
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
    _centerPoint.coordinate = mapView.centerCoordinate;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    _sendAddressPt = mapView.centerCoordinate;
    if ([_signSend isEqualToString:@"1"]) {
        [self reverseLocation:mapView.centerCoordinate];
    }else{
        _signSend = @"1";
    }
}








@end

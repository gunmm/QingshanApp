//
//  OrderFinshController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/28.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "OrderFinshController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "OrderFinishView.h"
#import "FinishOrderRes.h"


@interface OrderFinshController () <BMKMapViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) OrderFinishView *finishView;



@end

@implementation OrderFinshController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self loadData];

}


- (void)initNavBar {
    self.title = @"订单完成";
    self.view.backgroundColor = bgColor;
}

- (void)initView {
    [self initMapView];
    [self addFinishView];
    
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.orderId forKey:@"orderId"];
    [NetWorking postDataWithParameters:param withUrl:@"getBigOrderInfo" withBlock:^(id result) {
        FinishOrderRes *finishOrderRes = [FinishOrderRes mj_objectWithKeyValues:result];
        self.model = finishOrderRes.object;
        [self setData];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)setData {
    BMKPointAnnotation *sendPointAnnotation = [[BMKPointAnnotation alloc] init];
    sendPointAnnotation.coordinate = CLLocationCoordinate2DMake(_model.sendLatitude, _model.sendLongitude);
    sendPointAnnotation.title = @"起点";
    [_mapView addAnnotation:sendPointAnnotation];
    
    BMKPointAnnotation *reciverPointAnnotation = [[BMKPointAnnotation alloc] init];
    reciverPointAnnotation.coordinate = CLLocationCoordinate2DMake(_model.receiveLatitude, _model.receiveLongitude);
    reciverPointAnnotation.title = @"终点";
    [_mapView addAnnotation:reciverPointAnnotation];
    
    CGFloat zoom = [self BMapSetPointCenterWithPoint11:sendPointAnnotation.coordinate withPoint2:reciverPointAnnotation.coordinate];
    CLLocationCoordinate2D center = [self BMapGetCenterWithPoint11:sendPointAnnotation.coordinate withPoint2:reciverPointAnnotation.coordinate];
    
    _mapView.zoomLevel = zoom;
    [_mapView setCenterCoordinate:center animated:YES];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mapView.zoomLevel = zoom;
        [self.mapView setCenterCoordinate:center animated:YES];
        
    });
    

    _finishView.model = _model;
    if ([_model.status isEqualToString:@"1"] && [_model.appointStatus isEqualToString:@"0"]) {
        self.title = @"订单详情";
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked)];
        [cancleBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [self.navigationItem setRightBarButtonItem:cancleBtn];
    }else if ([_model.status isEqualToString:@"9"]) {
        self.title = @"订单取消";
    }

}

- (void)cancelBtnClicked {
    [AlertView alertViewWithTitle:@"提示" withMessage:@"确认取消订单" withConfirmTitle:@"确认" withCancelTitle:@"取消" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.orderId forKey:@"orderId"];
        
        [NetWorking postDataWithParameters:param withUrl:@"cancelOrder" withBlock:^(id result) {
            [HUDClass showHUDWithText:@"订单取消成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        } withFailedBlock:^(NSString *errorResult) {
            
        }];
    } withCancelBlock:^{
        
    }];
    
}


- (void)initMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT-240)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];
}

- (void)addFinishView {
    UIView *fakeView = [[UIView alloc] initWithFrame:CGRectMake(5, _mapView.bottom+5, kDeviceWidth-10, 230)];
    [self.view addSubview:fakeView];
    
    _finishView = [[[NSBundle mainBundle] loadNibNamed:@"OrderFinishView" owner:nil options:nil] lastObject];
    _finishView.frame = CGRectMake(0, 0, kDeviceWidth-10, 230);
    [fakeView addSubview:_finishView];
}

#pragma mark-------BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation.title isEqualToString:@"起点"]) {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location2"];
        annotationView.image = [UIImage imageNamed:@"begin"];
        annotationView.centerOffset = CGPointMake(0, -20);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, 50, 100, 0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _model.sendAddress;
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
        label.text = _model.receiveAddress;
        label.font = [UIFont boldSystemFontOfSize:12];
        [label sizeToFit];
        label.left = -label.width/2+16.5;
        [annotationView addSubview:label];
        return annotationView;
    }
    
    return [mapView viewForAnnotation:annotation];
}


- (CGFloat)BMapSetPointCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2 {
    int zoom = 13;
    
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
    return zoom;
    
}

- (CLLocationCoordinate2D)BMapGetCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2 {
    double lat1 = point1.latitude;
    double lng1 = point1.longitude;
    
    double lat2 = point2.latitude;
    double lng2 = point2.longitude;
    
    double pointLng = (lng1 + lng2) / 2;
    double pointLat = (lat1 + lat2) / 2;
    
    
    return CLLocationCoordinate2DMake(pointLat, pointLng);
}
                                                           
                                                           
                                                    
                                                           
                                                           
                                                           
                                                           

@end

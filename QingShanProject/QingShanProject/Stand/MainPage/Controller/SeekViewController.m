//
//  SeekViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/18.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "SeekViewController.h"
#import "WaitTitleView.h"
#import "NearbyCarRes.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>



#define WZFlashInnerCircleInitialRaius  20


@interface SeekViewController () <BMKMapViewDelegate>
{
    NSTimer *timer;
}

@property (strong, nonatomic) BMKMapView *mapView;
@property (nonatomic, strong) BMKPointAnnotation *centerPoint;

@property(nonatomic, strong) CAShapeLayer *circleShape;
@property(nonatomic, strong) CAAnimationGroup *animationGroup;
@property(nonatomic, strong) WaitTitleView *waitTitleView;
@property(nonatomic, strong) NSMutableArray *dataList;







@end

@implementation SeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [self loadAppearCarData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [timer invalidate];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

- (void)initNavBar {
    self.title = @"等待应答";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked)];
    [cancleBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:cancleBtn];
}

- (void)cancelBtnClicked {
    [AlertView alertViewWithTitle:@"提示" withMessage:@"确认取消订单" withType:UIAlertControllerStyleAlert withConfirmBlock:^{
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

- (void)loadAppearCarData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_orderId forKey:@"orderId"];

    
    [NetWorking postDataWithParameters:param withUrl:@"getOrderCarList" withBlock:^(id result) {
        [NearbyCarRes mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"object" : @"NearbyCarListModel",
                     };
        }];
        NearbyCarRes *nearbyCarRes = [NearbyCarRes mj_objectWithKeyValues:result];
        self.dataList = [nearbyCarRes.object mutableCopy];
        [self adjustZoom];
        [self addMapAnnotation];
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)adjustZoom {
    
    if (_dataList.count <= 1) {
        return;
    }
    CLLocationCoordinate2D latBigPoint;
    CLLocationCoordinate2D latSmallPoint;
    CLLocationCoordinate2D lngBigPoint;
    CLLocationCoordinate2D lngSmallPoint;
    
    
    //lat从小到大
    NSMutableArray *latArray = [self.dataList mutableCopy];
    NearbyCarListModel *centerModel = [NearbyCarListModel new];
    centerModel.nowLatitude = _sendPt.latitude;
    centerModel.nowLongitude = _sendPt.longitude;
    [latArray addObject:centerModel];
    //排序
    for(int i = 0; i < latArray.count - 1; i++){
        for (int j = 0; j < latArray.count-i-1; j ++) {
            NearbyCarListModel *modelj1 = latArray[j];
            NearbyCarListModel *modelj2 = latArray[j+1];
            if (modelj1.nowLatitude > modelj2.nowLatitude) {
                latArray[j] = modelj2;
                latArray[j+1] = modelj1;
            }

        }
        
    }
    
    //lng从小到大
    NSMutableArray *lngArray = [self.dataList mutableCopy];
    [lngArray addObject:centerModel];
    //排序
    for(int i = 0; i < lngArray.count - 1; i++){
        for (int j = 0; j < lngArray.count-i-1; j ++) {
            NearbyCarListModel *modelj1 = lngArray[j];
            NearbyCarListModel *modelj2 = lngArray[j+1];
            if (modelj1.nowLongitude > modelj2.nowLongitude) {
                lngArray[j] = modelj2;
                lngArray[j+1] = modelj1;
            }
            
        }
        
    }
    
    NearbyCarListModel *modelLat1 = [latArray firstObject];
    NearbyCarListModel *modelLat2 = [latArray lastObject];
    NearbyCarListModel *modelLng1 = [lngArray firstObject];
    NearbyCarListModel *modelLng2 = [lngArray lastObject];
    
    
    
    
    latBigPoint = CLLocationCoordinate2DMake(modelLat2.nowLatitude, modelLat2.nowLongitude);
    latSmallPoint = CLLocationCoordinate2DMake(modelLat1.nowLatitude, modelLat1.nowLongitude);
    lngBigPoint = CLLocationCoordinate2DMake(modelLng2.nowLatitude, modelLng2.nowLongitude);
    lngSmallPoint = CLLocationCoordinate2DMake(modelLng1.nowLatitude, modelLng1.nowLongitude);


    CGFloat latZoom = [self BMapSetPointCenterWithPoint11:latBigPoint withPoint2:latSmallPoint];
//    CLLocationCoordinate2D latCenter = [self BMapGetCenterWithPoint11:latBigPoint withPoint2:latSmallPoint];

    CGFloat lngZoom = [self BMapSetPointCenterWithPoint11:lngBigPoint withPoint2:lngSmallPoint];
//    CLLocationCoordinate2D lngCenter = [self BMapGetCenterWithPoint11:lngBigPoint withPoint2:lngSmallPoint];

    if (latZoom < lngZoom) {
        _mapView.zoomLevel = latZoom;
//        [_mapView setCenterCoordinate:latCenter animated:YES];
    }else{
        _mapView.zoomLevel = lngZoom;
//        [_mapView setCenterCoordinate:lngCenter animated:YES];
    }
    
}

- (void)addMapAnnotation {
    for (NearbyCarListModel *model in self.dataList) {
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(model.nowLatitude, model.nowLongitude);
        pointAnnotation.title = model.plateNumber;
        [_mapView addAnnotation:pointAnnotation];
    }
}


- (void)initView {
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT)];
    _mapView.zoomLevel = 13;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;
//    _mapView.scrollEnabled = NO;
    _mapView.delegate = self;

    [self.view addSubview:_mapView];
    
    
    //添加拖动的大头针
    _centerPoint = [[BMKPointAnnotation alloc]init];
    _centerPoint.coordinate = _sendPt;
    _centerPoint.title = @"检索中点";
    [_mapView addAnnotation:_centerPoint];

    _mapView.centerCoordinate = _sendPt;

    [self timeAct];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAct) userInfo:nil repeats:YES];

}

- (void)timeAct {
    long long nowTimeLong = [[NSDate date] timeIntervalSince1970];
    NSInteger timerCount = nowTimeLong - _createTime/1000;
    NSInteger h = timerCount/3600;
    NSInteger m = (timerCount%3600)/60;
    NSInteger s = timerCount%60;
    _waitTitleView.timeLabel.text = [NSString stringWithFormat:@"等待%02zd:%02zd:%02zd", h, m, s];
}


#pragma mark-----BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation.title isEqualToString:@"检索中点"]) {
        BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location2"];
        annotationView.image = [UIImage imageNamed:@"start_annotation"];
        annotationView.centerOffset = CGPointMake(0, -20);
        
        _waitTitleView = [[[NSBundle mainBundle] loadNibNamed:@"WaitTitleView" owner:nil options:nil] lastObject];
        _waitTitleView.frame = CGRectMake(-98.5, -20, 230, 20);
        [annotationView addSubview:_waitTitleView];
        
        [self addAnimationForAnnotView:annotationView];
        return annotationView;
        
    }
    
    return [mapView viewForAnnotation:annotation];
    
}

- (void)addAnimationForAnnotView:(BMKAnnotationView *)annotationView {
    annotationView.layer.masksToBounds = NO;
    
    CGFloat scale = 1.0f;
    CGFloat width = 100, height = 100;
    
    CGFloat biggerEdge = width > height ? width : height, smallerEdge = width > height ? height : width;
    CGFloat radius = smallerEdge / 2 > WZFlashInnerCircleInitialRaius ? WZFlashInnerCircleInitialRaius : smallerEdge / 2;
    
    scale = biggerEdge / radius + 0.5;
    _circleShape = [self createCircleShapeWithPosition:CGPointMake(16.5, 25)
                                              pathRect:CGRectMake(0, 0, radius * 2, radius * 2)
                                                radius:radius];

    
    
    [annotationView.layer addSublayer:_circleShape];
    
    CAAnimationGroup *groupAnimation = [self createFlashAnimationWithScale:scale duration:1.0f];
    
    [_circleShape addAnimation:groupAnimation forKey:nil];
}

- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position pathRect:(CGRect)rect radius:(CGFloat)radius
{
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
    circleShape.position = position;
    
    
    circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    circleShape.fillColor = [UIColor grayColor].CGColor;
    
    //  圆圈放大效果
    //  circleShape.fillColor = [UIColor clearColor].CGColor;
    //  circleShape.strokeColor = [UIColor purpleColor].CGColor;
    
    circleShape.opacity = 0;
    circleShape.lineWidth = 1;
    
    return circleShape;
}

- (CGPathRef)createCirclePathWithRadius:(CGRect)frame radius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}


- (CAAnimationGroup *)createFlashAnimationWithScale:(CGFloat)scale duration:(CGFloat)duration
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    _animationGroup = [CAAnimationGroup animation];
    _animationGroup.animations = @[scaleAnimation, alphaAnimation];
    _animationGroup.duration = duration;
    _animationGroup.repeatCount = INFINITY;
    _animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return _animationGroup;
}


- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
   
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

- (void)popActWithOrderType:(NSString *)type {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.seekPopBlock) {
        self.seekPopBlock(_orderId, type);
    }
}



@end

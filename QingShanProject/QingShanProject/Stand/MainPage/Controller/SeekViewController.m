//
//  SeekViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/18.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "SeekViewController.h"
#import "WaitTitleView.h"


#define WZFlashInnerCircleInitialRaius  20


@interface SeekViewController () <BMKMapViewDelegate>
{
    NSTimer *timer;
}

@property (strong, nonatomic) BMKMapView *mapView;
@property (nonatomic, strong) BMKPointAnnotation *centerPoint;

@property(nonatomic, strong)CAShapeLayer *circleShape;
@property(nonatomic, strong)CAAnimationGroup *animationGroup;
@property(nonatomic, strong)WaitTitleView *waitTitleView;






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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
        
    } withCancelBlock:^{
        
    }];
}


- (void)initView {
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT)];
    _mapView.zoomLevel = 13;
    _mapView.zoomEnabled = YES;
    _mapView.showMapScaleBar = YES;
    _mapView.delegate = self;
    _mapView.scrollEnabled = NO;
    
    [self.view addSubview:_mapView];
    
    
    //添加拖动的大头针
    _centerPoint = [[BMKPointAnnotation alloc]init];
    _centerPoint.coordinate = _sendPt;
    _centerPoint.title = @"检索中点";
    [_mapView addAnnotation:_centerPoint];
    
    _mapView.centerCoordinate = _sendPt;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAct) userInfo:nil repeats:YES];

}

- (void)timeAct {
    long long nowTimeLong = [[NSDate date] timeIntervalSince1970];
    NSInteger timerCount = nowTimeLong - _createTime;
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


@end

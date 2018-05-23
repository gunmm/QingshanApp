//
//  Location.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/17.
//  Copyright © 2017年 北京仝仝科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <CoreLocation/CoreLocation.h>

@interface Location()<BMKLocationServiceDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) CLLocationManager *lcManager;

@property (nonatomic, assign) BOOL deferringUpdates;

@property (nonatomic, assign) NSInteger countt;




@end

@implementation Location




+ (instancetype)sharedLocation
{
    static Location *_sharedLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      
                      _sharedLocation = [[Location alloc] init];
                      
                  });
    
    return _sharedLocation;
}


- (void)startLocationService
{
    
    NSLog(@"location start");
    
    
    [self initLocation];
    
    
    
    //    if (!_locService)
    //    {
    //        NSLog(@"sevice is nil");
    //
    //        _locService = [[BMKLocationService alloc]init];
    //        _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //        _locService.distanceFilter = 1.0f;
    //
    //
    //        _locService.delegate = self;
    //
    //        [_locService startUserLocationService];
    //
    //
    //
    //
    //
    //
    //    }
    //    else
    //    {
    //        NSLog(@"sevice is not nil");
    //    }
}


- (void)stopLocationService
{
    if (_lcManager) {
        [_lcManager stopUpdatingHeading];
        _lcManager = nil;
        NSLog(@"停止定位服务");
    }
}


/**
 *初始化定位
 */
-(void)initLocation
{
    
    _lcManager = [[CLLocationManager alloc] init];
    
    _lcManager.delegate = self;
    _lcManager.desiredAccuracy = kCLLocationAccuracyBest;
    _lcManager.pausesLocationUpdatesAutomatically = NO;
//    _lcManager.allowsBackgroundLocationUpdates = YES;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
//    {
//        [_lcManager requestWhenInUseAuthorization];
//    }
    
    if ([_lcManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [_lcManager requestAlwaysAuthorization];
        [_lcManager requestWhenInUseAuthorization];
    }
    
//    if ([_lcManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
//        [_lcManager setAllowsBackgroundLocationUpdates:YES];
//    }
    
   
    
    
    [_lcManager startUpdatingLocation];
}


/**
 定位成功
 
 @param manager <#manager description#>
 @param locations <#locations description#>
 */

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    double lat = location.coordinate.latitude;
    double lng = location.coordinate.longitude;
    
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(lat, lng);
    NSDictionary *bmLoc = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D bdCoor = BMKCoorDictionaryDecode(bmLoc);
//    _countt++;
//    [HUDClass showHUDWithText:[NSString stringWithFormat:@"count ===== %ld", _countt]];
//    NSLog(@"count ============================== %ld",_countt);
    NSLog(@"------lat:%f, ------lng:%f", bdCoor.latitude, bdCoor.longitude);
    
    if (!self.deferringUpdates) {
        
        [_lcManager allowDeferredLocationUpdatesUntilTraveled:500 timeout:30];
        
        self.deferringUpdates = YES;
    }
    
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:location forKey:User_Location];
    
    NSNotification *notification =[NSNotification notificationWithName:Location_Complete object:nil userInfo:userInfo];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


/**
 定位失败
 
 @param manager <#manager description#>
 @param error <#error description#>
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSNotification *notification =[NSNotification notificationWithName:Location_Complete object:nil userInfo:nil];
    self.deferringUpdates = NO;
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}








/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coor = userLocation.location.coordinate;
    
    NSLog(@"bd====lat:%lf, bd====lng:%lf", coor.latitude, coor.longitude);
    
    //关闭定位
    [_locService stopUserLocationService];
    
    _locService = nil;
    
    
    NSLog(@"before send notify");
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:userLocation forKey:User_Location];
    
    NSNotification *notification =[NSNotification notificationWithName:Location_Complete object:nil userInfo:userInfo];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locService stopUserLocationService];
    
    _locService = nil;
    
    NSNotification *notification =[NSNotification notificationWithName:Location_Complete object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@", userLocation.heading);
}



+ (CLLocationDistance)distancePoint:(CLLocationCoordinate2D)point1 with:(CLLocationCoordinate2D)point2
{
    BMKMapPoint p1 = BMKMapPointForCoordinate(point1);
    BMKMapPoint p2 = BMKMapPointForCoordinate(point2);
    
    return  BMKMetersBetweenMapPoints(p1,p2);
}

@end

//
//  NavBgImage.m
//  wiseCloudCrm
//
//  Created by 闵哲 on 16/7/18.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "NavBgImage.h"
#import <MMDrawerController/MMDrawerController.h>

@implementation NavBgImage

#pragma mark---------用颜色创建图片
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark---------判断当前显示VC是不是模态视图
//判断当前显示VC是不是模态视图
+ (BOOL)judgeCurrentVCIspresented {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    if ([rootViewController presentedViewController]) {
        return YES;
    }
    return NO;
}


#pragma mark---------获取当前屏幕显示的viewcontroller
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [NavBgImage getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else if ([rootVC isKindOfClass:[MMDrawerController class]]){
        // 根视图为MMDrawerController
        if (((MMDrawerController *)rootVC).openSide == MMDrawerSideNone) {
            currentVC = [self getCurrentVCFrom:((MMDrawerController *)rootVC).centerViewController];
        }else if (((MMDrawerController *)rootVC).openSide == MMDrawerSideLeft){
            currentVC = [self getCurrentVCFrom:((MMDrawerController *)rootVC).leftDrawerViewController];
        }else{
            currentVC = [self getCurrentVCFrom:((MMDrawerController *)rootVC).rightDrawerViewController];
        }
        
    }else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

#pragma mark---------设置google字体图标

+ (NSString *)getGoogleIconWithIconHexString:(NSString *)iconStr
{
    NSString *unicodeStr = [NSString stringWithFormat:@"\\u%@", iconStr];
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
//    [NSPropertyListSerialization propertyListFromData:tempData
//                                                           mutabilityOption:NSPropertyListImmutable
//                                                                     format:NULL
//                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}




//设置google字体图标
+ (void)showGoogleIconForView:(UIView *)view iconName:(NSString *)iconName color:(UIColor *)iconColor font:(CGFloat)iconFont suffix:(NSString *)suffix{
    if([view isKindOfClass:[UIButton class]]){
        
        if(suffix){
            [(UIButton *)view setTitle:[NSString stringWithFormat:@"%@%@",iconName,suffix] forState:UIControlStateNormal];
        }else{
            [(UIButton *)view setTitle:iconName forState:UIControlStateNormal];
        }
        [((UIButton *)view).titleLabel setFont:[UIFont fontWithName:@"MaterialIcons-Regular" size:iconFont]];
        [(UIButton *)view setTitleColor:iconColor forState:UIControlStateNormal];
        
    }else if([view isKindOfClass:[UILabel class]]){
        if(suffix){
            [(UILabel *)view setText:[NSString stringWithFormat:@"%@%@",iconName,suffix]];
        }else{
            [(UILabel *)view setText:[NSString stringWithFormat:@"%@",iconName]];
        }
        [(UILabel *)view setFont:[UIFont fontWithName:@"Material Icons" size:iconFont]];
        [(UILabel *)view setTextColor:iconColor];
    }
}


+ (UIColor *)getColorByString:(NSString *)str {
    NSInteger hexCode = [str hash];
    int index = hexCode % 12;
    if (index < 0) {
        index = 0;
    }
    return [@[
              [UIColor colorWithRed:0.278 green:0.651 blue:0.875 alpha:1.000],
              [UIColor colorWithRed:0.945 green:0.576 blue:0.200 alpha:1.000],
              [UIColor colorWithRed:0.184 green:0.753 blue:0.482 alpha:1.000],
              [UIColor colorWithRed:0.973 green:0.380 blue:0.380 alpha:1.000],
              [UIColor colorWithRed:0.298 green:0.820 blue:0.655 alpha:1.000],
              [UIColor colorWithRed:0.063 green:0.682 blue:1.000 alpha:1.000],
              [UIColor colorWithRed:0.090 green:0.812 blue:0.635 alpha:1.000],
              [UIColor colorWithRed:1.000 green:0.376 blue:0.000 alpha:1.000],
              [UIColor colorWithRed:0.925 green:0.773 blue:0.024 alpha:1.000],
              [UIColor colorWithRed:0.973 green:0.663 blue:0.000 alpha:1.000],
              [UIColor colorWithRed:0.941 green:0.400 blue:0.294 alpha:1.000],
              [UIColor colorWithRed:0.965 green:0.306 blue:0.471 alpha:1.000]
              ] objectAtIndex:index];
    
    //    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


//设置iconfont字体图标
+ (void)showIconFontForView:(UIView *)view iconName:(NSString *)iconName color:(UIColor *)iconColor font:(CGFloat)iconFont {
    if([view isKindOfClass:[UIButton class]]){
        [(UIButton *)view setTitle:iconName forState:UIControlStateNormal];
        [((UIButton *)view).titleLabel setFont:[UIFont fontWithName:@"iconfont" size:iconFont]];
        [(UIButton *)view setTitleColor:iconColor forState:UIControlStateNormal];
    }else if([view isKindOfClass:[UILabel class]]){
        [(UILabel *)view setText:[NSString stringWithFormat:@"%@",iconName]];
        [(UILabel *)view setFont:[UIFont fontWithName:@"iconfont" size:iconFont]];
        [(UILabel *)view setTextColor:iconColor];
    }
}



+ (CGFloat)BMapSetPointCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2 {
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

+ (CLLocationCoordinate2D)BMapGetCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2 {
    double lat1 = point1.latitude;
    double lng1 = point1.longitude;
    
    double lat2 = point2.latitude;
    double lng2 = point2.longitude;
    
    double pointLng = (lng1 + lng2) / 2;
    double pointLat = (lat1 + lat2) / 2;
    
    
    return CLLocationCoordinate2DMake(pointLat, pointLng);
}


@end

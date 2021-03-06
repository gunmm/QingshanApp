//
//  NavBgImage.h
//  wiseCloudCrm
//
//  Created by 闵哲 on 16/7/18.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>


@interface NavBgImage : UIImage

+ (UIImage *)imageWithImage:(UIImage *)image TintColor:(UIColor *)tintColor;

//用颜色创建图片
+ (UIImage *)createImageWithColor:(UIColor*) color;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

+ (void)showGoogleIconForView:(UIView *)view iconName:(NSString *)iconName color:(UIColor *)iconColor font:(CGFloat)iconFont suffix:(NSString *)suffix;


+ (UIColor *)getColorByString:(NSString *)str;

+ (void)showIconFontForView:(UIView *)view iconName:(NSString *)iconName color:(UIColor *)iconColor font:(CGFloat)iconFont;


+ (CGFloat)BMapSetPointCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2;
+ (CLLocationCoordinate2D)BMapGetCenterWithPoint11:(CLLocationCoordinate2D)point1 withPoint2:(CLLocationCoordinate2D)point2;


#pragma mark---------判断当前显示VC是不是模态视图
//判断当前显示VC是不是模态视图
+ (BOOL)judgeCurrentVCIspresented;



@end

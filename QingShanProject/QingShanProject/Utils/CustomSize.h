//
//  CustomSize.h
//  ConcreteCloud
//
//  Created by gunmm on 2017/10/18.
//  Copyright © 2017年 北京仝仝科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomSize : NSObject

//pragma mark------当前屏幕尺寸
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width

//pragma mark------各种iPhone尺寸
#define IPHONE_3_5_WIDTH 320
#define IPHONE_3_5_HEIGHT 480

#define IPHONE_4_0_WIDTH 320
#define IPHONE_4_0_HEIGHT 568

#define IPHONE_4_7_WIDTH 375
#define IPHONE_4_7_HEIGHT 667

#define IPHONE_5_5_WIDTH 414
#define IPHONE_5_5_HEIGHT 736

#define IPHONE_5_8_WIDTH 375
#define IPHONE_5_8_HEIGHT 812

//pragma mark------判断当前设备的尺寸
#define IS_IPHONE_3_5 (kDeviceHeight>kDeviceWidth?kDeviceHeight:kDeviceWidth) == IPHONE_3_5_HEIGHT
#define IS_IPHONE_4_0 (kDeviceHeight>kDeviceWidth?kDeviceHeight:kDeviceWidth) == IPHONE_4_0_HEIGHT
#define IS_IPHONE_4_7 (kDeviceHeight>kDeviceWidth?kDeviceHeight:kDeviceWidth) == IPHONE_4_7_HEIGHT
#define IS_IPHONE_5_5 (kDeviceHeight>kDeviceWidth?kDeviceHeight:kDeviceWidth) == IPHONE_5_5_HEIGHT
#define IS_IPHONE_5_8 (kDeviceHeight>kDeviceWidth?kDeviceHeight:kDeviceWidth) == IPHONE_5_8_HEIGHT

//pragma mark------状态栏高度
#define STATUS_HEIGHT (CGFloat)(IS_IPHONE_5_8 ? 44 : 20)

//pragma mark------导航栏高度
#define NAVBAR_HEIGHT (CGFloat)(IS_IPHONE_5_8 ? 44 : 44)

//pragma mark------状态栏+导航栏高度
#define STATUS_AND_NAVBAR_HEIGHT (CGFloat)(IS_IPHONE_5_8 ? 88 : 64)

//pragma mark------标签栏高度
#define TABBAR_HEIGHT (CGFloat)(IS_IPHONE_5_8 ? 83 : 49)

//pragma mark------iPhone X 底部高度
#define TABBAR_BOTTOM_HEIGHT (CGFloat)(IS_IPHONE_5_8 ? 34 : 0)









@end

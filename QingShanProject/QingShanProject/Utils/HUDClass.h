//
//  HUDClass.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京仝仝科技有限公司. All rights reserved.
//

#ifndef HUDClass_h
#define HUDClass_h

#import "MBProgressHUD.h"

@interface HUDClass: NSObject


/**
 显示提示内容
 **/

+ (void)showHUDWithText:(NSString *)text;


+ (void)showHUDWithLabel:(NSString *)content view:(UIView *)view;
//__deprecated_msg("已过期");


/**
 loading视图
 **/
+ (MBProgressHUD *)showLoadingHUD:(UIView *)view;
//__deprecated_msg("已过期");

/**
loading视图
**/
+ (MBProgressHUD *)showLoadingHUD;

/**
 隐藏loading视图
 **/
+ (void)hideLoadingHUD:(MBProgressHUD *)hud;

@end


#endif /* HUDClass_h */

//
//  HUDClass.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京仝仝科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUDClass.h"
#import "AppDelegate.h"

@interface HUDClass()

@end

@implementation HUDClass

+ (void)showHUDWithText:(NSString *)text
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[delegate window] animated:YES];
    
    [[delegate window] bringSubviewToFront:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    hud.labelText = text;
    [hud hide:YES afterDelay:1.5f];

}

+ (MBProgressHUD *)showLoadingHUD
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[delegate window]];
    
    hud.minSize = CGSizeMake(80.0f, 80.0f);
    hud.removeFromSuperViewOnHide = YES;
    
    [[delegate window] addSubview:hud];
    
    [hud show:YES];
    
    
    [[delegate window] bringSubviewToFront:hud];
    
    return hud;
}

+ (void)showHUDWithLabel:(NSString *)content view:(UIView *)view
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[delegate window] animated:YES];
    
    [[delegate window] bringSubviewToFront:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    hud.labelText = content;
    [hud hide:YES afterDelay:1.5f];
}

+ (MBProgressHUD *)showLoadingHUD:(UIView *)view
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[delegate window]];
    
    hud.minSize = CGSizeMake(80.0f, 80.0f);
    hud.removeFromSuperViewOnHide = YES;
    
    [[delegate window] addSubview:hud];
    
    [hud show:YES];
    
    
    [[delegate window] bringSubviewToFront:hud];
    
    return hud;
}

+ (void)hideLoadingHUD:(MBProgressHUD *)hud
{
    if (hud)
    {
        [hud hide:YES];
    }
    
//    if ([hud superview])
//    {
//        [hud hide:YES];
//    }
}

@end

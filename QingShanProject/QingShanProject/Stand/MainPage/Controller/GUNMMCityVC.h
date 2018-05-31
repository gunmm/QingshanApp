//
//  GUNMMCityVC.h
//  ChooseDay
//
//  Created by 闵哲 on 16/1/18.
//  Copyright © 2016年 DreamThreeMusketeers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^CityBlock)(NSString *cityName);

@interface GUNMMCityVC : BaseViewController

//block
- (void)getBlock:(CityBlock)cityBlock;

@end

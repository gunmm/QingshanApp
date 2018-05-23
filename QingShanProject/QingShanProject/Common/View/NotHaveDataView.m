//
//  NotHaveDataView.m
//  WeighUpSystem
//
//  Created by gunmm on 2018/1/22.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "NotHaveDataView.h"

@implementation NotHaveDataView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"NotHaveDataView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-STATUS_AND_NAVBAR_HEIGHT);
    }
    return self;
}


@end

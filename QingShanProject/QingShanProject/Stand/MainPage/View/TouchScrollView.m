//
//  TouchScrollView.m
//  QingShanProject
//
//  Created by gunmm on 2018/7/25.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "TouchScrollView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@implementation TouchScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = YES;
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    
    if ([NSStringFromClass([view class]) isEqualToString:@"BMKTapDetectingView"]) {
        return NO;
    }
    
    return YES;
}

@end

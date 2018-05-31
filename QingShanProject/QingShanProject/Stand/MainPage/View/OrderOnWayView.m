//
//  OrderOnWayView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/24.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "OrderOnWayView.h"

@implementation OrderOnWayView






- (void)awakeFromNib {
    [super awakeFromNib];
    
    _callBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _serviceBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _nameBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [NavBgImage showIconFontForView:_starLabel iconName:@"\U0000e60a" color:[UIColor colorWithRed:254/255.0 green:202/255.0 blue:15/255.0 alpha:1] font:10];
    
    _plateNumberLabel.layer.cornerRadius = 2;
    _plateNumberLabel.layer.masksToBounds = YES;
    _plateNumberLabel.layer.borderWidth = 0.3;
    _plateNumberLabel.layer.borderColor = mainColor.CGColor;
    
}


- (void)layoutSubviews {
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor = [UIColor whiteColor].CGColor;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.3f;
    sublayer.shadowRadius = 2.f;
    sublayer.shadowOffset = CGSizeMake(0,0);
    sublayer.frame = self.bounds;
    [_bgView.layer addSublayer:sublayer];
    [sublayer setNeedsDisplay];
    CALayer *corLayer = [CALayer layer];
    corLayer.frame = sublayer.bounds;
    corLayer.cornerRadius = 2;
    sublayer.cornerRadius = 2;
    corLayer.masksToBounds = YES;
    [sublayer addSublayer:corLayer];
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    [_nameBtn setTitle:[NSString stringWithFormat:@"%@师傅",[_userModel.nickname substringToIndex:1]] forState:UIControlStateNormal];
    _plateNumberLabel.text = userModel.plateNumber;
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f", userModel.score];
    
}

- (void)setOrderModel:(OrderModel *)orderModel {
    _orderModel = orderModel;
    _typeLabel.text = _orderModel.carTypeName;

}

- (void)setDrivingRouteLine:(BMKDrivingRouteLine *)drivingRouteLine {
    _drivingRouteLine = drivingRouteLine;
    NSString *timeStr;
    if (_drivingRouteLine.duration.dates > 0) {
        timeStr = [NSString stringWithFormat:@"%d天%d小时%d分钟",_drivingRouteLine.duration.dates, _drivingRouteLine.duration.hours, _drivingRouteLine.duration.minutes];
    }else if (_drivingRouteLine.duration.hours > 0) {
        timeStr = [NSString stringWithFormat:@"%d小时%d分钟",_drivingRouteLine.duration.hours, _drivingRouteLine.duration.minutes];
    }else{
        timeStr = [NSString stringWithFormat:@"%d分钟",_drivingRouteLine.duration.minutes];
    }
    
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f公里",_drivingRouteLine.distance/1000.0];
    if ([_orderModel.status isEqualToString:@"1"]) {
        _timeLabel.text = [NSString stringWithFormat:@"司机距离%@，大约%@后到达发货地址",distanceStr, timeStr];
    }else {
        _timeLabel.text = [NSString stringWithFormat:@"剩余距离%@，大约%@后到达收货地址",distanceStr, timeStr];

    }
    
}

- (IBAction)callPhoneBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_userModel.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}

- (IBAction)callServiceBtnAct:(id)sender {
}




@end
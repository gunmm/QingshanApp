//
//  DriverOrderDetailView.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/5.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverOrderDetailView.h"

@implementation DriverOrderDetailView


- (void)awakeFromNib {
    [super awakeFromNib];
    _callBtn.layer.cornerRadius = 4;
    _callBtn.layer.masksToBounds = YES;
    _callBtn.layer.borderColor = mainColor.CGColor;
    _callBtn.layer.borderWidth = 0.5;
    _callBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _beginBtn.layer.cornerRadius = 4;
    _beginBtn.layer.masksToBounds = YES;
    
    _reciverGoodsBtn.layer.cornerRadius = 4;
    _reciverGoodsBtn.layer.masksToBounds = YES;
    
    _finishBtn.layer.cornerRadius = 4;
    _finishBtn.layer.masksToBounds = YES;
    
    _payStatusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _nameBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
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

- (void)setModel:(OrderModel *)model {
    _model = model;
    [_nameBtn setTitle:[NSString stringWithFormat:@"%@货主",[_model.linkMan substringToIndex:1]] forState:UIControlStateNormal];
    
    if ([_model.type isEqualToString:@"2"]) {
        _beginBtn.hidden = NO;
        if ([_model.appointStatus isEqualToString:@"1"] || [_model.status isEqualToString:@"9"]) {
            _beginBtn.backgroundColor = [UIColor grayColor];
            [_beginBtn setTitleColor:bgColor forState:UIControlStateNormal];
            _beginBtn.enabled = NO;
        }else{
            _beginBtn.backgroundColor = mainColor;
            [_beginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _beginBtn.enabled = YES;
        }
    }else{
        _beginBtn.hidden = YES;
    }
    
    
    if ([_model.status isEqualToString:@"1"] && ([_model.appointStatus isEqualToString:@"1"] || _model.appointStatus.length == 0)) {
        _reciverGoodsBtn.backgroundColor = mainColor;
        [_reciverGoodsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reciverGoodsBtn.enabled = YES;
    }else {
        _reciverGoodsBtn.backgroundColor = [UIColor grayColor];
        [_reciverGoodsBtn setTitleColor:bgColor forState:UIControlStateNormal];
        _reciverGoodsBtn.enabled = NO;
        if ([_model.appointStatus isEqualToString:@"0"]) {
            _orderDetailLabel.text = @"等待司机开始执行订单";
        }
    }
        
    if ([_model.status isEqualToString:@"2"]) {
        _finishBtn.backgroundColor = mainColor;
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishBtn.enabled = YES;
    }else {
        _finishBtn.backgroundColor = [UIColor grayColor];
        [_finishBtn setTitleColor:bgColor forState:UIControlStateNormal];
        _finishBtn.enabled = NO;
    }
    
    
    if ([_model.status isEqualToString:@"3"]) {
        _orderDetailLabel.text = @"订单完成";
    }else if ([_model.status isEqualToString:@"9"]) {
        _orderDetailLabel.text = @"订单取消";
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_model.price];

    
    //支付方式   1:支付宝支付    2:微信支付   3:现金支付
    if ([_model.payType isEqualToString:@"1"]) {
        [_payStatusBtn setImage:[UIImage imageNamed:@"pay_icon_alipay"] forState:UIControlStateNormal];
    }else if ([_model.payType isEqualToString:@"2"]) {
        [_payStatusBtn setImage:[UIImage imageNamed:@"pay_icon_wechat"] forState:UIControlStateNormal];
        
    }else if ([_model.payType isEqualToString:@"3"]) {
        [_payStatusBtn setImage:[UIImage imageNamed:@"pay_icon_crash"] forState:UIControlStateNormal];
        
    }
    
    //支付状态   0:未支付   1:已支付
    if ([_model.payStatus isEqualToString:@"0"]) {
        [_payStatusBtn setTitle:@"未支付" forState:UIControlStateNormal];
    }else{
        [_payStatusBtn setTitle:@"已支付" forState:UIControlStateNormal];
    }
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
    if ([_model.status isEqualToString:@"1"]) {
        _orderDetailLabel.text = [NSString stringWithFormat:@"司机距离%@，大约%@后到达发货地址",distanceStr, timeStr];
    }else {
        _orderDetailLabel.text = [NSString stringWithFormat:@"剩余距离%@，大约%@后到达收货地址",distanceStr, timeStr];
        
    }
    
}



- (IBAction)callBtnAct:(UIButton *)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.linkPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}

- (IBAction)beginBtnAct:(UIButton *)sender {
    if (self.beginAppointOrderBlock) {
        self.beginAppointOrderBlock();
    }
}
- (IBAction)recivrerGoodsAct:(id)sender {
    if (self.reciverGoodsBlock) {
        self.reciverGoodsBlock();
    }
}

- (IBAction)finishBtnAct:(UIButton *)sender {
    if (self.finishOrderBlock) {
        self.finishOrderBlock();
    }
}



@end

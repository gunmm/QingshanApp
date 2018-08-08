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
    
    
    _cancleOrderBtn.layer.cornerRadius = 4;
    _cancleOrderBtn.layer.masksToBounds = YES;
    
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    
    
    
    
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
    [_timer invalidate];
    [_nameBtn setTitle:[NSString stringWithFormat:@"%@货主",[_model.linkMan substringToIndex:1]] forState:UIControlStateNormal];
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_model.price];
    //支付状态
    if ([_model.freightFeePayStatus isEqualToString:@"1"]) {
        [_payStatusBtn setTitle:@"线上已支付" forState:UIControlStateNormal];
        [_payStatusBtn setTitleColor:mainColor forState:UIControlStateNormal];
    }else{
        [_payStatusBtn setTitle:@"等待线下支付" forState:UIControlStateNormal];
        [_payStatusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    if ([_model.status isEqualToString:@"1"]) { //抢到订单未支付服务费
        _callBtn.hidden = YES;
        _serviceFeeBgView.hidden = NO;
        _serviceFeeBtnBgView.hidden = NO;
        
        CGFloat serviceFee = _model.price * 0.03;
        if (serviceFee > 300) {
            serviceFee = 300;
        }
        
        _serviceFeeLabel.text = [NSString stringWithFormat:@"需要支付服务费%.2f元",serviceFee];
        
        long long nowTimeLong = [[NSDate new] timeIntervalSince1970] * 1000;
        long long reallyTimeLong = _model.timeOut - nowTimeLong;
        if (reallyTimeLong > 0) {
            NSInteger minute = reallyTimeLong/60/1000;
            NSInteger second = reallyTimeLong/1000%60;
            _timeLabel.text = [NSString stringWithFormat:@"支付剩余%ld分%ld秒", (long)minute,(long)second];
            [_timer invalidate];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
            
        }else {
            _timeLabel.text = @"支付已超时";
            [_timer invalidate];
            [self endOrder];
        }
        
    }else {//抢到订单已支付服务费
        _callBtn.hidden = NO;
        _serviceFeeBgView.hidden = YES;
        _serviceFeeBtnBgView.hidden = YES;
        if ([_model.type isEqualToString:@"2"]) { //预约订单
            _beginBtn.hidden = NO;  //显示开始执行按钮
            if ([_model.appointStatus isEqualToString:@"1"] || [_model.status isEqualToString:@"9"]) { //订单已经开始执行   或者订单取消   将开始按钮置未不可用
                _beginBtn.backgroundColor = [UIColor grayColor];
                [_beginBtn setTitleColor:bgColor forState:UIControlStateNormal];
                _beginBtn.enabled = NO;
            }else{ //还未开始执行
                _beginBtn.backgroundColor = mainColor;
                [_beginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _beginBtn.enabled = YES;
            }
        }else{
            _beginBtn.hidden = YES;
        }
        
        
        if ([_model.status isEqualToString:@"2"] && ([_model.appointStatus isEqualToString:@"1"] || _model.appointStatus.length == 0)) {
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
        
        if ([_model.status isEqualToString:@"3"]) {
            _finishBtn.backgroundColor = mainColor;
            [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _finishBtn.enabled = YES;
        }else {
            _finishBtn.backgroundColor = [UIColor grayColor];
            [_finishBtn setTitleColor:bgColor forState:UIControlStateNormal];
            _finishBtn.enabled = NO;
        }
        
        
        if ([_model.status isEqualToString:@"4"]) {
            _orderDetailLabel.text = @"订单完成";
        }else if ([_model.status isEqualToString:@"9"]) {
            _orderDetailLabel.text = @"订单取消";
        }
        
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
    if ([_model.status isEqualToString:@"2"]) {
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


- (IBAction)cancelBtnAct:(id)sender {
    long long nowTimeLong = [[NSDate new] timeIntervalSince1970] * 1000;
    long long reallyTimeLong = _model.timeOut - nowTimeLong;
    if (reallyTimeLong <= 0) {
        if (self.orderTimeOutBlock) {
            self.orderTimeOutBlock();
        }
    }else{
        if (self.cancelOrderBlock) {
            self.cancelOrderBlock();
        }
    }
}

- (IBAction)servicePayBtnAct:(id)sender {
    long long nowTimeLong = [[NSDate new] timeIntervalSince1970] * 1000;
    long long reallyTimeLong = _model.timeOut - nowTimeLong;
    if (reallyTimeLong <= 0) {
        if (self.orderTimeOutBlock) {
            self.orderTimeOutBlock();
        }
    }else{
        if (self.servicePayOrderBlock) {
            self.servicePayOrderBlock();
        }
    }
    
}



- (void)timerAct {
    long long nowTimeLong = [[NSDate new] timeIntervalSince1970] * 1000;
    long long reallyTimeLong = _model.timeOut - nowTimeLong;
    if (reallyTimeLong > 0) {
        NSInteger minute = reallyTimeLong/(60*1000);
        NSInteger second = reallyTimeLong/1000%60;
        _timeLabel.text = [NSString stringWithFormat:@"支付剩余%ld分%ld秒", (long)minute,(long)second];
        
    }else {
        _timeLabel.text = @"支付已超时";
        [_timer invalidate];
        [self endOrder];
        
    }
}


- (void)endOrder {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
    [param setObject:self.model.orderId forKey:@"orderId"];
    
    [NetWorking postDataWithParameters:param withUrl:@"driverGiveUpOrder" withBlock:^(id result) {
        if (self.orderTimeOutBlock) {
            self.orderTimeOutBlock();
        }
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}


- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}



@end

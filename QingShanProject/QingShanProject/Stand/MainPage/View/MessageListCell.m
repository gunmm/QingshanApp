//
//  MessageListCell.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/7.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _redView.layer.cornerRadius = 4;
    _redView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    if (!_sublayer) {
        _sublayer = [CALayer layer];
        _sublayer.backgroundColor = [UIColor whiteColor].CGColor;
        _sublayer.shadowColor = [UIColor blackColor].CGColor;
        _sublayer.shadowOpacity = 0.3f;
        _sublayer.shadowRadius = 6.f;
        _sublayer.shadowOffset = CGSizeMake(0,0);
        _sublayer.frame = CGRectMake(0, 0, kDeviceWidth-16, 74);
        [_bgView.layer addSublayer:_sublayer];
        [_sublayer setNeedsDisplay];
        CALayer *corLayer = [CALayer layer];
        corLayer.frame = _sublayer.bounds;
        corLayer.cornerRadius = 6;
        _sublayer.cornerRadius = 6;
        corLayer.masksToBounds = YES;
        [_sublayer addSublayer:corLayer];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MessageModel *)model {
    _model = model;
    _timeLabel.text = [self setTimeStrWithStr:_model.createTime];
    if ([_model.messageType isEqualToString:@"newOrderNotify"]) {
        _titleLabel.text = @"有新的订单";
        _contentLabel.text = @"有新的可操作订单，点击查看详情";
    }else if ([_model.messageType isEqualToString:@"OrderBeCanceledNotify"]) {
        _titleLabel.text = @"订单被取消";
        _contentLabel.text = @"已接订单被取消，点击查看详情";
    }else if ([_model.messageType isEqualToString:@"OrderBeReceivedNotify"]) {
        _titleLabel.text = @"订单状态更新";
        if ([_model.orderStatus isEqualToString:@"1"]) {
            _contentLabel.text = @"您的订单被抢单，点击查看详情";
        }else if ([_model.orderStatus isEqualToString:@"2"]) {
            _contentLabel.text = @"您的订单已被最终确认，点击查看详情";
        }else if ([_model.orderStatus isEqualToString:@"3"]) {
            _contentLabel.text = @"您的订单货物已接到，点击查看详情";
        }else if ([_model.orderStatus isEqualToString:@"4"]) {
            _contentLabel.text = @"您的订单货物已送达目的地，点击查看详情";
        }
    }else if ([_model.messageType isEqualToString:@"AppointOrderBeginNotify"]) {
        _titleLabel.text = @"订单状态更新";
        _contentLabel.text = @"司机开始处理您的预约订单，点击查看详情";

    }else if ([_model.messageType isEqualToString:@"ComplainHasBeManage"]) {
        _titleLabel.text = @"投诉被处理";
        _contentLabel.text = @"您的订单投诉被处理，点击查看详情";
        
    }
    
    if ([_model.isRead isEqualToString:@"1"]) {
        _redView.hidden = YES;
    }else {
        _redView.hidden = NO;
    }
}


- (NSString *)setTimeStrWithStr:(long long)timeLonglong {
    NSString *timeStr = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:timeLonglong/1000]];
    long long reallytLongTime = timeLonglong/1000;
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    
    NSString *zeroStr = [format stringFromDate:[NSDate new]];
    NSDate *zeroDate = [format dateFromString:zeroStr];
    
    long long todayZeroLongLong = [zeroDate timeIntervalSince1970] ;
    long long yesterdayZeroLongLong = [zeroDate timeIntervalSince1970] - 3600*24;
    long long beforeYesterdayZeroLongLong = [zeroDate timeIntervalSince1970] - 3600*24*2;
    
    NSString *showStr = @"";
    if (reallytLongTime > todayZeroLongLong) {
        showStr = [timeStr substringWithRange:NSMakeRange(11, 8)];
    }else if (reallytLongTime > yesterdayZeroLongLong){
        showStr = [NSString stringWithFormat:@"昨天%@",[timeStr substringWithRange:NSMakeRange(11, 8)]];
    }else if (reallytLongTime > beforeYesterdayZeroLongLong){
        showStr = [NSString stringWithFormat:@"前天%@",[timeStr substringWithRange:NSMakeRange(11, 8)]];
    }else{
        showStr = timeStr;
    }
    return showStr;
}

@end

//
//  OrderListCell.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/28.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _sendSignView.layer.cornerRadius = 4;
    _sendSignView.layer.masksToBounds = YES;
    
    _reciverSignView.layer.cornerRadius = 4;
    _reciverSignView.layer.masksToBounds = YES;
    
    [NavBgImage showIconFontForView:_appointTimeIconLabel iconName:@"\U0000e629" color:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] font:10];
    [NavBgImage showIconFontForView:_timeIconLabel iconName:@"\U0000e76c" color:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] font:10];


    
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    _carTypeLabel.text = _model.carTypeName;
    _createTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.createTime/1000]];
    _sendAddressLabel.text = _model.sendAddress;
    _reciverAddressLabel.text = _model.receiveAddress;
    if ([_model.type isEqualToString:@"1"]) {//实时
        _orderTypeLabel.text = @"实时";
        _orderTypeLabel.textColor = [UIColor colorWithRed:255/255.0 green:132/255.0 blue:60/255.0 alpha:1];
        _sendIconTop.constant = 10;
        _sendAddressLabelTop.constant = 7;
        _appointTimeIconLabel.hidden = YES;
        _appointTimeLbel.hidden = YES;
    }else {
        _orderTypeLabel.text = @"预约";
        _orderTypeLabel.textColor = [UIColor colorWithRed:60/255.0 green:175/255.0 blue:151/255.0 alpha:1];
        _sendIconTop.constant = 36;
        _sendAddressLabelTop.constant = 32;
        _appointTimeIconLabel.hidden = NO;
        _appointTimeLbel.hidden = NO;
        _appointTimeLbel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.appointTime/1000]];
    }
    if ([_model.status isEqualToString:@"0"]) {
        _statusLabel.text = @"等待接单 >";
        _statusLabel.textColor = [UIColor grayColor];
    }else if ([_model.status isEqualToString:@"1"]) {
        _statusLabel.text = @"等待确认 >";
        _statusLabel.textColor = [UIColor grayColor];
    }else if ([_model.status isEqualToString:@"2"]) {
        _statusLabel.textColor = [UIColor grayColor];
        if ([_model.appointStatus isEqualToString:@"0"]) {
            _statusLabel.text = @"等待执行 >";
        }else{
            _statusLabel.text = @"等待接货 >";
        }
    }else if ([_model.status isEqualToString:@"3"]) {
        _statusLabel.textColor = [UIColor grayColor];
        _statusLabel.text = @"已发货 >";
    }else if ([_model.status isEqualToString:@"4"]) {
        _statusLabel.textColor = [UIColor colorWithRed:159.0/255 green:159.0/255 blue:159.0/255 alpha:1];
        _statusLabel.text = @"已完成 >";
    }else if ([_model.status isEqualToString:@"9"]) {
        _statusLabel.textColor = [UIColor colorWithRed:159.0/255 green:159.0/255 blue:159.0/255 alpha:1];
        _statusLabel.text = @"已取消";
    }
    
}
@end

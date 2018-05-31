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
    
    [NavBgImage showIconFontForView:_timeIconLabel iconName:@"\U0000e629" color:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] font:10];

    
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    _carTypeLabel.text = _model.carTypeName;
    _createTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.createTime/1000]];
    _sendAddressLabel.text = _model.sendAddress;
    _reciverAddressLabel.text = _model.receiveAddress;
    if ([_model.status isEqualToString:@"0"]) {
        _statusLabel.text = @"等待接单 >";
    }else if ([_model.status isEqualToString:@"1"]) {
        _statusLabel.text = @"等待接货 >";
    }else if ([_model.status isEqualToString:@"2"]) {
        _statusLabel.text = @"已发货 >";
    }else if ([_model.status isEqualToString:@"3"]) {
        _statusLabel.text = @"已完成 >";
    }else if ([_model.status isEqualToString:@"9"]) {
        _statusLabel.text = @"已取消";
    }
    
}
@end

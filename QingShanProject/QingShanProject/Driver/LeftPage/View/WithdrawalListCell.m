//
//  WithdrawalListCell.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "WithdrawalListCell.h"

@implementation WithdrawalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(DriverWithdrawalListModel *)model {
    _model = model;
    _driverNameLabel.text = _model.toUserName;
    _bankCarNumberLabel.text = _model.toBankNumber;
    _timeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.driverWithdrawalTime/1000]];
    if ([_model.driverWithdrawalStatus isEqualToString:@"0"]) {
        _statusLabel.text = @"已提交";
    }else{
        _statusLabel.text = @"已打款";
    }
    _amountLabel.text = [NSString stringWithFormat:@"%@ 元", _model.driverWithdrawalAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

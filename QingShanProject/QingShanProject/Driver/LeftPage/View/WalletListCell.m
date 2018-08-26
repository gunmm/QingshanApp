//
//  WalletListCell.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "WalletListCell.h"

@implementation WalletListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    _orderIdLabel.text = _model.orderId;
    _carTypeNameLabel.text = _model.carTypeName;
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f公里", _model.distance];
    _finishTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.finishTime/1000]];
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", _model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  PayListCell.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "PayListCell.h"

@implementation PayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [NavBgImage showIconFontForView:_selectBtn iconName:@"\U0000e662" color:mainColor font:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (_indexPath.row == 0) {
        _imageV.image = [UIImage imageNamed:@"pay_icon_wechat"];
        _typeLabel.text = @"微信支付";
    }else if (_indexPath.row == 1) {
        _imageV.image = [UIImage imageNamed:@"pay_icon_alipay"];
        _typeLabel.text = @"支付宝支付";
    }else if (_indexPath.row == 2) {
        _imageV.image = [UIImage imageNamed:@"pay_icon_crash"];
        _typeLabel.text = @"现金支付";
    }
}

@end

//
//  PriceDeatilView.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "PriceDeatilView.h"

@implementation PriceDeatilView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [NavBgImage showIconFontForView:_closeBtn iconName:@"\U0000e70c" color:mainColor font:22];
    _despLabel.text = @"若产生高速费、停车费和搬运费，请用户额外支付\n若涉及逾时等候费，请与司机商量结算";
}


- (void)setRouteLine:(BMKDrivingRouteLine *)routeLine {
    _routeLine = routeLine;
    for (CarTypeModel *model in _carTypeList) {
        if ([model.keyText isEqualToString:_carTypeValueStr]) {
            _startPriceKeyLabel.text = [NSString stringWithFormat:@"起步价(%@)", model.valueText];
            _startPriceValueLabel.text = [NSString stringWithFormat:@"¥%.0f", model.startPrice];

            _unitPriceKeyLabel.text = [NSString stringWithFormat:@"超过里程(%.0f公里)",(_routeLine.distance/1000 - model.startDistance)>0 ? (_routeLine.distance/1000 - model.startDistance) : 0];
            _unitValueLabel.text = [NSString stringWithFormat:@"¥%.0f", model.unitPrice *((_routeLine.distance/1000 - model.startDistance)>0 ? (_routeLine.distance/1000 - model.startDistance) : 0)];

            _priceDetailLabel.text = [NSString stringWithFormat:@"¥ %.0f(总里程%d公里)", ((_routeLine.distance/1000 - model.startDistance)>0 ? (_routeLine.distance/1000 - model.startDistance) : 0) * model.unitPrice + model.startPrice, _routeLine.distance/1000];
            NSString *priceValueStr = [NSString stringWithFormat:@"%.0f", ((_routeLine.distance/1000 - model.startDistance)>0 ? (_routeLine.distance/1000 - model.startDistance) : 0) * model.unitPrice + model.startPrice];
            NSString *distanceStr = [NSString stringWithFormat:@"%d", _routeLine.distance/1000];
            NSString *priceDetailStr = [NSString stringWithFormat:@"¥%@(总里程%@公里)", priceValueStr, distanceStr];


            //创建富文本字符串
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:priceDetailStr];
            //设置个位
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, 1)];

            //设置十分位
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(1, priceValueStr.length)];


            [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(1+priceValueStr.length, distanceStr.length+7)];


//            //设置十分位 橙色
//            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(1, 2)];


            _priceDetailLabel.attributedText = attributedStr;
        }
    }

}

- (void)setOrderModel:(OrderModel *)orderModel {
    _orderModel = orderModel;
    if (_carTypeModel) {
        _startPriceKeyLabel.text = [NSString stringWithFormat:@"起步价(%@)", _carTypeModel.valueText];
        _startPriceValueLabel.text = [NSString stringWithFormat:@"¥%.0f", _carTypeModel.startPrice];
        
        _unitPriceKeyLabel.text = [NSString stringWithFormat:@"超过里程(%.0f公里)",(_orderModel.distance - _carTypeModel.startDistance)>0 ? (_orderModel.distance - _carTypeModel.startDistance) : 0];
        _unitValueLabel.text = [NSString stringWithFormat:@"¥%.0f", _carTypeModel.unitPrice *((_orderModel.distance - _carTypeModel.startDistance)>0 ? (_orderModel.distance - _carTypeModel.startDistance) : 0)];
        
        _priceDetailLabel.text = [NSString stringWithFormat:@"¥ %.0f(总里程%.0f公里)", ((_orderModel.distance - _carTypeModel.startDistance)>0 ? (_orderModel.distance - _carTypeModel.startDistance) : 0) * _carTypeModel.unitPrice + _carTypeModel.startPrice, _orderModel.distance];
        NSString *priceValueStr = [NSString stringWithFormat:@"%.0f", ((_orderModel.distance - _carTypeModel.startDistance)>0 ? (_orderModel.distance - _carTypeModel.startDistance) : 0) * _carTypeModel.unitPrice + _carTypeModel.startPrice];
        NSString *distanceStr = [NSString stringWithFormat:@"%.0f", _orderModel.distance];
        NSString *priceDetailStr = [NSString stringWithFormat:@"¥%@(总里程%@公里)", priceValueStr, distanceStr];
        
        
        //创建富文本字符串
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:priceDetailStr];
        //设置个位
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, 1)];
        
        //设置十分位
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30] range:NSMakeRange(1, priceValueStr.length)];
        
        
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(1+priceValueStr.length, distanceStr.length+7)];
    
        
        
        _priceDetailLabel.attributedText = attributedStr;
    }
}

- (IBAction)closeBtnAct:(id)sender {
    if (self.closeBtnActBlock) {
        self.closeBtnActBlock();
    }
}
@end

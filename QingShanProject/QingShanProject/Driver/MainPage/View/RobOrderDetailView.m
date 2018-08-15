//
//  RobOrderDetailView.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/10.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "RobOrderDetailView.h"

@implementation RobOrderDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _nameBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _payStatusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _callBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    
    _robBtn.layer.cornerRadius = 6;
    _robBtn.layer.masksToBounds = YES;

    
}

- (void)layoutSubviews {
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor = [UIColor whiteColor].CGColor;
    sublayer.shadowColor = [UIColor grayColor].CGColor;
    sublayer.shadowOpacity = 0.3f;
    sublayer.shadowRadius = 4.f;
    sublayer.shadowOffset = CGSizeMake(0,0);
    sublayer.frame = self.bounds;
    [_bgView.layer addSublayer:sublayer];
    [sublayer setNeedsDisplay];
    CALayer *corLayer = [CALayer layer];
    corLayer.frame = sublayer.bounds;
    corLayer.cornerRadius = 4;
    sublayer.cornerRadius = 4;
    corLayer.masksToBounds = YES;
    [sublayer addSublayer:corLayer];
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    [_nameBtn setTitle:[NSString stringWithFormat:@"%@货主",[_model.linkMan substringToIndex:1]] forState:UIControlStateNormal];
    if ([_model.type isEqualToString:@"1"]) {
        _typeLabel.text = @"实时";
        _typeLabel.textColor = [UIColor colorWithRed:255/255.0 green:132/255.0 blue:60/255.0 alpha:1];
        _appointTimeKeyLabel.hidden = YES;
        _appointTimeLabel.hidden = YES;
    }else {
        _typeLabel.text = @"预约";
        _typeLabel.textColor = [UIColor colorWithRed:60/255.0 green:175/255.0 blue:151/255.0 alpha:1];
        _appointTimeKeyLabel.hidden = NO;
        _appointTimeLabel.hidden = NO;
        _appointTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.appointTime/1000]];
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_model.price];
    
    //支付状态
    if ([_model.freightFeePayStatus isEqualToString:@"1"]) {
        [_payStatusBtn setTitle:@"线上已支付" forState:UIControlStateNormal];
        [_payStatusBtn setTitleColor:mainColor forState:UIControlStateNormal];
    }else{
        [_payStatusBtn setTitle:@"等待线下支付" forState:UIControlStateNormal];
        [_payStatusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }

    
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f公里",_model.distance];
    _noteLabel.text = _model.note.length > 0 ? _model.note : @"无";
    
    if ([_model.status isEqualToString:@"0"]) {
        _robBtn.enabled = YES;
        _robBtn.backgroundColor = mainColor;
        [_robBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        _robBtn.backgroundColor = [UIColor grayColor];
        [_robBtn setTitleColor:bgColor forState:UIControlStateNormal];
        _robBtn.enabled = NO;
        if ([_model.status isEqualToString:@"9"]) {
            [_robBtn setTitle:@"订单已取消" forState:UIControlStateNormal];
        }else{
            if ([_model.driverId isEqualToString:[[Config shareConfig] getUserId]]) {
                [_robBtn setTitle:@"已抢到" forState:UIControlStateNormal];
            } else {
                [_robBtn setTitle:@"订单已被抢" forState:UIControlStateNormal];
            }

        }
    }
}

- (IBAction)callBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.linkPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}

- (IBAction)robBtnAct:(id)sender {
    if (self.robBtnActBlock) {
        self.robBtnActBlock();
    }
}

@end

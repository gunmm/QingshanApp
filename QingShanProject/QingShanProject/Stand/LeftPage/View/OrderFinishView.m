//
//  OrderFinishView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/29.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "OrderFinishView.h"

@implementation OrderFinishView

- (void)awakeFromNib {
    [super awakeFromNib];
    _driverBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _callBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _serviceBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _complaintBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [NavBgImage showIconFontForView:_starLabel iconName:@"\U0000e60a" color:[UIColor colorWithRed:254/255.0 green:202/255.0 blue:15/255.0 alpha:1] font:10];
    
    _plateNumberLabel.layer.cornerRadius = 2;
    _plateNumberLabel.layer.masksToBounds = YES;
    _plateNumberLabel.layer.borderWidth = 0.3;
    _plateNumberLabel.layer.borderColor = mainColor.CGColor;
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
    if ([_model.appointStatus isEqualToString:@"0"]) {
        _waitLabel.hidden = NO;
        _waitLabel.text = @"等待司机开始订单";
    }else if ([_model.status isEqualToString:@"9"]) {
        _waitLabel.hidden = NO;
        _waitLabel.text = @"订单取消";
    }
    else {
        _waitLabel.hidden = YES;
    }
    _plateNumberLabel.text = _model.plateNumber.length > 0 ? _model.plateNumber : @"未被接单";
    [_driverBtn setTitle:_model.nickname.length > 0 ? [NSString stringWithFormat:@"%@师傅",[_model.nickname substringToIndex:1]] : @"" forState:UIControlStateNormal];
    _carTypeLabel.text = _model.carTypeName;
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f", _model.score];
}


- (IBAction)callBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}
- (IBAction)linkServiceBtnAct:(id)sender {
}
- (IBAction)complaintBtnAct:(id)sender {
}
- (IBAction)priceProblemBtnAct:(id)sender {
}
- (IBAction)commentBtnAct:(id)sender {
}

@end

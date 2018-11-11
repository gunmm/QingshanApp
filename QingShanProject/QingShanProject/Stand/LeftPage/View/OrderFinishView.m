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
    if (_model.commentStar > 0) {
        [_commentBtn setTitle:@"查看评价 >" forState:UIControlStateNormal];
    }
    if (_model.siteComplaintId.length > 0) {
        [_complaintBtn setTitle:@"已投诉" forState:UIControlStateNormal];
    }
    
    
    if ([_model.appointStatus isEqualToString:@"0"] && ![_model.status isEqualToString:@"9"] && ![_model.status isEqualToString:@"8"]) {
        _waitLabel.hidden = NO;
        _waitLabel.text = @"等待司机开始订单";
    }else if ([_model.status isEqualToString:@"9"]) {
        _waitLabel.hidden = NO;
        _waitLabel.text = @"订单取消";
        _callBtn.enabled = NO;
        _serviceBtn.enabled = NO;
        _complaintBtn.enabled = NO;
        _commentBtn.enabled = NO;
    }else if ([_model.status isEqualToString:@"8"]) {
        _waitLabel.hidden = NO;
        _waitLabel.text = @"订单已被置为异常状态";
    }
    else {
        _waitLabel.hidden = YES;
    }
    _plateNumberLabel.text = _model.plateNumber.length > 0 ? _model.plateNumber : @"未被接单";
    [_driverBtn setTitle:_model.nickname.length > 0 ? [NSString stringWithFormat:@"%@师傅",[_model.nickname substringToIndex:1]] : @"" forState:UIControlStateNormal];
    _carTypeLabel.text = _model.carTypeName;
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f", _model.score];
    _priceLabl.text = [NSString stringWithFormat:@"¥%.0f",_model.price];
}


- (IBAction)callBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}
- (IBAction)linkServiceBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[Config shareConfig] getServicePhone]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}
- (IBAction)complaintBtnAct:(id)sender {
    if (self.commentBtnActBlock) {
        self.complaintBtnActBlock();
    }
}
- (IBAction)priceProblemBtnAct:(id)sender {
    if (self.priceDetailBtnActBlock) {
        self.priceDetailBtnActBlock(_model);
    }
}
- (IBAction)commentBtnAct:(id)sender {
    BOOL hasCommit = NO;
    if (_model.commentStar > 0) {
        hasCommit = YES;
    }
    if (self.commentBtnActBlock) {
        self.commentBtnActBlock(hasCommit);
    }
    
    
}

@end

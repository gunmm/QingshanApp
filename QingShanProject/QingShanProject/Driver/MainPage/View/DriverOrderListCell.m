//
//  DriverOrderListCell.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverOrderListCell.h"

@implementation DriverOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _sendSingView.layer.cornerRadius = 4;
    _sendSingView.layer.masksToBounds = YES;
    
    _reciverSignView.layer.cornerRadius = 4;
    _reciverSignView.layer.masksToBounds = YES;
    
    [NavBgImage showIconFontForView:_appointTimeIconLabel iconName:@"\U0000e629" color:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] font:10];
    [NavBgImage showIconFontForView:_createTimeIconLabel iconName:@"\U0000e76c" color:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] font:10];

    
    _callBtn.layer.cornerRadius = 4;
    _callBtn.layer.masksToBounds = YES;
    _callBtn.layer.borderColor = mainColor.CGColor;
    _callBtn.layer.borderWidth = 0.8;
    
    _beginBtn.layer.cornerRadius = 4;
    _beginBtn.layer.masksToBounds = YES;
    
    _reciveGoodsBtn.layer.cornerRadius = 4;
    _reciveGoodsBtn.layer.masksToBounds = YES;
    
    _finishBtn.layer.cornerRadius = 4;
    _finishBtn.layer.masksToBounds = YES;
    
    _callBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _nameBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(OrderModel *)model {
    _model = model;
    
    [_nameBtn setTitle:[NSString stringWithFormat:@"%@货主",[_model.linkMan substringToIndex:1]] forState:UIControlStateNormal];
    _createTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.createTime/1000]];
    _sendAddressLabel.text = _model.sendDetailAddress;
    _reciverAddressLabel.text = _model.receiveDetailAddress;
    
    if ([_model.type isEqualToString:@"1"]) {//实时
        _orderType.text = @"实时";
        _orderType.textColor = [UIColor colorWithRed:255/255.0 green:132/255.0 blue:60/255.0 alpha:1];
        _sendSignViewTop.constant = 10;
        _sendAddressLabelTop.constant = 7;
        _appointTimeIconLabel.hidden = YES;
        _appointTimeLabel.hidden = YES;
        _beginBtn.hidden = YES;
    }else {
        _orderType.text = @"预约";
        _orderType.textColor = [UIColor colorWithRed:60/255.0 green:175/255.0 blue:151/255.0 alpha:1];
        _sendSignViewTop.constant = 36;
        _sendAddressLabelTop.constant = 32;
        _appointTimeIconLabel.hidden = NO;
        _appointTimeLabel.hidden = NO;
        _appointTimeLabel.text = [Utils formatDate:[NSDate dateWithTimeIntervalSince1970:_model.appointTime/1000]];
        _beginBtn.hidden = NO;
        //设置开始执行按钮状态
        if ([_model.appointStatus isEqualToString:@"1"] || [_model.status isEqualToString:@"9"]) {
            _beginBtn.backgroundColor = [UIColor grayColor];
            [_beginBtn setTitleColor:bgColor forState:UIControlStateNormal];
            _beginBtn.enabled = NO;
        }else{
            _beginBtn.backgroundColor = mainColor;
            [_beginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _beginBtn.enabled = YES;
        }

    }
    
    if ([_model.status isEqualToString:@"1"]) {  //控制打电话按钮的显示与隐藏
        _callBtn.hidden = YES;
    }else {
        _callBtn.hidden = NO;
    }
    
    //设置接到货物按钮状态
    if ([_model.status isEqualToString:@"2"] && ([_model.appointStatus isEqualToString:@"1"] || _model.appointStatus.length == 0)) {
        _reciveGoodsBtn.backgroundColor = mainColor;
        [_reciveGoodsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reciveGoodsBtn.enabled = YES;
    }else {
        _reciveGoodsBtn.backgroundColor = [UIColor grayColor];
        [_reciveGoodsBtn setTitleColor:bgColor forState:UIControlStateNormal];
        _reciveGoodsBtn.enabled = NO;
    }
    
    //设置订单完成按钮状态
    if ([_model.status isEqualToString:@"3"]) {
        _finishBtn.backgroundColor = mainColor;
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishBtn.enabled = YES;
    }else {
        _finishBtn.backgroundColor = [UIColor grayColor];
        [_finishBtn setTitleColor:bgColor forState:UIControlStateNormal];
        _finishBtn.enabled = NO;
    }
    
    
    //设置状态显示
    if ([_model.status isEqualToString:@"1"]) {
        _orderStatus.text = @"待确认 >";
        _orderStatus.textColor = [UIColor grayColor];
    }else if ([_model.status isEqualToString:@"2"]) {
        _orderStatus.text = @"已接单 >";
        _orderStatus.textColor = [UIColor grayColor];
    }else if ([_model.status isEqualToString:@"3"]) {
        _orderStatus.text = @"已拉货 >";
        _orderStatus.textColor = [UIColor grayColor];
    }else if ([_model.status isEqualToString:@"4"]) {
        _orderStatus.text = @"已完成 >";
    }else if ([_model.status isEqualToString:@"9"]) {
        _orderStatus.text = @"已取消 >";
        _orderStatus.textColor = [UIColor colorWithRed:159.0/255 green:159.0/255 blue:159.0/255 alpha:1];
    }else if ([_model.status isEqualToString:@"8"]) {
        _orderStatus.text = @"已申请投诉 >";
        _orderStatus.textColor = [UIColor colorWithRed:159.0/255 green:159.0/255 blue:159.0/255 alpha:1];
        _beginBtn.backgroundColor = [UIColor grayColor];
        [_beginBtn setTitleColor:bgColor forState:UIControlStateNormal];
        _beginBtn.enabled = NO;
        
        _reciveGoodsBtn.backgroundColor = [UIColor grayColor];
        [_reciveGoodsBtn setTitleColor:bgColor forState:UIControlStateNormal];
        _reciveGoodsBtn.enabled = NO;
        
        _finishBtn.backgroundColor = [UIColor grayColor];
        [_finishBtn setTitleColor:bgColor forState:UIControlStateNormal];
        _finishBtn.enabled = NO;
    }
    
    
}


- (IBAction)callBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.linkPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}
- (IBAction)beginBtnAct:(id)sender {
    if (self.beginAppointOrderBlock) {
        self.beginAppointOrderBlock(_model);
    }
}

- (IBAction)reciverBtnAct:(id)sender {
    if (self.reciverGoodsBlock) {
        self.reciverGoodsBlock(_model);
    }
}
- (IBAction)fiinishBtnAct:(id)sender {
    if (self.finishOrderBlock) {
        self.finishOrderBlock(_model);
    }
}

@end

//
//  LinkManView.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/15.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "LinkManView.h"

@implementation LinkManView


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
    _sendNameLabel.text = _model.linkMan;
    [_sendPhoneBtn setTitle:_model.linkPhone forState:UIControlStateNormal];
    
    _reciveNameLabel.text = _model.receiveMan;
    [_recivePhoneBtn setTitle:_model.receivePhone forState:UIControlStateNormal];
}

- (IBAction)sendPhoneBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.linkPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
    
}


- (IBAction)reciverBtnAct:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.receivePhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
    
}



@end

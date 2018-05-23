//
//  AddOrderView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "AddOrderView.h"

@implementation AddOrderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _sendSignView.layer.cornerRadius = 4;
    _sendSignView.layer.masksToBounds = YES;
    
    _receiveSignView.layer.cornerRadius = 4;
    _receiveSignView.layer.masksToBounds = YES;
    
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.frame = self.bounds;
    _nowBtn.layer.cornerRadius = 15;
    _nowBtn.layer.masksToBounds = YES;
    _appointBtn.layer.cornerRadius = 15;
    _appointBtn.layer.masksToBounds = YES;
    [self selectNowBtn];
    
    _sendTextField.delegate = self;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct1:)];
    [_sendTextField addGestureRecognizer:tap1];
    
    _receiveTextField.delegate = self;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct2:)];
    [_receiveTextField addGestureRecognizer:tap2];
    
}

- (void)tapAct1:(UITapGestureRecognizer *)tap {
    if (self.sendTapActBlock) {
        self.sendTapActBlock();
    }
}

- (void)tapAct2:(UITapGestureRecognizer *)tap {
    if (self.receiveTapActBlock) {
        self.receiveTapActBlock();
    }
}



- (void)selectNowBtn {
    _nowBtn.layer.borderColor = devide_line_color.CGColor;
    _nowBtn.layer.borderWidth = 0.5;
    _nowBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
   
    _appointBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _appointBtn.layer.borderWidth = 0;
    _appointBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _isNow = YES;
}

- (void)selectAppointBtn {
    _appointBtn.layer.borderColor = devide_line_color.CGColor;
    _appointBtn.layer.borderWidth = 0.5;
    _appointBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    _nowBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _nowBtn.layer.borderWidth = 0;
    _nowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _isNow = NO;

}

- (IBAction)nowBtnAct:(UIButton *)sender {
    [self selectNowBtn];
}

- (IBAction)appointBtnAct:(UIButton *)sender {
    [self selectAppointBtn];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}



@end

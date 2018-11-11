//
//  OrderConfirmView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/13.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "OrderConfirmView.h"

@implementation OrderConfirmView


- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _bgView.layer.shadowOpacity = 0.3f;
    _bgView.layer.shadowOffset = CGSizeMake(0,0);
    _bgView.layer.frame = _bgView.frame;
    _isSelect = YES;
    [NavBgImage showIconFontForView:_selectBtn iconName:@"\U0000e793" color:[UIColor colorWithRed:66.0/255 green:67.0/255 blue:81.0/255 alpha:1] font:20];
    
    _priceDetailBtn.layer.cornerRadius = 4;
    _priceDetailBtn.layer.masksToBounds = YES;
    
    _priceDetailBtn.layer.borderWidth = 0.5;
    _priceDetailBtn.layer.borderColor = mainColor.CGColor;
    
    _invoiceBtn.layer.cornerRadius = 4;
    _invoiceBtn.layer.masksToBounds = YES;
    
    _invoiceBtn.layer.borderWidth = 0.5;
    _invoiceBtn.layer.borderColor = mainColor.CGColor;
    
    
    
}

- (IBAction)confirmBtnAct:(UIButton *)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}
- (IBAction)selectBtnAct:(UIButton *)sender {
    if (_isSelect) {
        _isSelect = NO;
        [NavBgImage showIconFontForView:_selectBtn iconName:@"\U0000e793" color:devide_line_color font:20];
    }else{
        _isSelect = YES;
        [NavBgImage showIconFontForView:_selectBtn iconName:@"\U0000e793" color:[UIColor colorWithRed:66.0/255 green:67.0/255 blue:81.0/255 alpha:1] font:20];

    }
}


- (IBAction)invoiceBtnAct:(UIButton *)sender {
    if (self.invoiceBtnBlock) {
        if ([sender.titleLabel.text isEqualToString:@"发票"]) {
            self.invoiceBtnBlock(@"0");
        }else{
            self.invoiceBtnBlock(@"1");
        }
    }
}



- (IBAction)contentBtbAct:(UIButton *)sender {
    if (self.agreementContentBlock) {
        self.agreementContentBlock();
    }
}

- (IBAction)priceDetailBtnAct:(UIButton *)sender {
    if (self.priceDetailBtnBlock) {
        self.priceDetailBtnBlock();
    }
}


@end

//
//  InvoiceDetailView.m
//  QingShanProject
//
//  Created by gunmm on 2018/7/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "InvoiceDetailView.h"

@implementation InvoiceDetailView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _personBtn.layer.cornerRadius = 6;
    _personBtn.layer.masksToBounds = YES;
    _personBtn.layer.borderWidth = 0.5;
    _personBtn.layer.borderColor = mainColor.CGColor;
    
    _companyBtn.layer.cornerRadius = 6;
    _companyBtn.layer.masksToBounds = YES;
    _companyBtn.layer.borderWidth = 0.5;
    _companyBtn.layer.borderColor = devide_line_color.CGColor;
    
    
    _confirmBtn.layer.cornerRadius = 6;
    _confirmBtn.layer.masksToBounds = YES;
    
    _receiverNameTextTop.constant = 42;
    
}

- (void)setParamDictionary:(NSDictionary *)paramDictionary {
    _paramDictionary = paramDictionary;
    if (_paramDictionary) {
        if ([[_paramDictionary objectForKey:@"invoiceType"] isEqualToString:@"2"]) {
            _companyNameTextF.text = [_paramDictionary objectForKey:@"companyName"];
            _companyNumberTextF.text = [_paramDictionary objectForKey:@"companyNumber"];
            [_companyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _companyBtn.layer.borderWidth = 0.5;
            _companyBtn.layer.borderColor = mainColor.CGColor;
            [_companyBtn setBackgroundColor:mainColor];
            
            [_personBtn setTitleColor:mainColor forState:UIControlStateNormal];
            _personBtn.layer.borderWidth = 0.5;
            _personBtn.layer.borderColor = devide_line_color.CGColor;
            [_personBtn setBackgroundColor:[UIColor whiteColor]];
            
            _companyNameTextF.hidden = NO;
            _companyNumberTextF.hidden = NO;
            _receiverNameTextTop.constant = 84;
        }else{
            [_personBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _personBtn.layer.borderWidth = 0.5;
            _personBtn.layer.borderColor = mainColor.CGColor;
            [_personBtn setBackgroundColor:mainColor];
            
            [_companyBtn setTitleColor:mainColor forState:UIControlStateNormal];
            _companyBtn.layer.borderWidth = 0.5;
            _companyBtn.layer.borderColor = devide_line_color.CGColor;
            [_companyBtn setBackgroundColor:[UIColor whiteColor]];
            
            _companyNameTextF.hidden = YES;
            _companyNumberTextF.hidden = YES;
            _receiverNameTextTop.constant = 42;
        }
        
        _receiverNameTextF.text = [_paramDictionary objectForKey:@"receiverName"];
        _receiverPhoneTextF.text = [_paramDictionary objectForKey:@"receiverPhone"];
        _receiverAddressTextF.text = [_paramDictionary objectForKey:@"receiverAddress"];
        
    }
}

- (IBAction)cancelBtnAct:(id)sender {
    if (self.cancelInvoiceBlock) {
        self.cancelInvoiceBlock();
    }
}

- (IBAction)personBtnAct:(id)sender {
    [_personBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _personBtn.layer.borderWidth = 0.5;
    _personBtn.layer.borderColor = mainColor.CGColor;
    [_personBtn setBackgroundColor:mainColor];
    
    [_companyBtn setTitleColor:mainColor forState:UIControlStateNormal];
    _companyBtn.layer.borderWidth = 0.5;
    _companyBtn.layer.borderColor = devide_line_color.CGColor;
    [_companyBtn setBackgroundColor:[UIColor whiteColor]];
    
    _companyNameTextF.hidden = YES;
    _companyNumberTextF.hidden = YES;
    _receiverNameTextTop.constant = 42;
    
}

- (IBAction)companyBtnAct:(id)sender {
    [_companyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _companyBtn.layer.borderWidth = 0.5;
    _companyBtn.layer.borderColor = mainColor.CGColor;
    [_companyBtn setBackgroundColor:mainColor];
    
    [_personBtn setTitleColor:mainColor forState:UIControlStateNormal];
    _personBtn.layer.borderWidth = 0.5;
    _personBtn.layer.borderColor = devide_line_color.CGColor;
    [_personBtn setBackgroundColor:[UIColor whiteColor]];
    
    _companyNameTextF.hidden = NO;
    _companyNumberTextF.hidden = NO;
    _receiverNameTextTop.constant = 84;
}


- (IBAction)confirmBtnAct:(id)sender {
    if (self.confirmInvoiceBlock) {
        if (_receiverNameTextF.text.length == 0) {
            [HUDClass showHUDWithText:@"收票人姓名不能为空！"];
            return;
        }
        
        if (_receiverPhoneTextF.text.length == 0) {
            [HUDClass showHUDWithText:@"收票人电话不能为空！"];
            return;
        }
        
        if (_receiverAddressTextF.text.length == 0) {
            [HUDClass showHUDWithText:@"收票人地址不能为空！"];
            return;
        }
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        if (_receiverNameTextTop.constant == 42) {
            [param setObject:@"1" forKey:@"invoiceType"]; //发票类型  1：个人  2：单位
            [param setObject:_receiverNameTextF.text forKey:@"receiverName"];
            [param setObject:_receiverPhoneTextF.text forKey:@"receiverPhone"];
            [param setObject:_receiverAddressTextF.text forKey:@"receiverAddress"];
        }else if(_receiverNameTextTop.constant == 84){
            if (_companyNameTextF.text.length == 0) {
                [HUDClass showHUDWithText:@"公司名称不能为空！"];
                return;
            }
            [param setObject:@"2" forKey:@"invoiceType"]; //发票类型  1：个人  2：单位
            [param setObject:_receiverNameTextF.text forKey:@"receiverName"];
            [param setObject:_receiverPhoneTextF.text forKey:@"receiverPhone"];
            [param setObject:_receiverAddressTextF.text forKey:@"receiverAddress"];
            [param setObject:_companyNameTextF.text forKey:@"companyName"];
            [param setObject:_companyNumberTextF.text forKey:@"companyNumber"];
        }
        
        self.confirmInvoiceBlock(param);
    }
}

@end

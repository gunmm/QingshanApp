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
    _bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bgView.layer.shadowOpacity = 0.3f;
    _bgView.layer.shadowOffset = CGSizeMake(0,0);
    _bgView.layer.frame = _bgView.frame;
    _isSelect = YES;
    [NavBgImage showIconFontForView:_selectBtn iconName:@"\U0000e793" color:[UIColor colorWithRed:66.0/255 green:67.0/255 blue:81.0/255 alpha:1] font:20];
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
- (IBAction)contentBtbAct:(UIButton *)sender {
}

@end

//
//  PayDetailView.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "PayDetailView.h"

@implementation PayDetailView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.payListTableView = [[PayListTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 180)];
    [self.bgView addSubview:self.payListTableView];
    _payType = @"2";
    __weak typeof(self) weakSelf = self;
    self.payListTableView.tableViewSelectBlock = ^(NSInteger row) {
        //支付方式   1:支付宝支付    2:微信支付   3:现金支付
        if (row == 0) {
            weakSelf.payType = @"2";
            [weakSelf.payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        }else if (row == 1) {
            weakSelf.payType = @"1";
            [weakSelf.payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        }else if (row == 2) {
            weakSelf.payType = @"3";
            [weakSelf.payBtn setTitle:@"下单" forState:UIControlStateNormal];
        }
    };
}


- (IBAction)payBtnAct:(id)sender {
    if (self.payBtnActBlock) {
        self.payBtnActBlock(self.payType);
    }
}

@end

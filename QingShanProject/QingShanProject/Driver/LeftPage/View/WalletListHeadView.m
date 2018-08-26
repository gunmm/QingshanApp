//
//  WalletListHeadView.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "WalletListHeadView.h"

@implementation WalletListHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    _withdrawalBtn.layer.cornerRadius = 6;
    _withdrawalBtn.layer.masksToBounds = YES;
}


- (IBAction)withdrawalBtnAct:(id)sender {
    if (self.withdrawalActBlock) {
        self.withdrawalActBlock();
    }
}

@end

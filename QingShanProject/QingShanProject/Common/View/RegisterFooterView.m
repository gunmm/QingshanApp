//
//  RegisterFooterView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/17.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "RegisterFooterView.h"

@implementation RegisterFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    _registerBtn.layer.cornerRadius = 6;
    _registerBtn.layer.masksToBounds = YES;

}
- (IBAction)registerBtnAct:(id)sender {
    if (self.registerBtnBlock) {
        self.registerBtnBlock();
    }
}

@end

//
//  DriverDeatilBtnView.m
//  QingShanProject
//
//  Created by gunmm on 2018/10/17.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverDeatilBtnView.h"

@implementation DriverDeatilBtnView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _changeBtn.layer.cornerRadius = 6;
    _changeBtn.layer.masksToBounds = YES;
    
    _deleteBtn.layer.cornerRadius = 6;
    _deleteBtn.layer.masksToBounds = YES;
    
}

- (IBAction)changeBtnAct:(id)sender {
    if (self.changeDriverBlock) {
        self.changeDriverBlock();
    }
    
}

- (IBAction)deleteBtnAct:(id)sender {
    if (self.deleteDriverBlock) {
        self.deleteDriverBlock();
    }
}



@end

//
//  TextAndIconCell.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/15.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "TextAndIconCell.h"

@implementation TextAndIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _isTrue = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct:)];
   
    [_operateBtn addGestureRecognizer:tap];
    _operateBtn.userInteractionEnabled = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




//点击方法
- (void)tapAct:(UITapGestureRecognizer *)tap{
    _isTrue = !_isTrue;
    if (self.operationBtnBlock) {
        self.operationBtnBlock();
    }
}

@end

//
//  SelectAddressHeadView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/27.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "SelectAddressHeadView.h"

@implementation SelectAddressHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    _cityBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)cityBtnClick:(UIButton *)sender {
    if (self.cityBtnBlock) {
        self.cityBtnBlock();
    }
}
@end

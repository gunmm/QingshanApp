//
//  FindOrderView.m
//  QingShanProject
//
//  Created by gunmm on 2018/12/22.
//  Copyright © 2018 gunmm. All rights reserved.
//

#import "FindOrderView.h"

@interface FindOrderView ()

@property (weak, nonatomic) IBOutlet UIButton *findOrderBtn;

@end

@implementation FindOrderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_findOrderBtn setBackgroundColor:bgColor];
    [_findOrderBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [_findOrderBtn setImage:[NavBgImage imageWithImage:[UIImage imageNamed:@"findGoods.png"] TintColor:mainColor] forState:UIControlStateNormal];
    _findOrderBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)findOrderBtnAct:(id)sender {
    if (self.findOrderBtnActBlock) {
        self.findOrderBtnActBlock();
    }
}

@end

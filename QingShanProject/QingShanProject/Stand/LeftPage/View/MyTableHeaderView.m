//
//  MyTableHeaderView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "MyTableHeaderView.h"

@implementation MyTableHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = 35;
    _headImageView.layer.masksToBounds = YES;
}

@end

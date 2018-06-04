//
//  DetailInfoHeaderView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/31.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DetailInfoHeaderView.h"

@implementation DetailInfoHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImgV.layer.cornerRadius = 10;
    _headImgV.layer.masksToBounds = YES;
}


@end

//
//  WaitTitleView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/18.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "WaitTitleView.h"

@implementation WaitTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;

}

@end

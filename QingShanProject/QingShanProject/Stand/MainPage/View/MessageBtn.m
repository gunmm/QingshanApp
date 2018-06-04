//
//  MessageBtn.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/4.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "MessageBtn.h"

@implementation MessageBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initRedView];
    }
    return self;
}

- (void)initRedView {
    _redView = [[UIView alloc] initWithFrame:CGRectMake(self.width + 6, 10, 6, 6)];
    _redView.layer.cornerRadius = 3;
    _redView.layer.masksToBounds = YES;
    _redView.backgroundColor = [UIColor redColor];
    [self addSubview:_redView];
}

@end

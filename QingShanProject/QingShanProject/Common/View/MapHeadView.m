//
//  MapHeadView.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "MapHeadView.h"

@implementation MapHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = bgColor;
        
        CALayer *sublayer =[CALayer layer];
        sublayer.backgroundColor = [UIColor whiteColor].CGColor;
        sublayer.shadowColor = [UIColor blackColor].CGColor;
        sublayer.shadowOpacity = 0.3f;
        sublayer.shadowRadius = 4.f;
        sublayer.shadowOffset = CGSizeMake(0,0);
        sublayer.frame = self.bounds;
        [self.layer addSublayer:sublayer];
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = sublayer.bounds;
        imageLayer.cornerRadius = 4;
        sublayer.cornerRadius = 4;
        imageLayer.masksToBounds = YES;
        [sublayer addSublayer:imageLayer];
        
        //图标
        [self addSearchImage];
        
        [self addNameLabel];
        
        
    }
    return self;
}


- (void)addNameLabel {
    _addressLabel = [[UITextField alloc]initWithFrame:CGRectMake(self.bounds.size.height+5, 0, self.bounds.size.width - self.bounds.size.height - 10, self.bounds.size.height)];
    _addressLabel.placeholder = @"搜索地址查找";
    _addressLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_addressLabel];
}

- (void)addSearchImage {
    UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 3, self.bounds.size.height-6, self.bounds.size.height-6)];
    searchImage.image = [UIImage imageNamed:@"search1.png"];
    [self addSubview:searchImage];
}




@end

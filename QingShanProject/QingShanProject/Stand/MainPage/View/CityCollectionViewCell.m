//
//  CityCollectionViewCell.m
//  ChooseDay
//
//  Created by 闵哲 on 16/1/20.
//  Copyright © 2016年 DreamThreeMusketeers. All rights reserved.
//

#import "CityCollectionViewCell.h"


@implementation CityCollectionViewCell{
    

}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _label = [[UILabel alloc]initWithFrame:self.bounds];
        
        _label.textAlignment = NSTextAlignmentCenter;
        
        _label.backgroundColor = bgColor;
        
        _label.layer.cornerRadius = 10;
        _label.layer.masksToBounds = YES;
        
        
        
        [self addSubview:_label];
    }
    return self;
}


- (void)setCityName:(NSString *)cityName{
    _cityName = cityName;
    _label.text = _cityName;
    
    
}

@end

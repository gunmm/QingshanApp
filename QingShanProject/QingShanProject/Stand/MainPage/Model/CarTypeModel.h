//
//  CarTypeModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/27.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarTypeModel : NSObject

@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *keyText;
@property (nonatomic, copy) NSString *valueText;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *cityName;


@property (nonatomic, assign) double startPrice;
@property (nonatomic, assign) double unitPrice;
@property (nonatomic, assign) double startDistance;

@property (nonatomic, copy) NSString *width; //车辆宽度
@property (nonatomic, copy) NSString *size;   //车辆大小  1：微型车，2：轻型车（默认值），3：中型车，4：重型车
@property (nonatomic, copy) NSString *weight;   //货车核定载重
@property (nonatomic, copy) NSString *axis;   //车辆轴数
@property (nonatomic, copy) NSString *height;  //车辆高度
@property (nonatomic, copy) NSString *load;   //车辆总重
@property (nonatomic, copy) NSString *strategy;  //驾车选择策略

@end


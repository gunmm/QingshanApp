//
//  GaodeRoadPlainModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/12/22.
//  Copyright © 2018 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GaodeRoadPlainModel : NSObject

@property (nonatomic, assign) CGFloat tolls; //此导航方案道路收费金额
@property (nonatomic, assign) NSInteger traffic_lights; //此导航方案道路收费距离长度
@property (nonatomic, assign) int distance; //此方案的行驶距离
@property (nonatomic, strong) NSArray *steps;  //具体方案
@property (nonatomic, assign) long long  duration;  //此方案的耗时
@property (nonatomic, copy) NSString *strategy;  //导航策略
@property (nonatomic, assign) NSInteger restriction; //限行结果


@end

NS_ASSUME_NONNULL_END

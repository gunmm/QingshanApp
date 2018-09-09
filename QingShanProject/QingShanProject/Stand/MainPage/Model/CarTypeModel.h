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

@end


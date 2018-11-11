//
//  CheckUpRes.h
//  WeighUpSystem
//
//  Created by gunmm on 2018/5/23.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckUpdateModel.h"

@interface CheckUpRes : NSObject


@property (nonatomic, strong) CheckUpdateModel *data;
@property (nonatomic, assign) NSInteger code;


@end

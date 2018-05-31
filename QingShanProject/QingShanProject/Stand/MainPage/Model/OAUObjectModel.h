//
//  OAUObjectModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/25.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "UserModel.h"

@interface OAUObjectModel : NSObject


@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, strong) UserModel *driver;


@end

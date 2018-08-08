//
//  NearbyCarListModel.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/23.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearbyCarListModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *plateNumber;




@property (nonatomic, assign) double nowLatitude;
@property (nonatomic, assign) double nowLongitude;
@property (nonatomic, assign) double distance;


@end


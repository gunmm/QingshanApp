//
//  MapHeadView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


typedef void(^CellClickBlock)(NSString *name, NSString *address, CLLocationCoordinate2D pt);


@interface MapHeadView : UIView

@property (nonatomic, retain) UITextField *addressLabel;

@property (nonatomic, copy) CellClickBlock cellClickBlock;


@end

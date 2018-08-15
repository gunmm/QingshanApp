//
//  LinkManView.h
//  QingShanProject
//
//  Created by gunmm on 2018/8/15.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface LinkManView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *sendNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendPhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *reciveNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *recivePhoneBtn;


@property (nonatomic, strong) OrderModel *model;


@end

//
//  RobOrderDetailView.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/10.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^RobBtnActBlock)(void);


@interface RobOrderDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *robBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) OrderModel *model;

@property (nonatomic, copy) RobBtnActBlock robBtnActBlock;



@end

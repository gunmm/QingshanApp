//
//  OrderFinishView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/29.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^CommentBtnActBlock)(BOOL hasComment);
typedef void(^PriceDetailBtnActBlock)(OrderModel *model);
typedef void(^ComplaintBtnActBlock)(void);


@interface OrderFinishView : UIView

@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, copy) CommentBtnActBlock commentBtnActBlock;
@property (nonatomic, copy) PriceDetailBtnActBlock priceDetailBtnActBlock;
@property (nonatomic, copy) ComplaintBtnActBlock complaintBtnActBlock;




@property (weak, nonatomic) IBOutlet UILabel *plateNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *driverBtn;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *complaintBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabl;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

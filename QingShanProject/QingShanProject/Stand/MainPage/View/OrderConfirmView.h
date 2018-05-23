//
//  OrderConfirmView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/13.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(void);

@interface OrderConfirmView : UIView
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectContentBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) ConfirmBlock confirmBlock;

@end

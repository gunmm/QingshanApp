//
//  OrderConfirmView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/13.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(void);
typedef void(^PriceDetailBtnBlock)(void);
typedef void(^InvoiceBtnBlock)(NSString *selectType);

typedef void(^AgreementContentBlock)(void);




@interface OrderConfirmView : UIView
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectContentBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *priceDetailBtn;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) ConfirmBlock confirmBlock;
@property (nonatomic, copy) PriceDetailBtnBlock priceDetailBtnBlock;
@property (nonatomic, copy) InvoiceBtnBlock invoiceBtnBlock;

@property (nonatomic, copy) AgreementContentBlock agreementContentBlock;



@property (weak, nonatomic) IBOutlet UIButton *invoiceBtn;

@end

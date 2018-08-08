//
//  InvoiceDetailView.h
//  QingShanProject
//
//  Created by gunmm on 2018/7/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelInvoiceBlock)(void);
typedef void(^ConfirmInvoiceBlock)(NSDictionary *invoiceParam);


@interface InvoiceDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *companyNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *receiverNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *receiverPhoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *receiverAddressTextF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverNameTextTop;


@property (nonatomic, strong) NSDictionary *paramDictionary;


@property (nonatomic, copy) CancelInvoiceBlock cancelInvoiceBlock;
@property (nonatomic, copy) ConfirmInvoiceBlock confirmInvoiceBlock;

@end

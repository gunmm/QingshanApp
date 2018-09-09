//
//  InvoiceDetailController.h
//  QingShanProject
//
//  Created by gunmm on 2018/9/7.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseTableViewController.h"

@interface InvoiceDetailController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UILabel *invoiceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *receverNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *expressNumberTextF;
@property (weak, nonatomic) IBOutlet UIButton *copyyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receveTop1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receveType2;

@property (weak, nonatomic) IBOutlet UILabel *companyNameKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNumberKeyLabel;



@property (nonatomic, copy) NSString *invoiceId;


@end

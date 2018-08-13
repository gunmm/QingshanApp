//
//  BankEditController.h
//  QingShanProject
//
//  Created by gunmm on 2018/8/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "BaseViewController.h"

@interface BankEditController : BaseViewController


@property (weak, nonatomic) IBOutlet UITextField *bankNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (weak, nonatomic) IBOutlet UILabel *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic,copy) NSString *bankNumberStr;

@end

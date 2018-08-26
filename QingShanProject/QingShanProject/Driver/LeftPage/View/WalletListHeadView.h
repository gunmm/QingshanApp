//
//  WalletListHeadView.h
//  QingShanProject
//
//  Created by gunmm on 2018/8/26.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WithdrawalActBlock)(void);

@interface WalletListHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalBtn;

@property (nonatomic, copy) WithdrawalActBlock withdrawalActBlock;


@end

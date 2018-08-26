//
//  PayDetailView.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayListTableView.h"

typedef void(^PayBtnActBlock)(NSString *payType);

@interface PayDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (nonatomic, strong) PayListTableView *payListTableView;
@property (nonatomic, copy) NSString *payType;

@property (nonatomic, copy) PayBtnActBlock payBtnActBlock;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

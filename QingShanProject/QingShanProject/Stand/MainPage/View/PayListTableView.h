//
//  PayListTableView.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayListCell.h"

typedef void(^TableViewSelectBlock)(NSInteger row);

@interface PayListTableView : UIView <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) PayListCell *currentSelectCell;
@property (nonatomic, copy) NSString *currentSelectType; //支付方式   1:支付宝支付    2:微信支付   3:现金支付

@property (nonatomic, copy) TableViewSelectBlock tableViewSelectBlock;




@end

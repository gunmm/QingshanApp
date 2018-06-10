//
//  MessageListCell.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/7.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *redView;

@property (nonatomic, strong) MessageModel *model;

@property (nonatomic, strong) CALayer *sublayer;



@end

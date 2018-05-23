//
//  TextAndIconCell.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/15.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^OperationBtnBlock)(void);

@interface TextAndIconCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentText;
@property (weak, nonatomic) IBOutlet UILabel *operateBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextFRight;

@property (nonatomic, copy) OperationBtnBlock operationBtnBlock;

@property (nonatomic, assign) BOOL isTrue;

@end

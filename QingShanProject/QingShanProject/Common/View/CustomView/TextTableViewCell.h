//
//  TextTableViewCell.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/13.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextF;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@end

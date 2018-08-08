//
//  PayListCell.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end



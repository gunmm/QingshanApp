//
//  DetailInfoHeaderView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/31.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface DetailInfoHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *renzhengStatusLabel;
@end

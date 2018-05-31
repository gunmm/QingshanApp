//
//  SelectAddressHeadView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/27.
//  Copyright © 2018年 gunmm. All rights reserved.
//

typedef void(^CityBtnBlock)(void);

#import <UIKit/UIKit.h>

@interface SelectAddressHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property (nonatomic, copy) CityBtnBlock cityBtnBlock;

@end

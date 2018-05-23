//
//  RegisterFooterView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/17.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RegisterBtnBlock)(void);

@interface RegisterFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, copy) RegisterBtnBlock registerBtnBlock;
@end

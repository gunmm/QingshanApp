//
//  DriverDeatilBtnView.h
//  QingShanProject
//
//  Created by gunmm on 2018/10/17.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeDriverBlock)(void);
typedef void(^DeleteDriverBlock)(void);


@interface DriverDeatilBtnView : UIView

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (nonatomic, copy) ChangeDriverBlock changeDriverBlock;
@property (nonatomic, copy) DeleteDriverBlock deleteDriverBlock;


@end

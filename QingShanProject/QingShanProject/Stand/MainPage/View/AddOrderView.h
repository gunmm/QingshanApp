//
//  AddOrderView.h
//  QingShanProject
//
//  Created by gunmm on 2018/5/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapActBlock)(void);

@interface AddOrderView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *sendSignView;
@property (weak, nonatomic) IBOutlet UIView *receiveSignView;
@property (weak, nonatomic) IBOutlet UIButton *nowBtn;
@property (weak, nonatomic) IBOutlet UIButton *appointBtn;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveTextField;

@property (nonatomic, copy) TapActBlock sendTapActBlock;
@property (nonatomic, copy) TapActBlock receiveTapActBlock;


@property (nonatomic, assign) BOOL isNow;



@end

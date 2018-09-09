//
//  ComplaintView.h
//  QingShanProject
//
//  Created by gunmm on 2018/9/5.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CloseBtnActBlock)(void);
typedef void(^SubmitBtnActBlock)(NSString *contentStr);

@interface ComplaintView : UIView <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, copy) CloseBtnActBlock closeBtnActBlock;
@property (nonatomic, copy) SubmitBtnActBlock submitBtnActBlock;


@end

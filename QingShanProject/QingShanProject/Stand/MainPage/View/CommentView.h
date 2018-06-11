//
//  CommentView.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

typedef void(^CloseBtnActBlock)(void);
typedef void(^CommitBtnActBlock)(NSInteger starNumber, NSString *contentStr);


@interface CommentView : UIView <UITextViewDelegate>
@property (nonatomic, strong) StarView *starView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;


@property (nonatomic, copy) CloseBtnActBlock closeBtnActBlock;
@property (nonatomic, copy) CommitBtnActBlock commitBtnActBlock;

@property (nonatomic, assign) NSInteger starNumber;
@property (nonatomic, assign) BOOL hasComment;




@end

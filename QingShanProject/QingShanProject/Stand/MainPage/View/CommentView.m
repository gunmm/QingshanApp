//
//  CommentView.m
//  QingShanProject
//
//  Created by gunmm on 2018/6/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _starView = [[[NSBundle mainBundle] loadNibNamed:@"StarView" owner:nil options:nil] lastObject];
    [self addSubview:_starView];

    
    __weak typeof(self) weakSelf = self;

    _starView.starBtnBlock = ^(NSInteger starNumber) {
        weakSelf.starNumber = starNumber;
        if (starNumber == 1) {
            weakSelf.statusLabel.text = @"非常不满意，各方面都很差";
        }else if (starNumber == 2) {
            weakSelf.statusLabel.text = @"不满意，比较差";
        }else if (starNumber == 3) {
            weakSelf.statusLabel.text = @"一般，还需改善";
        }else if (starNumber == 4) {
            weakSelf.statusLabel.text = @"比较满意，仍可改善";
        }else if (starNumber == 5) {
            weakSelf.statusLabel.text = @"非常满意，无可挑剔";
        }
    };
    
    
    [NavBgImage showIconFontForView:_closeBtn iconName:@"\U0000e70c" color:mainColor font:22];
    
    _contentTextView.layer.cornerRadius = 4;
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.delegate = self;
    
    _commitBtn.layer.cornerRadius = 4;
    _commitBtn.layer.masksToBounds = YES;
    
    
}

- (void)layoutSubviews {
    _starView.frame = CGRectMake(0, 61, self.width, 40);
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    NSInteger starNumber = 0;
    if (_isDriver) {
        if (_model.driverCommentStar > 0) {
            self.starView.userInteractionEnabled = NO;
            self.contentTextView.userInteractionEnabled = NO;
            self.commitBtn.userInteractionEnabled = NO;
            [_commitBtn setTitle:@"已提交" forState:UIControlStateNormal];
            _commitBtn.backgroundColor = [UIColor grayColor];
            [_commitBtn setTitleColor:bgColor forState:UIControlStateNormal];
            self.contentTextView.text = self.model.driverCommentContent;
            starNumber = _model.driverCommentStar;
            
            if (starNumber == 1) {
                [self.starView.starBtn1 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"非常不满意，各方面都很差";
            }else if (starNumber == 2) {
                [self.starView.starBtn2 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"不满意，比较差";
            }else if (starNumber == 3) {
                [self.starView.starBtn3 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"一般，还需改善";
            }else if (starNumber == 4) {
                [self.starView.starBtn4 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"比较满意，仍可改善";
            }else if (starNumber == 5) {
                [self.starView.starBtn5 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"非常满意，无可挑剔";
            }
            
            self.placeHolderLabel.hidden = YES;
        }
    }else {
        if (_model.commentStar > 0) {
            self.starView.userInteractionEnabled = NO;
            self.contentTextView.userInteractionEnabled = NO;
            self.commitBtn.userInteractionEnabled = NO;
            [_commitBtn setTitle:@"已提交" forState:UIControlStateNormal];
            _commitBtn.backgroundColor = [UIColor grayColor];
            [_commitBtn setTitleColor:bgColor forState:UIControlStateNormal];
            self.contentTextView.text = self.model.commentContent;
            starNumber = _model.commentStar;
            
            if (starNumber == 1) {
                [self.starView.starBtn1 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"非常不满意，各方面都很差";
            }else if (starNumber == 2) {
                [self.starView.starBtn2 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"不满意，比较差";
            }else if (starNumber == 3) {
                [self.starView.starBtn3 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"一般，还需改善";
            }else if (starNumber == 4) {
                [self.starView.starBtn4 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"比较满意，仍可改善";
            }else if (starNumber == 5) {
                [self.starView.starBtn5 sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.statusLabel.text = @"非常满意，无可挑剔";
            }
            
            self.placeHolderLabel.hidden = YES;
        }
    }
    
    
    
    
 
}

- (void)setIsDriver:(BOOL)isDriver {
    _isDriver = isDriver;
    if (_isDriver) {
        _statusLabel.text = @"你的评价会让货主做的更好";
    }
}

- (IBAction)commitBtnAct:(id)sender {
    if (_starNumber == 0) {
        [HUDClass showHUDWithText:@"请选择评价星级！"];
        return;
    }
    
    if (self.commitBtnActBlock) {
        self.commitBtnActBlock(_starNumber, _contentTextView.text);
    }
}

- (IBAction)closeBtnAct:(id)sender {
    if (self.closeBtnActBlock) {
        self.closeBtnActBlock();
    }
}


#pragma mark --------- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }else {
        _placeHolderLabel.hidden = NO;
    }
}



@end

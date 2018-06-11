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


- (void)setHasComment:(BOOL)hasComment {
    _hasComment = hasComment;
    if (_hasComment) {
        self.starView.userInteractionEnabled = NO;
        self.contentTextView.userInteractionEnabled = NO;
        self.commitBtn.userInteractionEnabled = NO;
        [_commitBtn setTitle:@"已提交" forState:UIControlStateNormal];
        _commitBtn.backgroundColor = [UIColor grayColor];
        [_commitBtn setTitleColor:bgColor forState:UIControlStateNormal];
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

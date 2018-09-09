//
//  ComplaintView.m
//  QingShanProject
//
//  Created by gunmm on 2018/9/5.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "ComplaintView.h"

@implementation ComplaintView


- (void)awakeFromNib {
    [super awakeFromNib];
    [NavBgImage showIconFontForView:_closeBtn iconName:@"\U0000e70c" color:mainColor font:22];
    
    _contentTextView.layer.cornerRadius = 4;
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.delegate = self;
    
    _submitBtn.layer.cornerRadius = 4;
    _submitBtn.layer.masksToBounds = YES;
}


- (IBAction)closeBtnAct:(id)sender {
    if (self.closeBtnActBlock) {
        self.closeBtnActBlock();
    }
}


- (IBAction)submitAct:(id)sender {
    if (_contentTextView.text.length == 0) {
        [HUDClass showHUDWithText:@"请填写投诉详情！"];
        return;
    }
    if (self.submitBtnActBlock) {
        self.submitBtnActBlock(_contentTextView.text);
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

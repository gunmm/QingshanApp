//
//  DriverManageListCell.m
//  QingShanProject
//
//  Created by gunmm on 2018/10/14.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverManageListCell.h"

@implementation DriverManageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _pointBtn.layer.cornerRadius = 6;
    _pointBtn.layer.masksToBounds = YES;
    
    _headImageView.layer.cornerRadius = 6;
    _headImageView.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(UserModel *)model {
    _model = model;
    _nameLabel.text = _model.nickname;
    [_phoneBtn setTitle:_model.phoneNumber forState:UIControlStateNormal];
    [Utils setImageWithImageView:_headImageView withUrl:_model.personImageUrl];
    
    if ([_model.vehicleBindingDriverId isEqualToString:_model.userId]) {
        _pointBtn.enabled = NO;
        _pointBtn.backgroundColor = [UIColor grayColor];
        [_pointBtn setTitleColor:bgColor forState:UIControlStateNormal];
        [_pointBtn setTitle:@"当前司机" forState:UIControlStateNormal];
    }else{
        _pointBtn.enabled = YES;
        _pointBtn.backgroundColor = mainColor;
        [_pointBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pointBtn setTitle:@"切换" forState:UIControlStateNormal];
    }

    
}

- (IBAction)phoneBtnAct:(UIButton *)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
}


- (IBAction)pointBtnAct:(id)sender {
    
    if (self.pointBtnActBlock) {
        self.pointBtnActBlock(_model);
    }
    
}


@end

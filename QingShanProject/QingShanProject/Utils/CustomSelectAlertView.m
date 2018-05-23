//
//  customSelectAlertView.m
//  ConcreteCloud
//
//  Created by gunmm on 2017/12/22.
//  Copyright © 2017年 北京仝仝科技有限公司. All rights reserved.
//

#import "CustomSelectAlertView.h"

@interface CustomSelectAlertView (){
    CustomIOS7AlertView *_customIOS7AlertView;
    BtnSelectBlock _btnSelectBlock;
}

@property (nonatomic, copy) NSArray *array;
@property (nonatomic) NSUInteger currentIndex;


@end

@implementation CustomSelectAlertView

- (void)initAlertWithTitleArray:(NSMutableArray *)titleArray withBtnSelectBlock:(BtnSelectBlock)btnSelectBlock{
    _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
    [_customIOS7AlertView setButtonTitles:nil];
    [_customIOS7AlertView setContainerView:[self initAlertViewWithArray:titleArray]];
    [_customIOS7AlertView showFromBottom];
    _btnSelectBlock = btnSelectBlock;
}


- (id)initAlertViewWithArray:(NSMutableArray *)array{
    if(self = [super initWithFrame:CGRectMake(0, 0, kDeviceWidth, 300)]){
        self.array = array;
        [self initSubViewsWithArray:array];
    }
    return self;
}

- (void)initSubViewsWithArray:(NSArray *)array{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 322)];
    scrollView.delegate = self;
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 322)];
    
    for(int i=0;i<array.count;i++){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 46*i, kDeviceWidth, 45)];
        btn.tag = i+1;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitleColor:dark_gray_noalpha forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_select_bg_img.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(selectBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        if ([array[i] isEqualToString:@"删除"]) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [contentView addSubview:btn];
    }
    
    contentView.frame = CGRectMake(0, 0, kDeviceWidth, [[[contentView subviews]lastObject]frame].origin.y+ [[[contentView subviews]lastObject]frame].size.height);
    if(contentView.frame.size.height<322){
        self.frame = CGRectMake(0, 0, kDeviceWidth, contentView.frame.size.height);
        scrollView.frame = CGRectMake(0, 0, kDeviceWidth, contentView.frame.size.height);
    }
    [scrollView addSubview:contentView];
    scrollView.contentSize = contentView.frame.size;
    [self addSubview:scrollView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, scrollView.frame.size.height + 4, kDeviceWidth, 45)];
    cancelBtn.tag = array.count+1;
    [cancelBtn addTarget:self action:@selector(selectBtnAct:) forControlEvents:UIControlEventTouchUpInside];

    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn setTitleColor:dark_gray_noalpha forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_select_bg_img.png"] forState:UIControlStateHighlighted];
    
    [self addSubview:cancelBtn];
    
    self.frame = CGRectMake(0, 0, kDeviceWidth, cancelBtn.frame.origin.y + cancelBtn.frame.size.height);
}

- (void)selectBtnAct:(UIButton *)btn {
    [_customIOS7AlertView close];
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        return;
    }
    if (_btnSelectBlock) {
        _btnSelectBlock(btn.tag);
    }
}
@end

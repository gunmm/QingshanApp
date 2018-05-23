//
//  customSelectAlertView.h
//  ConcreteCloud
//
//  Created by gunmm on 2017/12/22.
//  Copyright © 2017年 北京仝仝科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnSelectBlock)(NSInteger tagg);

@interface CustomSelectAlertView : UIView<UIScrollViewDelegate>


@property (nonatomic, copy) NSString *selectedTitle;

@property (nonatomic) BOOL isDesc;


- (id)initAlertViewWithArray:(NSMutableArray *)array;

- (void)initAlertWithTitleArray:(NSMutableArray *)array withBtnSelectBlock:(BtnSelectBlock)btnSelectBlock;


@end

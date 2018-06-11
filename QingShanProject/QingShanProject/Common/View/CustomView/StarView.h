//
//  StarView.h
//  QingShanProject
//
//  Created by gunmm on 2018/6/11.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StarBtnBlock)(NSInteger starNumber);

@interface StarView : UIView

@property (weak, nonatomic) IBOutlet UIButton *starBtn1;
@property (weak, nonatomic) IBOutlet UIButton *starBtn2;
@property (weak, nonatomic) IBOutlet UIButton *starBtn3;
@property (weak, nonatomic) IBOutlet UIButton *starBtn4;
@property (weak, nonatomic) IBOutlet UIButton *starBtn5;

@property (nonatomic, assign) NSInteger starNumber;

@property (nonatomic, copy) StarBtnBlock starBtnBlock;


@end

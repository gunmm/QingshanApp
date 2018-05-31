//
//  StandLeftPageController.m
//  QingShanProject
//
//  Created by gunmm on 2018/5/3.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "StandLeftPageController.h"
#import "MyTableHeaderView.h"

@interface StandLeftPageController ()

@end

@implementation StandLeftPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
}

- (void)initNavBar {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initView {
    [self initLabelIcon];
    [self initHeadView];
}

- (void)initLabelIcon {
    [NavBgImage showIconFontForView:_orderIconLabel iconName:@"\U0000e64f" color:mainColor font:22];
    [NavBgImage showIconFontForView:_walletIconLabel iconName:@"\U0000e671" color:mainColor font:18];
    [NavBgImage showIconFontForView:_serviceIconLabel iconName:@"\U0000e65a" color:mainColor font:22];
    [NavBgImage showIconFontForView:_settingIconLabel iconName:@"\U0000e62b" color:mainColor font:22];
}

- (void)initHeadView {
    MyTableHeaderView *headView = [[[NSBundle mainBundle] loadNibNamed:@"MyTableHeaderView" owner:nil options:nil] lastObject];
    headView.frame = CGRectMake(0, 0, kDeviceWidth/5*4, 144);
    self.tableView.tableHeaderView = headView;
    
    //单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAct:)];
    [headView addGestureRecognizer:tap];
    
}

//点击方法
- (void)tapAct:(UITapGestureRecognizer *)tap{
    if (self.standLeftSelectBlock) {
        self.standLeftSelectBlock(-1);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isDriver && indexPath.row == 0) {
        return 0;
    }
    
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row ==0) {
        if (self.standLeftSelectBlock) {
            self.standLeftSelectBlock(0);
        }
    }
    if (indexPath.row == 3) {
        [Utils backToLogin];
    }
}


//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}




@end

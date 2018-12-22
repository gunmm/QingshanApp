//
//  AboutViewController.m
//  QingShanProject
//
//  Created by gunmm on 2018/8/12.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self initData];
}

- (void)initNavBar {
    self.title = @"关于";
}

- (void)initData {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"V%@",appCurVersion];
//    _versionLabel.text = appCurVersion;
}


- (void)initView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kDeviceHeight-30-STATUS_AND_NAVBAR_HEIGHT-TABBAR_BOTTOM_HEIGHT, kDeviceWidth, 20)];
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.textColor = [UIColor grayColor];
    bottomLabel.text = @"@Copyright 2018 渭南庆山集团";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    
    [_phoneBtn setTitle:[[Config shareConfig] getServicePhone] forState:UIControlStateNormal];
}

- (IBAction)urlBtnAct:(id)sender {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://39.107.113.157/homePage/index.html"] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        // Fallback on earlier versions
    }
}
- (IBAction)phoneBtnAct:(UIButton *)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",sender.titleLabel.text];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        // Fallback on earlier versions
    }
}



@end

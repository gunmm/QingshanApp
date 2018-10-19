//
//  DriverListController.m
//  QingShanProject
//
//  Created by gunmm on 2018/10/14.
//  Copyright © 2018年 gunmm. All rights reserved.
//

#import "DriverListController.h"

@interface DriverListController ()
@property (nonatomic, copy) NSString *filterDriverPhone;



@end

@implementation DriverListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBar];
    [self initData];
    [self initView];
    [self loadData];
}

- (void)initNavBar {
    self.title = @"添加司机";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)initData {
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[Config shareConfig] getUserId] forKey:@"driverId"];
    
    
    [NetWorking postDataWithParameters:@{} withUrl:@"getUnBindSmallDriverList" withBlock:^(id result) {
        
        NSLog(@"");
    } withFailedBlock:^(NSString *errorResult) {
        
    }];
}

- (void)initView {
    
}


@end
